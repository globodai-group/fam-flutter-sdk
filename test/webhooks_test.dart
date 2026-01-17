import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:fam_sdk/fam_sdk.dart';
import 'package:test/test.dart';

void main() {
  group('Webhooks', () {
    group('without secret', () {
      late Webhooks webhooks;

      setUp(() {
        webhooks = Webhooks();
      });

      test('should verify any signature when no secret configured', () {
        expect(webhooks.verify('payload', 'any_signature'), isTrue);
        expect(webhooks.verify('payload', null), isTrue);
        expect(webhooks.verify('payload', ''), isTrue);
      });

      test('should parse Mangopay event', () {
        final payload = jsonEncode({
          'EventType': 'PAYIN_NORMAL_SUCCEEDED',
          'ResourceId': 'pay_123',
          'Id': 'evt_123',
          'Date': 1704067200,
        });

        final event = webhooks.parse(payload);
        expect(event, isA<MangopayWebhookEvent>());
        expect(
          (event as MangopayWebhookEvent).type,
          MangopayEventType.PAYIN_NORMAL_SUCCEEDED,
        );
        expect(event.resourceId, 'pay_123');
        expect(event.date, 1704067200);
      });

      test('should parse FAM event', () {
        final payload = jsonEncode({
          'EventType': 'FAM_SUBSCRIPTION_CREATED',
          'ResourceId': 'sub_123',
          'Id': 'evt_456',
          'Date': 1704067200,
        });

        final event = webhooks.parse(payload);
        expect(event, isA<FamWebhookEvent>());
        expect(
          (event as FamWebhookEvent).type,
          FamEventType.FAM_SUBSCRIPTION_CREATED,
        );
      });

      test('should throw on missing EventType', () {
        final payload = jsonEncode({
          'ResourceId': 'test_123',
        });

        expect(
          () => webhooks.parse(payload),
          throwsA(isA<WebhookSignatureException>()),
        );
      });

      test('should throw on invalid JSON', () {
        expect(
          () => webhooks.parse('invalid json'),
          throwsA(isA<WebhookSignatureException>()),
        );
      });

      test('should throw on empty payload', () {
        expect(
          () => webhooks.parse(null),
          throwsA(isA<WebhookSignatureException>()),
        );
      });

      test('should parse from Map', () {
        final payload = {
          'EventType': 'PAYIN_NORMAL_FAILED',
          'ResourceId': 'pay_456',
          'Id': 'evt_789',
          'Date': 1704067200,
        };

        final event = webhooks.parse(payload);
        expect(event, isA<MangopayWebhookEvent>());
        expect((event as MangopayWebhookEvent).resourceId, 'pay_456');
      });
    });

    group('with secret', () {
      late Webhooks webhooks;
      const secret = 'whsec_test_secret_key_1234567890';

      setUp(() {
        webhooks = Webhooks(
          config: WebhookHandlerConfig(
            secret: secret,
            tolerance: const Duration(minutes: 5),
          ),
        );
      });

      String computeSignature(String payload) {
        final key = utf8.encode(secret);
        final bytes = utf8.encode(payload);
        final hmacSha256 = Hmac(sha256, key);
        final digest = hmacSha256.convert(bytes);
        return digest.toString();
      }

      test('should verify valid signature', () {
        const payload = '{"EventType":"TEST"}';
        final signature = computeSignature(payload);

        expect(webhooks.verify(payload, signature), isTrue);
      });

      test('should reject invalid signature', () {
        const payload = '{"EventType":"TEST"}';
        const invalidSignature = 'invalid_signature';

        expect(webhooks.verify(payload, invalidSignature), isFalse);
      });

      test('should reject null signature when secret is configured', () {
        const payload = '{"EventType":"TEST"}';

        expect(webhooks.verify(payload, null), isFalse);
        expect(webhooks.verify(payload, ''), isFalse);
      });

      test('should reject tampered payload', () {
        const originalPayload = '{"EventType":"TEST","amount":100}';
        final signature = computeSignature(originalPayload);

        const tamperedPayload = '{"EventType":"TEST","amount":999}';

        expect(webhooks.verify(tamperedPayload, signature), isFalse);
      });

      test('constructEvent should verify and parse', () {
        final payload = jsonEncode({
          'EventType': 'PAYIN_NORMAL_SUCCEEDED',
          'ResourceId': 'pay_123',
          'Id': 'evt_123',
          'Date': 1704067200,
        });
        final signature = computeSignature(payload);

        final event = webhooks.constructEvent(payload, signature);
        expect(event, isA<MangopayWebhookEvent>());
      });

      test('constructEvent should throw on invalid signature', () {
        final payload = jsonEncode({
          'EventType': 'PAYIN_NORMAL_SUCCEEDED',
          'ResourceId': 'pay_123',
          'Id': 'evt_123',
          'Date': 1704067200,
        });

        expect(
          () => webhooks.constructEvent(payload, 'invalid'),
          throwsA(isA<WebhookSignatureException>()),
        );
      });

      test('verifyWithTimestamp should accept recent timestamp', () {
        const payload = '{"EventType":"TEST"}';
        final signature = computeSignature(payload);
        final recentTimestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;

        expect(
          webhooks.verifyWithTimestamp(payload, signature, recentTimestamp),
          isTrue,
        );
      });

      test('verifyWithTimestamp should reject old timestamp', () {
        const payload = '{"EventType":"TEST"}';
        final signature = computeSignature(payload);
        // Timestamp from 10 minutes ago (beyond 5 min tolerance)
        final oldTimestamp =
            DateTime.now().millisecondsSinceEpoch ~/ 1000 - 600;

        expect(
          webhooks.verifyWithTimestamp(payload, signature, oldTimestamp),
          isFalse,
        );
      });
    });
  });

  group('MangopayEventType', () {
    test('should have payin events', () {
      expect(
        MangopayEventType.values,
        contains(MangopayEventType.PAYIN_NORMAL_CREATED),
      );
      expect(
        MangopayEventType.values,
        contains(MangopayEventType.PAYIN_NORMAL_SUCCEEDED),
      );
      expect(
        MangopayEventType.values,
        contains(MangopayEventType.PAYIN_NORMAL_FAILED),
      );
    });

    test('should have payout events', () {
      expect(
        MangopayEventType.values,
        contains(MangopayEventType.PAYOUT_NORMAL_CREATED),
      );
      expect(
        MangopayEventType.values,
        contains(MangopayEventType.PAYOUT_NORMAL_SUCCEEDED),
      );
      expect(
        MangopayEventType.values,
        contains(MangopayEventType.PAYOUT_NORMAL_FAILED),
      );
    });

    test('should have transfer events', () {
      expect(
        MangopayEventType.values,
        contains(MangopayEventType.TRANSFER_NORMAL_CREATED),
      );
      expect(
        MangopayEventType.values,
        contains(MangopayEventType.TRANSFER_NORMAL_SUCCEEDED),
      );
      expect(
        MangopayEventType.values,
        contains(MangopayEventType.TRANSFER_NORMAL_FAILED),
      );
    });

    test('should have KYC events', () {
      expect(
        MangopayEventType.values,
        contains(MangopayEventType.KYC_CREATED),
      );
      expect(
        MangopayEventType.values,
        contains(MangopayEventType.KYC_SUCCEEDED),
      );
      expect(
        MangopayEventType.values,
        contains(MangopayEventType.KYC_FAILED),
      );
    });
  });

  group('FamEventType', () {
    test('should have subscription events', () {
      expect(
        FamEventType.values,
        contains(FamEventType.FAM_SUBSCRIPTION_CREATED),
      );
      expect(
        FamEventType.values,
        contains(FamEventType.FAM_SUBSCRIPTION_UPDATED),
      );
      expect(
        FamEventType.values,
        contains(FamEventType.FAM_SUBSCRIPTION_CANCELLED),
      );
    });

    test('should have subscription payment events', () {
      expect(
        FamEventType.values,
        contains(FamEventType.FAM_SUBSCRIPTION_PAYMENT_SUCCEEDED),
      );
      expect(
        FamEventType.values,
        contains(FamEventType.FAM_SUBSCRIPTION_PAYMENT_FAILED),
      );
    });

    test('should have correct number of events', () {
      expect(FamEventType.values.length, 6);
    });
  });

  group('WebhookHandlerConfig', () {
    test('should create with secret', () {
      const config = WebhookHandlerConfig(
        secret: 'test_secret',
      );
      expect(config.secret, 'test_secret');
      // Has default tolerance
      expect(config.tolerance, const Duration(minutes: 5));
    });

    test('should create with custom tolerance', () {
      const config = WebhookHandlerConfig(
        secret: 'test_secret',
        tolerance: Duration(minutes: 10),
      );
      expect(config.tolerance, const Duration(minutes: 10));
    });
  });
}
