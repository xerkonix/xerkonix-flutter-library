import 'package:flutter_test/flutter_test.dart';
import 'package:xerkonix_logger/xerkonix_logger.dart';
import 'package:http/http.dart' as http;

void main() {
  group('Logger Tests', () {
    test('Logger should create DefaultLogger', () {
      final logger = Logger('Test message');
      expect(logger, isA<DefaultLogger>());
    });

    test('Logger.debug should create DebuggingLogger', () {
      final logger = Logger.debug('Debug message');
      expect(logger, isA<DebuggingLogger>());
    });

    test('Logger.errorMessage should create ErrorMessageLogger', () {
      final logger = Logger.errorMessage('Error message');
      expect(logger, isA<ErrorMessageLogger>());
    });

    test('Logger.exception should create ExceptionLogger', () {
      final exception = Exception('Test exception');
      final logger = Logger.exception(exception);
      expect(logger, isA<ExceptionLogger>());
    });

    test('Logger.error should create ErrorLogger', () {
      final error = Error();
      final logger = Logger.error(error);
      expect(logger, isA<ErrorLogger>());
    });

    test('Logger.log should create LogLogger', () {
      final logger = Logger.log('Log message');
      expect(logger, isA<LogLogger>());
    });

    test('Logger.info should create InformationLogger', () {
      final logger = Logger.info('Info message');
      expect(logger, isA<InformationLogger>());
    });

    test('Logger.warning should create WarningLogger', () {
      final logger = Logger.warning('Warning message');
      expect(logger, isA<WarningLogger>());
    });

    test('Logger.build should create BuildLogger', () {
      final logger = Logger.build('Build message');
      expect(logger, isA<BuildLogger>());
    });

    test('Logger.httpRequest should create HttpRequestLogger', () {
      final request = http.Request('GET', Uri.parse('https://example.com'));
      final logger = Logger.httpRequest(httpRequest: request);
      expect(logger, isA<HttpRequestLogger>());
    });

    test('Logger.multipartRequest should create MultipartRequestLogger', () {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('https://example.com'),
      );
      final logger = Logger.multipartRequest(multipartRequest: request);
      expect(logger, isA<MultipartRequestLogger>());
    });

    test('Logger.httpResponse should create HttpResponseLogger', () {
      final response = http.Response('Body', 200);
      final logger = Logger.httpResponse(httpResponse: response);
      expect(logger, isA<HttpResponseLogger>());
    });

    test('Logger.htmlRequest should create HtmlRequestLogger', () {
      final logger = Logger.htmlRequest(
        method: 'GET',
        headers: {'Content-Type': 'text/html'},
        uri: Uri.parse('https://example.com'),
      );
      expect(logger, isA<HtmlRequestLogger>());
    });

    test('Logger.htmlResponse should create HtmlResponseLogger', () {
      final logger = Logger.htmlResponse(
        statusCode: 200,
        body: '<html></html>',
      );
      expect(logger, isA<HtmlResponseLogger>());
    });
  });

  group('FunLogger Tests', () {
    test('FunLogger.heart should create HeartLogger', () {
      final logger = FunLogger.heart('Love message');
      expect(logger, isA<HeartLogger>());
    });

    test('FunLogger.robot should create RobotLogger', () {
      final logger = FunLogger.robot('Robot message');
      expect(logger, isA<RobotLogger>());
    });

    test('FunLogger.poop should create PoopLogger', () {
      final logger = FunLogger.poop('Poop message');
      expect(logger, isA<PoopLogger>());
    });
  });
}
