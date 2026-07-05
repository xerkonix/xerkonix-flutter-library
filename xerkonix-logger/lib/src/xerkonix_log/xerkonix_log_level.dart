/// Severity levels used by [XkLog] for release/debug gating.
///
/// Ordered low → high. A configured minimum level suppresses every call whose
/// level compares lower than it (see [XkLogLevelX.isAtLeast]).
enum XkLogLevel {
  verbose,
  debug,
  info,
  warning,
  error,

  /// Disables all output when used as the minimum level.
  off,
}

extension XkLogLevelX on XkLogLevel {
  /// `true` when `this` is at least as severe as [minimum].
  bool isAtLeast(XkLogLevel minimum) => index >= minimum.index;
}
