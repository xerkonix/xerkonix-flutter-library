# Changelog

All notable changes to this project will be documented in this file.

## 1.1.0

### Added
- `XkInterceptedClient` — a pluggable `http.BaseClient` wrapper adding automatic
  token refresh + single retry on 401 (with a re-entrancy guard and an
  auth-endpoint skip list), auth-header injection with a configurable header
  NAME/scheme (e.g. a custom `x-cosentio-account-session` header, not only
  `Authorization: Bearer`), and rotating-token capture from RESPONSE headers.
- Callback hooks: `onSessionToken` (rotating token from a response header),
  `onTokens` (post-refresh `(session, refresh)` pair), and a pluggable
  `refresh`/`getAuthToken`/`getRefreshToken` surface.
- `XkHttpConfig` gains `baseUrl` (single scheme+host+port+path-prefix string),
  `authHeaderName` / `authHeaderScheme`, `unwrapDataEnvelope`,
  `authEndpointSkipList`, and a `copyWith`.
- `XkHttpRequest.resolveUri` — base-URL-aware URI construction (prefers
  `config.baseUrl` when set, else the discrete host/port).
- `XkHttpUtils.generateHttpFromBaseUrl` — build an `XkHttp` from a base URL plus
  the new auth/envelope options.
- `XkHttpResponse.process` — enriched response pipeline: typed errors for any
  `statusCode >= 400` (including 402/quota, 429/rate-limit and a real
  default/fallback branch for arbitrary/unknown codes) carrying business `code` +
  `metadata` via the error-handler's `XkErrorNormalizer`, plus optional
  `{statusCode, data}` success-envelope unwrap and 3xx pass-through. The default
  request pipeline now uses `process`.

### Changed
- `XkHttpClient.post/put/delete/patch` bodies are now **optional** (nullable),
  enabling bodyless POST/DELETE/PATCH. Existing callers passing a body are
  unaffected.
- Bumped SDK constraints to Dart `>=3.9.0 <4.0.0`, Flutter `>=3.35.0`.
- Bumped `http` to `^1.6.0`, `xerkonix_error_handler` to `^1.1.0`,
  `xerkonix_logger` to `^1.1.0`.
- Barrel now also exports the client/request/response types and the new
  intercepted client.

All existing `XkHttpConfig` / `XkHttpClient` / `XkHttp` / `generateHttp` /
`XkHttpResponse` APIs remain source-compatible.

## 1.0.0

### Initial Release

- Robust HTTP client package for Flutter applications
- Full HTTP method support (GET, POST, PUT, DELETE, PATCH, MULTIPART, CUSTOM)
- Automatic error handling with xerkonix_error_handler integration
- Request/response logging with xerkonix_logger integration
- Custom headers and authentication tokens support
- Query parameters support
- UTF-8 JSON decoding option
- Configurable timeout settings
- Logging control (enabled by default in debug mode, disabled in production)
- Multipart file upload support
- Custom HTTP request configuration
- Full Flutter 3.24+ and Dart 3.5+ compatibility
