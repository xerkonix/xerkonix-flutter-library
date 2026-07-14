/// Redaction/truncation helpers shared by every HTTP/HTML logger so that
/// sensitive material (auth tokens, cookies, session headers, credentials in
/// query strings) and unbounded request/response bodies never reach the log
/// sink verbatim — even when logging is (mis)enabled in a release build.
class XkLogSanitizer {
  XkLogSanitizer._();

  /// Placeholder written in place of a redacted value. Deliberately free of
  /// characters that get percent-encoded inside a query string, so a redacted
  /// URL stays human-readable in the log.
  static const String redacted = 'REDACTED';

  /// Default cap for body logging (characters). Bodies are opt-in AND truncated.
  static const int defaultMaxBodyLength = 1024;

  /// Header names that must always be masked (compared case-insensitively).
  static const Set<String> _sensitiveHeaderNames = <String>{
    'authorization',
    'proxy-authorization',
    'cookie',
    'set-cookie',
    'x-api-key',
    'api-key',
    'apikey',
    'x-auth-token',
    'auth-token',
    'x-access-token',
    'access-token',
    'x-refresh-token',
    'refresh-token',
    'x-session-token',
    'x-cosentio-account-session',
    'x-csrf-token',
    'x-xsrf-token',
  };

  /// Substrings that, when present in a header/query key, mark it as sensitive.
  static const List<String> _sensitiveKeyFragments = <String>[
    'authorization',
    'cookie',
    'token',
    'session',
    'secret',
    'password',
    'passwd',
    'api-key',
    'apikey',
    'api_key',
    'credential',
    'signature',
    'x-sig',
  ];

  static bool _isSensitiveKey(String key) {
    final String lower = key.toLowerCase();
    if (_sensitiveHeaderNames.contains(lower)) {
      return true;
    }
    for (final String fragment in _sensitiveKeyFragments) {
      if (lower.contains(fragment)) {
        return true;
      }
    }
    return false;
  }

  /// Returns a copy of [headers] with any sensitive values replaced by
  /// [redacted]. Non-sensitive headers are preserved verbatim.
  static Map<String, String> sanitizeHeaders(Map<String, String>? headers) {
    if (headers == null || headers.isEmpty) {
      return const <String, String>{};
    }
    return headers.map(
      (String k, String v) =>
          MapEntry(k, _isSensitiveKey(k) ? redacted : v),
    );
  }

  /// Returns a printable form of [uri] with sensitive query-parameter values
  /// redacted (e.g. `?access_token=…` → `?access_token=***REDACTED***`).
  static String sanitizeUri(Uri? uri) {
    if (uri == null) {
      return '';
    }
    if (uri.queryParameters.isEmpty) {
      return uri.toString();
    }
    final Map<String, String> safe = uri.queryParameters.map(
      (String k, String v) => MapEntry(k, _isSensitiveKey(k) ? redacted : v),
    );
    return uri.replace(queryParameters: safe).toString();
  }

  /// Produces the body fragment for a log line.
  ///
  /// Body logging is OFF by default ([logBody] == false) — the returned marker
  /// makes that explicit rather than silently dropping content. When explicitly
  /// enabled, the body is truncated to [maxLength] characters.
  static String bodyForLog(
    String? body, {
    bool logBody = false,
    int maxLength = defaultMaxBodyLength,
  }) {
    if (!logBody) {
      return '<body logging disabled>';
    }
    final String value = body ?? '';
    if (value.isEmpty) {
      return '';
    }
    if (maxLength <= 0 || value.length <= maxLength) {
      return value;
    }
    final int omitted = value.length - maxLength;
    return '${value.substring(0, maxLength)}…<truncated $omitted chars>';
  }
}
