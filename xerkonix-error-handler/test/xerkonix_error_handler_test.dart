import 'package:flutter_test/flutter_test.dart';
import 'package:xerkonix_error_handler/xerkonix_error_handler.dart';

void main() {
  group('XkError Tests', () {
    test('XkError should create with all properties', () {
      final error = XkError(
        code: 'ERR001',
        type: 'ValidationError',
        message: 'Invalid input',
        title: 'Error Title',
        detail: 'Error detail message',
      );
      
      expect(error.code, 'ERR001');
      expect(error.type, 'ValidationError');
      expect(error.message, 'Invalid input');
      expect(error.title, 'Error Title');
      expect(error.detail, 'Error detail message');
    });

    test('XkError should create with null properties', () {
      final error = XkError();
      
      expect(error.code, isNull);
      expect(error.type, isNull);
      expect(error.message, isNull);
      expect(error.title, isNull);
      expect(error.detail, isNull);
    });

    test('XkError toString should format correctly', () {
      final error = XkError(
        code: 'ERR001',
        type: 'ValidationError',
        message: 'Invalid input',
        title: 'Error Title',
        detail: 'Error detail message',
      );
      
      final result = error.toString();
      expect(result, contains('ERR001'));
      expect(result, contains('ValidationError'));
      expect(result, contains('Invalid input'));
      expect(result, contains('Error Title'));
      expect(result, contains('Error detail message'));
    });
  });

  group('XkErrors Tests', () {
    test('XkErrors.badRequest should create BadRequest error', () {
      final error = XkErrors.badRequest(
        type: 'BadRequest',
        message: 'Bad request message',
        title: 'Bad Request',
        detail: 'Detail',
      );
      
      expect(error, isA<BadRequest>());
      expect(error.type, 'BadRequest');
      expect(error.message, 'Bad request message');
    });

    test('XkErrors.unauthorized should create Unauthorized error', () {
      final error = XkErrors.unauthorized(
        type: 'Unauthorized',
        message: 'Unauthorized message',
      );
      
      expect(error, isA<Unauthorized>());
      expect(error.type, 'Unauthorized');
    });

    test('XkErrors.notFound should create NotFound error', () {
      final error = XkErrors.notFound(
        type: 'NotFound',
        message: 'Not found message',
      );
      
      expect(error, isA<NotFound>());
      expect(error.type, 'NotFound');
    });

    test('XkErrors should have stackTrace', () {
      final error = XkErrors.badRequest();
      expect(error.stackTrace, isNotNull);
    });
  });

  group('XkException Tests', () {
    test('XkException should create with XkError', () {
      final xkError = XkErrors.badRequest(
        message: 'Test error',
      );
      final exception = XkException(xkError);
      
      expect(exception.xkError, xkError);
    });

    test('XkException.toString should format correctly', () {
      final xkError = XkErrors.badRequest(
        message: 'Test error message',
      );
      final exception = XkException(xkError);
      
      final result = exception.toString();
      expect(result, contains('Exception'));
      expect(result, contains('Test error message'));
    });

    test('XkException factory methods should create correct exceptions', () {
      expect(XkException.badRequest(), isA<BadRequestException>());
      expect(XkException.unauthorized(), isA<UnauthorizedException>());
      expect(XkException.forbidden(), isA<ForbiddenException>());
      expect(XkException.notFound(), isA<NotFoundException>());
      expect(XkException.conflict(), isA<ConflictException>());
      expect(XkException.requestTimeout(), isA<RequestTimeoutException>());
      expect(XkException.internalServerError(), isA<InternalServerErrorException>());
      expect(XkException.serviceUnavailable(), isA<ServiceUnavailableException>());
      expect(XkException.unknownError(), isA<UnknownErrorException>());
      expect(XkException.unstableNetwork(), isA<UnstableNetworkException>());
    });
  });

  group('XkErrorMessageHandler Tests', () {
    test('checkErrorMessageExist should return false initially', () {
      XkErrorMessageHandler.flushErrorMessage();
      expect(XkErrorMessageHandler.checkErrorMessageExist(), false);
    });

    test('setErrorMessage should set error message', () {
      final error = XkErrors.badRequest(
        title: 'Error Title',
        detail: 'Error Detail',
      );
      XkErrorMessageHandler.setErrorMessage(xkError: error);
      
      expect(XkErrorMessageHandler.checkErrorMessageExist(), true);
      final message = XkErrorMessageHandler.getErrorMessage();
      expect(message.title, 'Error Title');
      expect(message.detail, 'Error Detail');
    });

    test('getErrorMessage should return default when no error exists', () {
      XkErrorMessageHandler.flushErrorMessage();
      final message = XkErrorMessageHandler.getErrorMessage();
      
      expect(message.title, '');
      expect(message.detail, '');
    });

    test('flushErrorMessage should clear error message', () {
      final error = XkErrors.badRequest(
        title: 'Error Title',
        detail: 'Error Detail',
      );
      XkErrorMessageHandler.setErrorMessage(xkError: error);
      expect(XkErrorMessageHandler.checkErrorMessageExist(), true);
      
      XkErrorMessageHandler.flushErrorMessage();
      expect(XkErrorMessageHandler.checkErrorMessageExist(), false);
    });
  });
}

