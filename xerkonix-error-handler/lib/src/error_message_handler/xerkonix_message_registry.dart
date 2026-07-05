import '../error/error_type.dart';
import '../error/xerkonix_error.dart';
import 'xerkonix_message.dart';

/// A `code`-keyed, localizable message registry.
///
/// Resolution order (see [resolve]):
///   1. business `code` (e.g. `COSENTIO_GUEST_LIMIT_REACHED`)
///   2. HTTP `statusCode` (e.g. 401 → auth message)
///   3. `type` string
///   4. generic fallback ([fallback])
///
/// Unlike the legacy static single-slot [XkErrorMessageHandler], a registry is
/// an ordinary instance you can create, register tables into, and query
/// per-lookup — so multiple apps/tenants can each carry their own tables without
/// clobbering a global mutable slot.
class XkMessageRegistry {
  XkMessageRegistry({
    Map<String, XkErrorMessage>? codeMessages,
    Map<int, XkErrorMessage>? statusMessages,
    XkErrorMessage? fallback,
  })  : _codeMessages = <String, XkErrorMessage>{...?codeMessages},
        _statusMessages = <int, XkErrorMessage>{...?statusMessages},
        fallback = fallback ??
            XkErrorMessage(
              title: '오류',
              detail: '요청을 처리하지 못했습니다. 잠시 후 다시 시도해주세요.',
            );

  final Map<String, XkErrorMessage> _codeMessages;
  final Map<int, XkErrorMessage> _statusMessages;

  /// Returned when nothing else matches.
  final XkErrorMessage fallback;

  /// Registers/overrides a single `code`-keyed message.
  void registerCode(String code, XkErrorMessage message) {
    _codeMessages[code] = message;
  }

  /// Bulk-registers `code`-keyed messages (later entries win).
  void registerCodes(Map<String, XkErrorMessage> messages) {
    _codeMessages.addAll(messages);
  }

  /// Registers/overrides an HTTP status-keyed message.
  void registerStatus(int statusCode, XkErrorMessage message) {
    _statusMessages[statusCode] = message;
  }

  /// `true` if [code] has a registered message.
  bool hasCode(String code) => _codeMessages.containsKey(code);

  /// Resolves the best [XkErrorMessage] for [error] using the documented order.
  XkErrorMessage resolve(XkError error) {
    final String? code = error.code?.trim();
    if (code != null && code.isNotEmpty) {
      final XkErrorMessage? byCode = _codeMessages[code];
      if (byCode != null) {
        return byCode;
      }
    }

    final int? status = error.statusCode;
    if (status != null) {
      final XkErrorMessage? byStatus = _statusMessages[status];
      if (byStatus != null) {
        return byStatus;
      }
    }

    // Prefer server-supplied title/detail before the generic fallback.
    final String? detail = error.detail?.trim();
    final String? message = error.message?.trim();
    if ((detail != null && detail.isNotEmpty) ||
        (message != null && message.isNotEmpty)) {
      return XkErrorMessage(
        title: (error.title?.trim().isNotEmpty ?? false)
            ? error.title!.trim()
            : fallback.title,
        detail: (detail != null && detail.isNotEmpty) ? detail : message!,
      );
    }

    return fallback;
  }

  /// Resolves only the human-facing detail string for [error].
  String messageFor(XkError error) => resolve(error).detail;

