# Changelog

All notable changes to this project will be documented in this file.

## 1.1.0

### Added
- `XkMessageRegistry` — a `code`-keyed, localizable message registry with
  resolution order business `code` → HTTP `statusCode`/`type` → generic
  fallback. Instance-based (per-lookup), not a global mutable slot. Ships
  `XkMessageRegistry.korean()` bundling the full COSENTIO_* Korean set
  (auth / quota / validation / engine / relationship / ai-input / admin) plus
  HTTP-status and network fallbacks.
- `metadata` (`Map<String, dynamic>`) and `statusCode` fields on `XkError` /
  `XkErrors`; the business `code` is preserved for lookup.
- `XkErrorNormalizer` — HTTP-envelope adapter (`fromEnvelope`, parsing
  `{error:{code,title,detail,message,metadata}}` / `{detail}` with the
  `statusCode >= 400` rule), `fromStatusCode(int)` mapping, and
  `normalizeException` (TimeoutException/SocketException/ClientException/
  FormatException → typed subtypes). Also surfaced as `XkErrors.fromStatusCode`.
- New error subtypes: `PaymentRequired` (402/quota) and `TooManyRequests`
  (429/rate-limit), plus synthetic `NetworkTimeout` / `NetworkUnknown`
  (with `XkErrorCodes` constants).
- Real toast + snackbar renderers: `error_toast.dart` now provides `XkErrorToast`
  (top-sliding overlay, auto-dismiss, error/warn colour, at parity with
  `showCosentioToast`), plus `showXkToast` and `showXkSnackBar`. The previously
  dead `WidgetType.toast` / `WidgetType.snackBar` branches in the message handler
  are now implemented.
- `XkErrorHooks` — a `code`/`status`-keyed side-effect/retry hook surface so codes
  like `GUEST_LIMIT_REACHED` (toast+navigate) or `401` (refresh-retry-once) can be
  wired without product-specific branching.

### Changed
- Bumped SDK constraints to Dart `>=3.9.0 <4.0.0`, Flutter `>=3.35.0`.
- Bumped `xerkonix_logger` constraint to `^1.1.0`.
- Barrel now also exports the message/dialog/toast types and the new registry,
  normalizer and hooks.

### Deprecated
- `XkErrorMessageHandler` (the static single-slot handler) in favour of the
  instance-based `XkMessageRegistry`. It keeps working unchanged.

All existing `XkError` / `XkErrors` / `XkException` / `XkErrorMessageHandler` /
`XkErrorDialog` APIs remain source-compatible.

## 1.0.0

### Initial Release

- Comprehensive error and exception handling system
- Structured error types with code, type, message, title, and detail
- Custom exception class (`XkException`) for error handling
- Predefined error factory (`XkErrors`) for common HTTP error types
- Error message handler (`XkErrorMessageHandler`) for displaying errors
- Support for dialog and snackbar error display widgets
- Integration with xerkonix_logger for error logging
- Full platform support (Web, iOS, Android, Linux, macOS, Windows)
- Full Flutter 3.24+ and Dart 3.5+ compatibility
