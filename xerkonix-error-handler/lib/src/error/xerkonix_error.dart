class XkError extends Error {
  XkError({
    this.code,
    this.type,
    this.message,
    this.title,
    this.detail,
    this.statusCode,
    Map<String, dynamic>? metadata,
  }) : metadata = metadata ?? const <String, dynamic>{};

  /// Business error code used for message-registry lookup (e.g.
  /// `COSENTIO_GUEST_LIMIT_REACHED`). Preserved verbatim for hooks/adapters.
  final String? code;
  final String? type;
  final String? message;
  final String? title;
  final String? detail;

  /// The originating HTTP status code, when the error came from an HTTP response.
  final int? statusCode;

  /// Free-form structured payload carried alongside the error (e.g. quota
  /// details, validation field errors). Never null; defaults to an empty map.
  final Map<String, dynamic> metadata;

  @override
  String toString() {
    return "code: ${code ?? ''}\ntype: ${type ?? ''}\nmessage: ${message ?? ''}\ntitle: ${title ?? ''}\ndetail: ${detail ?? ''}";
  }
}
