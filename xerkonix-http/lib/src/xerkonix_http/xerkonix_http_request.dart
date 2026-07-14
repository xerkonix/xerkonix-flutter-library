import 'dart:convert';

import 'package:http/http.dart' as http;

import '../http_utils/xerkonix_http_config.dart';

class XkHttpRequest {
  XkHttpRequest({required this.httpConfig});

  final XkHttpConfig httpConfig;

  Map<String, String> _generateBaseHeaders() {
    final Map<String, String> baseHeaders = {
      'Content-Type': httpConfig.contentType,
    };
    return baseHeaders;
  }

  /// Builds the auth header from the SINGLE source of truth on [XkHttpConfig]:
  /// [XkHttpConfig.authHeaderName] for the header name and
  /// [XkHttpConfig.effectiveAuthHeaderScheme] for the scheme/prefix. This is the
  /// same contract used by [XkInterceptedClient], so both the legacy
  /// [XkHttpClient] path and the intercepted path produce identical headers.
  ///
  /// The scheme already carries its own trailing separator when needed (the
  /// standard `Authorization` header resolves to `'Bearer '`), so the token is
  /// concatenated directly — no extra space is inserted (fixes the historical
  /// `"Bearer  <token>"` double-space).
  Map<String, String> _generateAuthorizationHeader(String token) {
    return <String, String>{
      httpConfig.authHeaderName:
          '${httpConfig.effectiveAuthHeaderScheme}$token',
    };
  }

  Map<String, String> generateHeaders({String? token, List<Map<String, String>>? headerList}) {
    final result = _generateBaseHeaders();
    if (token != null) {
      result.addAll(_generateAuthorizationHeader(token));
    }
    if (headerList != null) {
      for (final header in headerList) {
        result.addAll(header);
      }
    }
    return result;
  }

  Map<String, String> generateMultipartHeaders({String? token, List<Map<String, String>>? headerList}) {
    // NB: the Content-Type (multipart/form-data; boundary=…) is set by
    // http.MultipartRequest itself — setting it here would clobber the boundary,
    // so it is intentionally omitted.
    final result = <String, String>{};
    if (token != null) {
      result.addAll(_generateAuthorizationHeader(token));
    }
    if (headerList != null) {
      for (final header in headerList) {
        result.addAll(header);
      }
    }
    return result;
  }

  Uri generateUri(
      {String? scheme,
      String? host,
      int? port,
      required String path,
      Map<String, dynamic>? queryParameters,
      String? query}) {
    return Uri(
        scheme: scheme ?? httpConfig.scheme,
        host: host ?? httpConfig.host,
        port: port ?? httpConfig.port,
        path: path,
        queryParameters: queryParameters,
        query: query);
  }

  /// Merges [queryParameters] and a raw [rawQuery] string onto [uri] WITHOUT
  /// discarding the URI's own scheme/host/port/existing query.
  ///
  /// Precedence: the URI's existing query params < raw [rawQuery] < explicit
  /// [queryParameters]. When there is nothing to add, [uri] is returned intact
  /// (so a query-less request never gains a spurious `?`).
  Uri applyQuery(
    Uri uri, {
    Map<String, dynamic>? queryParameters,
    String? rawQuery,
  }) {
    final Map<String, String> merged = <String, String>{
      ...uri.queryParameters,
    };
    if (rawQuery != null && rawQuery.trim().isNotEmpty) {
      merged.addAll(Uri.splitQueryString(rawQuery));
    }
    if (queryParameters != null) {
      queryParameters.forEach((String k, dynamic v) => merged[k] = '$v');
    }
    if (merged.isEmpty) {
      return uri;
    }
    return uri.replace(queryParameters: merged);
  }

  /// Builds a [Uri] for an ABSOLUTE [uriAddress] (e.g. a full `https://…` URL),
  /// preserving its scheme/host/port and merging in [queryParameters]/[query].
  ///
  /// Previously this used `Uri(path: uriAddress, queryParameters: …)` whenever a
  /// query was present, which silently dropped the scheme and host — the request
  /// then went nowhere/to the wrong origin. It now parses the absolute URL and
  /// only layers the query on top.
  Uri custom({
    required String uriAddress,
    Map<String, dynamic>? queryParameters,
    String? query,
  }) {
    return applyQuery(
      Uri.parse(uriAddress),
      queryParameters: queryParameters,
      rawQuery: query,
    );
  }

  /// Resolves a request [Uri] for [path], preferring [XkHttpConfig.baseUrl]
  /// (a single scheme+host+port+path-prefix string) when it is set, and
  /// otherwise falling back to the discrete scheme/host/port via [generateUri].
  ///
  /// [queryParameters] and a raw [query] string are merged onto the resolved
  /// URI via [applyQuery], so supplying a raw query no longer bypasses
  /// [XkHttpConfig.baseUrl] (the previous behaviour dropped back to the discrete
  /// host and ignored baseUrl entirely).
  Uri resolveUri({
    required String path,
    int? port,
    Map<String, dynamic>? queryParameters,
    String? query,
  }) {
    final String? base = httpConfig.baseUrl?.trim();
    final Uri baseUri;
    if (base != null && base.isNotEmpty) {
      final String normalizedBase = base.replaceFirst(RegExp(r'/$'), '');
      final String normalizedPath =
          path.startsWith('/') || path.isEmpty ? path : '/$path';
      baseUri = Uri.parse('$normalizedBase$normalizedPath');
    } else {
      baseUri = generateUri(path: path, port: port);
    }
    return applyQuery(
      baseUri,
      queryParameters: queryParameters,
      rawQuery: query,
    );
  }

  http.Request generateRequest(
      {required String method, required Map<String, String> headers, required Uri uri, Map<String, dynamic>? body}) {
    http.Request request = http.Request(method, uri);
    if (body != null) {
      request.body = jsonEncode(body);
    }
    request.headers.addAll(headers);
    return request;
  }
}
