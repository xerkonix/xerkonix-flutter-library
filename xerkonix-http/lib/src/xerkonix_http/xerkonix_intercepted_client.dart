import 'dart:async';

import 'package:http/http.dart' as http;

import '../http_utils/xerkonix_http_config.dart';

/// Called with a rotated auth (session) token — either read from a response
/// header, or produced by a successful refresh. [token] is the trimmed value.
/// Wire this to your token store so subsequent requests use the fresh token.
typedef XkSessionTokenCallback = void Function(String token);

/// Performs a token refresh given the current refresh token, returning the new
/// session token (empty string == refresh failed / give up).
///
/// Implementations typically POST to an auth-refresh endpoint. If that endpoint
/// rotates the REFRESH token too, the implementation persists the new refresh
/// token itself (it owns that response); the client persists the returned
/// SESSION token via [XkInterceptedClient.onSessionToken].
typedef XkRefreshCallback = Future<String> Function(String refreshToken);

/// A pluggable [http.BaseClient] wrapper adding:
///  * **auth-header injection** using a configurable header name/scheme
///    (`Authorization: Bearer …` or a custom header like
///    `x-cosentio-account-session`),
///  * **automatic token refresh + single retry on 401**, with a re-entrancy
///    guard and an auth-endpoint skip list (so refresh itself never recurses),
///  * **response-header token capture** ([onSessionToken]) for rotating tokens.
///
/// It composes over any inner [http.Client], so it can wrap a mock in tests or a
/// platform client in production, and is itself an [http.Client] — hand it to
/// any code that expects one.
class XkInterceptedClient extends http.BaseClient {
  XkInterceptedClient({
    required http.Client inner,
    required this.config,
    this.getAuthToken,
    this.getRefreshToken,
    this.refresh,
    this.onSessionToken,
    this.sessionHeaderName,
  }) : _inner = inner;

  final http.Client _inner;
  final XkHttpConfig config;

  /// Supplies the current auth token to stamp on each outgoing request. When
  /// `null` or returning empty, no auth header is added (callers may set it
  /// themselves).
  final String Function()? getAuthToken;

  /// Supplies the current refresh token for the 401 flow.
  final String Function()? getRefreshToken;

  /// Performs the actual refresh. Required to enable 401 retry.
  final XkRefreshCallback? refresh;

  /// Invoked with a rotated session token — from a RESPONSE header (see
  /// [sessionHeaderName]) or from a successful refresh. Wire it to your store.
  final XkSessionTokenCallback? onSessionToken;

  /// The RESPONSE header name to read a rotating auth token from. Defaults to
  /// [XkHttpConfig.authHeaderName] when unset.
  final String? sessionHeaderName;

  /// The in-flight refresh, shared by all callers that hit a 401 while it runs
  /// (single-flight). `null` when no refresh is running.
  Future<String>? _refreshInFlight;

  String get _sessionHeaderName =>
      sessionHeaderName ?? config.authHeaderName;

  bool _isAuthEndpoint(Uri url) {
    for (final String skip in config.authEndpointSkipList) {
      if (skip.isNotEmpty && url.path.contains(skip)) {
        return true;
      }
    }
    return false;
  }

  void _stampAuth(http.BaseRequest request) {
    final String token = getAuthToken?.call().trim() ?? '';
    if (token.isEmpty) return;
    // Don't overwrite an explicit header the caller already set.
    if (request.headers.keys.any(
      (String k) => k.toLowerCase() == config.authHeaderName.toLowerCase(),
    )) {
      return;
    }
    request.headers[config.authHeaderName] =
        '${config.effectiveAuthHeaderScheme}$token';
  }

  void _captureSessionToken(http.BaseResponse response) {
    final String token = response.headers[_sessionHeaderName]?.trim() ?? '';
    if (token.isNotEmpty) {
      onSessionToken?.call(token);
    }
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    _stampAuth(request);
    final http.StreamedResponse response = await _inner.send(request);
    _captureSessionToken(response);

    final bool eligible = response.statusCode == 401 &&
        refresh != null &&
        request is http.Request &&
        !_isAuthEndpoint(request.url);
    if (!eligible) {
      return response;
    }

    // Single-flight refresh: if one is already running, WAIT for it and retry
    // with its result instead of returning the 401 straight to the caller.
    // Concurrent 401s (requests A and B racing on an expired token) previously
    // let B return 401 while A refreshed — a spurious auth failure / logout.
    final String newSession = await _refreshSession();
    if (newSession.isEmpty) {
      return response;
    }

    // Drain the original 401 body before issuing the retry.
    await response.stream.drain<void>();

    final http.Request retry = http.Request(request.method, request.url)
      ..headers.addAll(request.headers)
      ..bodyBytes = request.bodyBytes
      ..followRedirects = request.followRedirects
      ..persistentConnection = request.persistentConnection;
    // Re-stamp with the refreshed token under the configured header.
    retry.headers[config.authHeaderName] =
        '${config.effectiveAuthHeaderScheme}$newSession';

    final http.StreamedResponse retried = await _inner.send(retry);
    _captureSessionToken(retried);
    return retried;
  }

  /// Returns a refreshed session token (empty string == refresh failed / give
  /// up), sharing a single in-flight refresh across concurrent callers.
  Future<String> _refreshSession() {
    final Future<String>? inFlight = _refreshInFlight;
    if (inFlight != null) {
      return inFlight;
    }
    final Future<String> future = _doRefresh();
    _refreshInFlight = future;
    // Free the slot when done (success OR failure) so a later 401 can refresh.
    future.whenComplete(() => _refreshInFlight = null);
    return future;
  }

  Future<String> _doRefresh() async {
    final String refreshToken = getRefreshToken?.call().trim() ?? '';
    if (refreshToken.isEmpty) {
      return '';
    }
    final String newSession = (await refresh!(refreshToken)).trim();
    if (newSession.isNotEmpty) {
      // Persist the rotated session token so subsequent requests use it. Without
      // this, every request keeps sending the stale token and re-triggers a
      // refresh (refresh storm / forced logout).
      onSessionToken?.call(newSession);
    }
    return newSession;
  }

  @override
  void close() {
    _inner.close();
    super.close();
  }
}
