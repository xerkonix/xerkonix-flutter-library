import 'dart:async';

import 'package:http/http.dart' as http;

import '../http_utils/xerkonix_http_config.dart';

/// Called when a request completes carrying a rotated auth token in a response
/// header. [token] is the trimmed header value.
typedef XkSessionTokenCallback = void Function(String token);

/// Called after a successful refresh with the rotated `(session, refresh)` pair.
typedef XkTokensCallback = void Function(String sessionToken, String refreshToken);

/// Performs a token refresh given the current refresh token, returning the new
/// session token (empty string == refresh failed / give up).
///
/// Implementations typically POST to an auth-refresh endpoint and may also
/// surface a rotated refresh token via [XkInterceptedClient.onTokens].
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
    this.onTokens,
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

  /// Invoked with a rotated token read from a RESPONSE header (see
  /// [sessionHeaderName]).
  final XkSessionTokenCallback? onSessionToken;

  /// Invoked after a successful refresh with the new `(session, refresh)` pair.
  final XkTokensCallback? onTokens;

  /// The RESPONSE header name to read a rotating auth token from. Defaults to
  /// [XkHttpConfig.authHeaderName] when unset.
  final String? sessionHeaderName;

  bool _refreshing = false;

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

    final bool canRetry = response.statusCode == 401 &&
        !_refreshing &&
        refresh != null &&
        request is http.Request &&
        !_isAuthEndpoint(request.url);
    if (!canRetry) {
      return response;
    }

    final String refreshToken = getRefreshToken?.call().trim() ?? '';
    if (refreshToken.isEmpty) {
      return response;
    }

    _refreshing = true;
    String newSession;
    try {
      newSession = await refresh!(refreshToken);
    } finally {
      _refreshing = false;
    }
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

  @override
  void close() {
    _inner.close();
    super.close();
  }
}
