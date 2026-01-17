import 'package:fam_sdk/fam_sdk.dart';
import 'package:test/test.dart';

void main() {
  group('FamException', () {
    test('should create with message', () {
      const exception = ApiException('Test error', statusCode: 500);
      expect(exception.message, 'Test error');
      expect(exception.statusCode, 500);
    });

    test('toString should include message', () {
      const exception = ApiException('Test error', statusCode: 500);
      expect(exception.toString(), contains('Test error'));
      expect(exception.toString(), contains('500'));
    });
  });

  group('ApiException', () {
    test('should include status code', () {
      const exception = ApiException(
        'Bad request',
        statusCode: 400,
        code: 'INVALID_REQUEST',
      );
      expect(exception.statusCode, 400);
      expect(exception.code, 'INVALID_REQUEST');
    });

    test('toString should include code when present', () {
      const exception = ApiException(
        'Error',
        statusCode: 400,
        code: 'ERR_001',
      );
      expect(exception.toString(), contains('ERR_001'));
    });
  });

  group('AuthenticationException', () {
    test('should have status code 401', () {
      const exception = AuthenticationException('Unauthorized');
      expect(exception.statusCode, 401);
    });

    test('toString should indicate authentication error', () {
      const exception = AuthenticationException('Invalid token');
      expect(exception.toString(), contains('AuthenticationException'));
    });
  });

  group('AuthorizationException', () {
    test('should have status code 403', () {
      const exception = AuthorizationException('Forbidden');
      expect(exception.statusCode, 403);
    });

    test('toString should indicate authorization error', () {
      const exception = AuthorizationException('Access denied');
      expect(exception.toString(), contains('AuthorizationException'));
    });
  });

  group('NotFoundException', () {
    test('should have status code 404', () {
      const exception = NotFoundException('User not found');
      expect(exception.statusCode, 404);
    });

    test('toString should indicate not found error', () {
      const exception = NotFoundException('Resource missing');
      expect(exception.toString(), contains('NotFoundException'));
    });
  });

  group('ValidationException', () {
    test('should have status code 400 or 422', () {
      const exception400 = ValidationException('Invalid', statusCode: 400);
      const exception422 = ValidationException('Invalid', statusCode: 422);
      expect(exception400.statusCode, 400);
      expect(exception422.statusCode, 422);
    });

    test('should include field errors', () {
      const exception = ValidationException(
        'Validation failed',
        statusCode: 400,
        errors: {
          'email': ['Invalid email format'],
          'password': ['Too short', 'Must contain number'],
        },
      );
      expect(exception.errors['email'], contains('Invalid email format'));
      expect(exception.errors['password'], hasLength(2));
    });

    test('toString should include field errors', () {
      const exception = ValidationException(
        'Validation failed',
        statusCode: 400,
        errors: {
          'email': ['Invalid'],
        },
      );
      expect(exception.toString(), contains('email'));
      expect(exception.toString(), contains('Invalid'));
    });
  });

  group('RateLimitException', () {
    test('should have status code 429', () {
      const exception = RateLimitException('Too many requests');
      expect(exception.statusCode, 429);
    });

    test('should include retry after', () {
      const exception = RateLimitException(
        'Too many requests',
        retryAfter: 60,
      );
      expect(exception.retryAfter, 60);
    });

    test('toString should include retry after when present', () {
      const exception = RateLimitException(
        'Too many requests',
        retryAfter: 30,
      );
      expect(exception.toString(), contains('30'));
    });
  });

  group('NetworkException', () {
    test('should create with message', () {
      const exception = NetworkException('Connection failed');
      expect(exception.message, 'Connection failed');
    });

    test('should include original error', () {
      final originalError = Exception('Socket error');
      final exception = NetworkException(
        'Connection failed',
        originalError: originalError,
      );
      expect(exception.originalError, originalError);
    });
  });

  group('TimeoutException', () {
    test('should create with duration', () {
      const exception = TimeoutException(
        'Request timed out',
        duration: Duration(seconds: 30),
      );
      expect(exception.duration, const Duration(seconds: 30));
    });

    test('toString should include duration when present', () {
      const exception = TimeoutException(
        'Timeout',
        duration: Duration(milliseconds: 5000),
      );
      expect(exception.toString(), contains('5000'));
    });
  });

  group('WebhookSignatureException', () {
    test('should create with message', () {
      const exception = WebhookSignatureException('Invalid signature');
      expect(exception.message, 'Invalid signature');
    });

    test('toString should indicate webhook error', () {
      const exception = WebhookSignatureException('Bad signature');
      expect(exception.toString(), contains('WebhookSignatureException'));
    });
  });

  group('createApiException factory', () {
    test('should create ValidationException for 400', () {
      final exception = createApiException(
        statusCode: 400,
        message: 'Bad request',
      );
      expect(exception, isA<ValidationException>());
    });

    test('should create ValidationException for 422', () {
      final exception = createApiException(
        statusCode: 422,
        message: 'Unprocessable entity',
      );
      expect(exception, isA<ValidationException>());
    });

    test('should create AuthenticationException for 401', () {
      final exception = createApiException(
        statusCode: 401,
        message: 'Unauthorized',
      );
      expect(exception, isA<AuthenticationException>());
    });

    test('should create AuthorizationException for 403', () {
      final exception = createApiException(
        statusCode: 403,
        message: 'Forbidden',
      );
      expect(exception, isA<AuthorizationException>());
    });

    test('should create NotFoundException for 404', () {
      final exception = createApiException(
        statusCode: 404,
        message: 'Not found',
      );
      expect(exception, isA<NotFoundException>());
    });

    test('should create RateLimitException for 429', () {
      final exception = createApiException(
        statusCode: 429,
        message: 'Rate limited',
        retryAfter: 120,
      );
      expect(exception, isA<RateLimitException>());
      expect((exception as RateLimitException).retryAfter, 120);
    });

    test('should create ApiException for other status codes', () {
      final exception = createApiException(
        statusCode: 500,
        message: 'Internal server error',
      );
      expect(exception, isA<ApiException>());
      expect(exception.statusCode, 500);
    });
  });
}
