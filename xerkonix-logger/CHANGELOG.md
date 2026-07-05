# Changelog

All notable changes to this project will be documented in this file.

## 1.1.0

### Added
- `XkLog` — tag/prefix-aware, level-gated logging facade over the existing
  `Logger` family. Supports `XkLog.tagged('Cosentio')` and a per-call `tag:`
  parameter (messages render as `[Cosentio] …`).
- `XkLogLevel` enum + configurable `XkLog.defaultMinLevel` / per-instance
  `minLevel`, with built-in release/debug gating (`verbose`/`debug` suppressed in
  release by default, respecting `kReleaseMode`).
- `XkLoggerGlobalHandler` — one-call wiring of `FlutterError.onError`,
  `PlatformDispatcher.instance.onError` and a `runZonedGuarded` wrapper
  (`XkLoggerGlobalHandler.runGuarded` / `.install`) to funnel uncaught errors
  into a logger, with an optional `onError` hook for crash reporters.

### Changed
- Bumped SDK constraints to Dart `>=3.9.0 <4.0.0`, Flutter `>=3.35.0`.
- Bumped `logger` to `^2.7.0` and `http` to `^1.6.0`.

All existing `Logger` / `LoggerUtil` / `FunLogger` APIs are unchanged.

## 1.0.1

### Changes
- Fixed Pub Points: Reduced description length to meet pub.dev requirements
- Fixed test errors: Exported internal logger classes for testing
- Updated all code comments to English

## 1.0.0

### Initial Release

- Feature-rich logging package for Flutter applications
- Simple and intuitive logging API
- Multiple log levels (log, debug, info, warning, error, exception)
- Emoji-enhanced log messages for better readability
- HTTP request/response logging support
- Multipart request logging
- Build process logging
- Fun logger options (heart, robot, poop)
- Integration with logger and http packages
- Full Flutter 3.24+ and Dart 3.5+ compatibility