  /// The default Korean registry shipped with the package. It bundles the full
  /// COSENTIO_* set (auth / quota / validation / engine / relationship /
  /// ai-input / admin) plus HTTP status fallbacks. Callers may [registerCodes]
  /// additional/override entries.
  factory XkMessageRegistry.korean() {
    final registry = XkMessageRegistry(
      fallback: XkErrorMessage(
        title: '오류',
        detail: '요청을 처리하지 못했습니다. 잠시 후 다시 시도해주세요.',
      ),
    );
    registry.registerCodes(<String, XkErrorMessage>{
      for (final MapEntry<String, String> e in koreanMessages.entries)
        e.key: XkErrorMessage(title: '오류', detail: e.value),
    });
    registry.registerStatus(
      401,
      XkErrorMessage(title: '오류', detail: '로그인 정보가 유효하지 않습니다. 다시 로그인해주세요.'),
    );
    registry.registerStatus(
      403,
      XkErrorMessage(title: '오류', detail: '이 작업을 실행할 권한이 없습니다.'),
    );
    registry.registerStatus(
      402,
      XkErrorMessage(title: '오류', detail: '사용 가능한 분석 크레딧을 모두 사용했습니다.'),
    );
    registry.registerStatus(
      429,
      XkErrorMessage(title: '오류', detail: '요청이 너무 많습니다. 잠시 후 다시 시도해주세요.'),
    );
    registry.registerStatus(
      404,
      XkErrorMessage(title: '오류', detail: '요청한 데이터를 찾지 못했습니다.'),
    );
    registry.registerStatus(
      409,
      XkErrorMessage(title: '오류', detail: '현재 상태에서는 요청을 처리할 수 없습니다.'),
    );
    registry.registerStatus(
      422,
      XkErrorMessage(title: '오류', detail: '입력 형식을 다시 확인해주세요.'),
    );
    registry.registerStatus(
      500,
      XkErrorMessage(title: '오류', detail: '서비스에서 문제가 발생했습니다. 잠시 후 다시 시도해주세요.'),
    );
    registry.registerStatus(
      503,
      XkErrorMessage(title: '오류', detail: '일시적으로 서비스에 연결할 수 없습니다. 잠시 후 다시 시도해주세요.'),
    );
    return registry;
  }

