/// Webhook handler for the FAM SDK.
///
/// Provides secure webhook signature verification and event parsing.
library;

import 'dart:convert';

import 'package:crypto/crypto.dart';

import 'package:fam_sdk/src/errors/errors.dart';
import 'package:fam_sdk/src/types/webhooks.dart';
import 'package:fam_sdk/src/utils/utils.dart';

export 'package:fam_sdk/src/types/webhooks.dart';

/// Webhook handler for verifying and parsing webhook events.
///
/// ```dart
/// final webhooks = Webhooks(
///   config: WebhookHandlerConfig(secret: 'whsec_...'),
/// );
///
/// // In your webhook handler
/// try {
///   final event = webhooks.constructEvent(
///     rawBody,
///     request.headers['x-fam-signature'],
///   );
///
///   if (event is MangopayWebhookEvent) {
///     switch (event.type) {
///       case MangopayEventType.PAYIN_NORMAL_SUCCEEDED:
///         // Handle successful payment
///         break;
///       // ...
///     }
///   } else if (event is FamWebhookEvent) {
///     switch (event.type) {
///       case FamEventType.FAM_SUBSCRIPTION_PAYMENT_SUCCEEDED:
///         // Handle subscription payment
///         break;
///       // ...
///     }
///   }
/// } on WebhookSignatureException catch (e) {
///   // Invalid signature - reject the webhook
///   return Response(400);
/// }
/// ```
class Webhooks {
  /// Creates a webhook handler.
  ///
  /// If [config] is provided with a secret, signature verification
  /// will be enabled.
  Webhooks({WebhookHandlerConfig? config}) : _config = config;

  final WebhookHandlerConfig? _config;

  /// Verifies a webhook signature.
  ///
  /// Returns true if the signature is valid or if no secret is configured.
  bool verify(String payload, String? signature) {
    if (_config?.secret == null) {
      return true; // No secret configured, skip verification
    }

    if (signature == null || signature.isEmpty) {
      return false;
    }

    final expectedSignature = _computeSignature(payload);
    return timingSafeEquals(signature, expectedSignature);
  }

  /// Verifies a webhook signature with timestamp validation.
  ///
  /// Additionally checks that the timestamp is within the tolerance window
  /// to prevent replay attacks.
  bool verifyWithTimestamp(
    String payload,
    String? signature,
    int timestamp,
  ) {
    if (!verify(payload, signature)) {
      return false;
    }

    if (_config?.tolerance != null) {
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final diff = (now - timestamp).abs();
      if (diff > _config!.tolerance.inSeconds) {
        return false;
      }
    }

    return true;
  }

  /// Parses a webhook payload into a typed event.
  ///
  /// Does not verify the signature. Use [constructEvent] for
  /// signature verification and parsing.
  WebhookEvent parse(Object? payload) {
    if (payload == null) {
      throw const WebhookSignatureException('Empty webhook payload');
    }

    Map<String, Object?> json;

    if (payload is String) {
      try {
        json = jsonDecode(payload) as Map<String, Object?>;
      } on FormatException {
        throw const WebhookSignatureException(
            'Invalid JSON in webhook payload');
      }
    } else if (payload is Map<String, Object?>) {
      json = payload;
    } else {
      throw const WebhookSignatureException('Invalid webhook payload type');
    }

    if (!json.containsKey('EventType')) {
      throw const WebhookSignatureException('Missing EventType in webhook');
    }

    return parseWebhookEvent(json);
  }

  /// Constructs a webhook event with signature verification.
  ///
  /// Throws [WebhookSignatureException] if verification fails.
  WebhookEvent constructEvent(String payload, String? signature) {
    if (!verify(payload, signature)) {
      throw const WebhookSignatureException('Invalid webhook signature');
    }

    return parse(payload);
  }

  /// Constructs a webhook event with signature and timestamp verification.
  ///
  /// Throws [WebhookSignatureException] if verification fails.
  WebhookEvent constructEventWithTimestamp(
    String payload,
    String? signature,
    int timestamp,
  ) {
    if (!verifyWithTimestamp(payload, signature, timestamp)) {
      throw const WebhookSignatureException(
        'Invalid webhook signature or timestamp',
      );
    }

    return parse(payload);
  }

  /// Checks if an event matches a specific event type.
  bool isEventType<T extends WebhookEvent>(
    WebhookEvent event,
    String eventType,
  ) =>
      event.eventType == eventType;

  String _computeSignature(String payload) {
    final secret = _config!.secret!;
    final key = utf8.encode(secret);
    final bytes = utf8.encode(payload);
    final hmacSha256 = Hmac(sha256, key);
    final digest = hmacSha256.convert(bytes);
    return digest.toString();
  }
}
