import 'package:fam_sdk/src/utils/utils.dart';
import 'package:test/test.dart';

void main() {
  group('buildUrl', () {
    test('should build URL without params', () {
      final url = buildUrl('https://api.example.com', '/users');
      expect(url, 'https://api.example.com/users');
    });

    test('should build URL with params', () {
      final url = buildUrl(
        'https://api.example.com',
        '/users',
        params: {'page': '1', 'limit': '10'},
      );
      expect(url, contains('/users?'));
      expect(url, contains('page=1'));
      expect(url, contains('limit=10'));
    });

    test('should filter empty params', () {
      final url = buildUrl(
        'https://api.example.com',
        '/users',
        params: {'page': '1', 'empty': ''},
      );
      expect(url, contains('page=1'));
      expect(url, isNot(contains('empty=')));
    });

    test('should handle null params', () {
      final url = buildUrl(
        'https://api.example.com',
        '/users',
        params: null,
      );
      expect(url, 'https://api.example.com/users');
    });

    test('should handle trailing slash', () {
      final url = buildUrl('https://api.example.com/', '/users');
      expect(url, contains('/users'));
    });
  });

  group('deepMerge', () {
    test('should merge flat maps', () {
      final target = {'a': 1, 'b': 2};
      final source = {'b': 3, 'c': 4};
      final result = deepMerge(target, source);

      expect(result['a'], 1);
      expect(result['b'], 3); // Source overrides
      expect(result['c'], 4);
    });

    test('should merge nested maps', () {
      final target = {
        'user': {'name': 'John', 'age': 30}
      };
      final source = {
        'user': {'age': 31, 'city': 'Paris'}
      };
      final result = deepMerge(target, source);

      final user = result['user'] as Map<String, Object?>;
      expect(user['name'], 'John'); // Preserved from target
      expect(user['age'], 31); // Overridden by source
      expect(user['city'], 'Paris'); // Added from source
    });

    test('should not modify original maps', () {
      final target = {'a': 1};
      final source = {'b': 2};
      deepMerge(target, source);

      expect(target.containsKey('b'), isFalse);
    });
  });

  group('formatAmount', () {
    test('should format EUR amount', () {
      expect(formatAmount(1234, 'EUR'), '12.34 EUR');
    });

    test('should format USD amount', () {
      expect(formatAmount(500, 'USD'), '5.00 USD');
    });

    test('should handle zero', () {
      expect(formatAmount(0, 'EUR'), '0.00 EUR');
    });

    test('should format JPY without decimals', () {
      expect(formatAmount(1000, 'JPY'), '1000 JPY');
    });

    test('should format KRW without decimals', () {
      expect(formatAmount(50000, 'KRW'), '50000 KRW');
    });

    test('should default to EUR', () {
      expect(formatAmount(1000), '10.00 EUR');
    });
  });

  group('parseAmount', () {
    test('should parse decimal to cents', () {
      expect(parseAmount(12.34), 1234);
    });

    test('should parse whole number', () {
      expect(parseAmount(10), 1000);
    });

    test('should handle zero', () {
      expect(parseAmount(0), 0);
    });

    test('should round correctly', () {
      expect(parseAmount(12.345), 1235);
      expect(parseAmount(12.344), 1234);
    });
  });

  group('timingSafeEquals', () {
    test('should return true for equal strings', () {
      expect(timingSafeEquals('abc', 'abc'), isTrue);
      expect(timingSafeEquals('signature123', 'signature123'), isTrue);
    });

    test('should return false for different strings', () {
      expect(timingSafeEquals('abc', 'abd'), isFalse);
      expect(timingSafeEquals('abc', 'ABC'), isFalse);
    });

    test('should return false for different lengths', () {
      expect(timingSafeEquals('abc', 'ab'), isFalse);
      expect(timingSafeEquals('abc', 'abcd'), isFalse);
    });

    test('should handle empty strings', () {
      expect(timingSafeEquals('', ''), isTrue);
      expect(timingSafeEquals('', 'a'), isFalse);
    });
  });

  group('isValidId', () {
    test('should validate alphanumeric IDs', () {
      expect(isValidId('user123'), isTrue);
      expect(isValidId('User123'), isTrue);
      expect(isValidId('USER_123'), isTrue);
      expect(isValidId('user-123'), isTrue);
    });

    test('should reject invalid IDs', () {
      expect(isValidId(null), isFalse);
      expect(isValidId(''), isFalse);
      expect(isValidId('user@123'), isFalse);
      expect(isValidId('user 123'), isFalse);
      expect(isValidId('user.123'), isFalse);
    });
  });

  group('retry', () {
    test('should succeed on first try', () async {
      var attempts = 0;
      final result = await retry(
        () async {
          attempts++;
          return 'success';
        },
        maxRetries: 3,
        baseDelay: const Duration(milliseconds: 1),
      );

      expect(result, 'success');
      expect(attempts, 1);
    });

    test('should retry on failure', () async {
      var attempts = 0;
      final result = await retry(
        () async {
          attempts++;
          if (attempts < 3) {
            throw Exception('Temporary error');
          }
          return 'success';
        },
        maxRetries: 3,
        baseDelay: const Duration(milliseconds: 1),
      );

      expect(result, 'success');
      expect(attempts, 3);
    });

    test('should throw after max retries', () async {
      var attempts = 0;

      expect(
        () => retry(
          () async {
            attempts++;
            throw Exception('Permanent error');
          },
          maxRetries: 3,
          baseDelay: const Duration(milliseconds: 1),
        ),
        throwsException,
      );
    });

    test('should respect shouldRetry predicate', () async {
      var attempts = 0;

      expect(
        () => retry(
          () async {
            attempts++;
            throw ArgumentError('Not retryable');
          },
          maxRetries: 3,
          baseDelay: const Duration(milliseconds: 1),
          shouldRetry: (error) => error is! ArgumentError,
        ),
        throwsArgumentError,
      );
    });
  });

  group('DateTimeExtension', () {
    test('toUnixTimestamp should convert correctly', () {
      final date = DateTime.utc(2024, 1, 1, 12, 0, 0);
      expect(date.toUnixTimestamp(), 1704110400);
    });

    test('fromUnixTimestamp should convert correctly', () {
      final date = DateTimeExtension.fromUnixTimestamp(1704110400);
      expect(date.year, 2024);
      expect(date.month, 1);
      expect(date.day, 1);
      expect(date.hour, 12);
    });
  });

  group('IntTimestampExtension', () {
    test('toDateTime should convert correctly', () {
      final date = 1704110400.toDateTime();
      expect(date.year, 2024);
      expect(date.month, 1);
      expect(date.day, 1);
    });
  });

  group('isNative', () {
    test('should return true in native environment', () {
      // Running in Dart VM, so should return true
      expect(isNative(), isTrue);
    });
  });

  group('isBrowser', () {
    test('should return false in native environment', () {
      // Running in Dart VM, so should return false
      expect(isBrowser(), isFalse);
    });
  });
}