  /// The raw Korean code→message table (COSENTIO_* + admin + network + generic
  /// fallbacks + the package's synthetic network codes). Exposed so apps can
  /// reuse or diff it.
  static const Map<String, String> koreanMessages = <String, String>{
    // --- Auth ------------------------------------------------------------
    'COSENTIO_AUTH_INVALID_API_KEY': '인증 정보가 유효하지 않습니다. 다시 로그인해주세요.',
    'COSENTIO_AUTH_INVALID_CREDENTIALS': '이메일 또는 비밀번호가 올바르지 않습니다.',
    'COSENTIO_AUTH_INVALID_REFRESH_TOKEN': '로그인 정보가 만료되었습니다. 다시 로그인해주세요.',
    'COSENTIO_AUTH_INVALID_TOKEN': '로그인 정보가 유효하지 않습니다. 다시 로그인해주세요.',
    'COSENTIO_AUTH_NOT_AUTHENTICATED': '로그인이 필요합니다.',
    'COSENTIO_AUTH_REFRESH_TOKEN_REUSED': '로그인 정보가 만료되었습니다. 다시 로그인해주세요.',
    'COSENTIO_AUTH_FORBIDDEN': '이 작업을 실행할 권한이 없습니다.',
    'COSENTIO_AUTH_VERIFICATION_UNAVAILABLE': '인증 정보를 확인하지 못했습니다. 잠시 후 다시 시도해주세요.',
    'COSENTIO_AUTH_REFRESH_BACKEND_UNAVAILABLE': '로그인 상태를 확인하지 못했습니다. 잠시 후 다시 시도해주세요.',
    // --- Quota / rate --------------------------------------------------
    'COSENTIO_GUEST_LIMIT_REACHED': '비회원 무료 분석을 모두 사용했어요. 회원가입하면 계속 이용할 수 있어요.',
    'COSENTIO_QUOTA_EXCEEDED': '사용 가능한 분석 크레딧을 모두 사용했습니다.',
    'COSENTIO_QUOTA_DAILY_CREDIT_EXCEEDED': '오늘 사용할 수 있는 무료 분석 횟수를 모두 사용했습니다.',
    'COSENTIO_RATE_LIMITED': '요청이 너무 많습니다. 잠시 후 다시 시도해주세요.',
    // --- Validation / config -------------------------------------------
    'COSENTIO_REQUEST_VALIDATION_FAILED': '입력 형식을 다시 확인해주세요.',
    'COSENTIO_CONFIGURATION_MISSING': '서비스 설정이 올바르지 않습니다. 운영자에게 문의해주세요.',
    'COSENTIO_SESSION_INITIALIZATION_FAILED': '세션을 시작하지 못했습니다. 잠시 후 다시 시도해주세요.',
    // --- Engine --------------------------------------------------------
    'COSENTIO_ANALYSIS_ENGINE_UNAVAILABLE': '분석 서버에 연결하지 못했습니다. 잠시 후 다시 시도해주세요.',
    // --- Relationship --------------------------------------------------
    'COSENTIO_RELATIONSHIP_PERSON_NOT_FOUND': '사람 카드를 찾지 못했습니다.',
    'COSENTIO_RELATIONSHIP_NEXT_ACTION_NOT_FOUND': '다음 행동을 찾지 못했습니다.',
    'COSENTIO_RELATIONSHIP_REMINDER_NOT_FOUND': '리마인더를 찾지 못했습니다.',
    // --- AI input ------------------------------------------------------
    'COSENTIO_AI_INPUT_EMPTY': '분석할 내용을 입력해주세요.',
    'COSENTIO_AI_INPUT_URL_ONLY': '링크만으로는 분석하기 어렵습니다. 생각이나 상황을 함께 적어주세요.',
    'COSENTIO_AI_INPUT_PUNCTUATION_ONLY': '분석할 문장을 조금 더 구체적으로 작성해주세요.',
    'COSENTIO_AI_INPUT_REPEATED_TEXT': '반복된 입력보다 구체적인 상황이나 감정을 적어주세요.',
    'COSENTIO_AI_INPUT_EMOJI_ONLY': '이모지만으로는 분석하기 어렵습니다. 문장으로 조금 더 적어주세요.',
    'COSENTIO_AI_INPUT_INSUFFICIENT': '분석할 의미 단위가 부족합니다. 상황을 조금 더 구체적으로 작성해주세요.',
    'COSENTIO_AI_BAD_REQUEST': '요청 내용을 다시 확인해주세요.',
    'COSENTIO_AI_NOT_FOUND': '요청한 분석 데이터를 찾지 못했습니다.',
    'COSENTIO_AI_CONFLICT': '현재 상태에서는 요청을 처리할 수 없습니다.',
    'COSENTIO_AI_INTERNAL_ERROR': '분석 서버에서 문제가 발생했습니다. 잠시 후 다시 시도해주세요.',
    // --- Generic Cosentio ----------------------------------------------
    'COSENTIO_BAD_REQUEST': '요청 내용을 다시 확인해주세요.',
    'COSENTIO_NOT_FOUND': '요청한 데이터를 찾지 못했습니다.',
    'COSENTIO_CONFLICT': '현재 상태에서는 요청을 처리할 수 없습니다.',
    'COSENTIO_INTERNAL_ERROR': '서비스에서 문제가 발생했습니다. 잠시 후 다시 시도해주세요.',
    // --- Admin ---------------------------------------------------------
    'COSENTIO_ADMIN_ORGANIZATION_SLUG_CONFLICT': '이미 사용 중인 조직 slug입니다.',
    'COSENTIO_ADMIN_USER_EMAIL_CONFLICT': '이미 등록된 이메일입니다.',
    'COSENTIO_ADMIN_PASSWORD_CURRENT_INVALID': '현재 비밀번호가 올바르지 않습니다.',
    'COSENTIO_ADMIN_PASSWORD_UNCHANGED': '새 비밀번호는 현재 비밀번호와 달라야 합니다.',
    // --- Network (synthetic) -------------------------------------------
    'COSENTIO_NETWORK_TIMEOUT': '네트워크 응답 시간이 초과되었습니다. 잠시 후 다시 시도해주세요.',
    'COSENTIO_NETWORK_UNKNOWN': '요청을 처리하지 못했습니다. 네트워크 상태를 확인해주세요.',
    'XK_NETWORK_TIMEOUT': '네트워크 응답 시간이 초과되었습니다. 잠시 후 다시 시도해주세요.',
    'XK_NETWORK_UNKNOWN': '요청을 처리하지 못했습니다. 네트워크 상태를 확인해주세요.',
  };

  /// Convenience: the network type constants (kept here so `error_type` needn't
  /// be imported at call sites that only need the registry).
  static String get unstableNetworkType => ErrorType.unstableNetwork;
}
