// ignore_for_file: library_private_types_in_public_api

class ErrorType {
  static _ClientError client = _ClientError();

  static _ServerError server = _ServerError();

  static _HttpError http = _HttpError();

  static String unknownError = 'Unknown Error';
  static String unstableNetwork = "Unstable Network";
}

class _ClientError {
  String invalidFormat = "Invalid Format";
  String userInputError = "User Input Error";
}

class _ServerError {}

class _HttpError {
  // HTTP Status Codes - Informational 1xx
  String continueCode = "100";
  String switchingProtocolsCode = "101";
  String processingCode = "102";

  // HTTP Status Codes - Successful 2xx
  String okCode = "200";
  String createdCode = "201";
  String acceptedCode = "202";
  String nonAuthoritativeInformationCode = "203";
  String noContentCode = "204";
  String resetContentCode = "205";
  String partialContentCode = "206";
  String multiStatusCode = "207";
  String alreadyReportedCode = "208";
  String imUsedCode = "226";

  // HTTP Status Codes - Redirection 3xx
  String multipleChoicesCode = "300";
  String movedPermanentlyCode = "301";
  String foundCode = "302";
  String movedTemporarilyCode = "302";
  String seeOtherCode = "303";
  String notModifiedCode = "304";
  String useProxyCode = "305";
  String temporaryRedirectCode = "307";

  // HTTP Status Codes - Client Error 4xx
  String badRequestCode = "400";
  String unauthorizedCode = "401";
  String paymentRequiredCode = "402";
  String forbiddenCode = "403";
  String notFoundCode = "404";
  String methodNotAllowedCode = "405";
  String notAcceptableCode = "406";
  String proxyAuthenticationRequiredCode = "407";
  String requestTimeoutCode = "408";
  String conflictCode = "409";
  String goneCode = "410";
  String lengthRequiredCode = "411";
  String preconditionFailedCode = "412";
  String requestEntityTooLargeCode = "413";
  String requestUriTooLongCode = "414";
  String unsupportedMediaTypeCode = "415";
  String requestedRangeNotSatisfiableCode = "416";
  String expectationFailedCode = "417";
  String imATeapotCode = "418";
  String enhanceYourCalmCode = "420";
  String misdirectedRequestCode = "421";
  String unprocessableEntityCode = "422";
  String lockedCode = "423";
  String failedDependencyCode = "424";
  String reservedForWebDavCode = "425";
  String upgradeRequiredCode = "426";
  String preconditionRequiredCode = "428";
  String tooManyRequestsCode = "429";
  String requestHeaderFieldsTooLargeCode = "431";
  String connectionClosedWithoutResponseCode = "444";
  String retryWithCode = "449";
  String blockedByWindowsParentalControlsCode = "450";
  String unavailableForLegalReasonsCode = "451";
  String clientClosedRequestCode = "499";

  // HTTP Status Codes - Server Error 5xx
  String internalServerErrorCode = "500";
  String notImplementedCode = "501";
  String badGatewayCode = "502";
  String serviceUnavailableCode = "503";
  String gatewayTimeoutCode = "504";
  String httpVersionNotSupportedCode = "505";
  String variantAlsoNegotiatesCode = "506";
  String insufficientStorageCode = "507";
  String loopDetectedCode = "508";
  String bandwidthLimitExceededCode = "509";
  String notExtendedCode = "510";
  String networkAuthenticationRequiredCode = "511";
  String networkReadTimeoutErrorCode = "598";
  String networkConnectTimeoutErrorCode = "599";

  // HTTP Error Types - Informational 1xx
  String continue_ = "Continue";
  String switchingProtocols = "Switching Protocols";
  String processing = "Processing";

  // HTTP Error Types - Successful 2xx
  String ok = "OK";
  String created = "Created";
  String accepted = "Accepted";
  String nonAuthoritativeInformation = "Non-Authoritative Information";
  String noContent = "No Content";
  String resetContent = "Reset Content";
  String partialContent = "Partial Content";
  String multiStatus = "Multi-Status";
  String alreadyReported = "Already Reported";
  String imUsed = "IM Used";

  // HTTP Error Types - Redirection 3xx
  String multipleChoices = "Multiple Choices";
  String movedPermanently = "Moved Permanently";
  String found = "Found";
  String movedTemporarily = "Moved Temporarily";
  String seeOther = "See Other";
  String notModified = "Not Modified";
  String useProxy = "Use Proxy";
  String temporaryRedirect = "Temporary Redirect";

  // HTTP Error Types - Client Error 4xx
  String badRequest = "Bad Request";
  String unauthorized = "Unauthorized";
  String paymentRequired = "Payment Required";
  String forbidden = "Forbidden";
  String notFound = "Not Found";
  String methodNotAllowed = "Method Not Allowed";
  String notAcceptable = "Not Acceptable";
  String proxyAuthenticationRequired = "Proxy Authentication Required";
  String requestTimeout = "Request Timeout";
  String conflict = "Conflict";
  String gone = "Gone";
  String lengthRequired = "Length Required";
  String preconditionFailed = "Precondition Failed";
  String requestEntityTooLarge = "Request Entity Too Large";
  String requestUriTooLong = "Request URI Too Long";
  String unsupportedMediaType = "Unsupported Media Type";
  String requestedRangeNotSatisfiable = "Requested Range Not Satisfiable";
  String expectationFailed = "Expectation Failed";
  String imATeapot = "I'm a teapot";
  String enhanceYourCalm = "Enhance Your Calm";
  String misdirectedRequest = "Misdirected Request";
  String unprocessableEntity = "Unprocessable Entity";
  String locked = "Locked";
  String failedDependency = "Failed Dependency";
  String reservedForWebDav = "Reserved for WebDAV";
  String upgradeRequired = "Upgrade Required";
  String preconditionRequired = "Precondition Required";
  String tooManyRequests = "Too Many Requests";
  String requestHeaderFieldsTooLarge = "Request Header Fields Too Large";
  String connectionClosedWithoutResponse = "Connection Closed Without Response";
  String retryWith = "Retry With";
  String blockedByWindowsParentalControls = "Blocked By Windows Parental Controls";
  String unavailableForLegalReasons = "Unavailable For Legal Reasons";
  String clientClosedRequest = "Client Closed Request";

  // HTTP Error Types - Server Error 5xx
  String internalServerError = "Internal Server Error";
  String notImplemented = "Not Implemented";
  String badGateway = "Bad Gateway";
  String serviceUnavailable = "Service Unavailable";
  String gatewayTimeout = "Gateway Timeout";
  String httpVersionNotSupported = "HTTP Version Not Supported";
  String variantAlsoNegotiates = "Variant Also Negotiates";
  String insufficientStorage = "Insufficient Storage";
  String loopDetected = "Loop Detected";
  String bandwidthLimitExceeded = "Bandwidth Limit Exceeded";
  String notExtended = "Not Extended";
  String networkAuthenticationRequired = "Network Authentication Required";
  String networkReadTimeoutError = "Network Read Timeout Error";
  String networkConnectTimeoutError = "Network Connect Timeout Error";
}
