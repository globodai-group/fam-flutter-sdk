/// Webhook types for the FAM SDK.
///
/// Provides types for webhook event handling.
library;

/// Mangopay webhook event types.
enum MangopayEventType {
  // PayIn events
  // ignore: constant_identifier_names
  PAYIN_NORMAL_CREATED,
  // ignore: constant_identifier_names
  PAYIN_NORMAL_SUCCEEDED,
  // ignore: constant_identifier_names
  PAYIN_NORMAL_FAILED,
  // ignore: constant_identifier_names
  PAYIN_REFUND_CREATED,
  // ignore: constant_identifier_names
  PAYIN_REFUND_SUCCEEDED,
  // ignore: constant_identifier_names
  PAYIN_REFUND_FAILED,

  // PayOut events
  // ignore: constant_identifier_names
  PAYOUT_NORMAL_CREATED,
  // ignore: constant_identifier_names
  PAYOUT_NORMAL_SUCCEEDED,
  // ignore: constant_identifier_names
  PAYOUT_NORMAL_FAILED,
  // ignore: constant_identifier_names
  PAYOUT_REFUND_CREATED,
  // ignore: constant_identifier_names
  PAYOUT_REFUND_SUCCEEDED,
  // ignore: constant_identifier_names
  PAYOUT_REFUND_FAILED,

  // Transfer events
  // ignore: constant_identifier_names
  TRANSFER_NORMAL_CREATED,
  // ignore: constant_identifier_names
  TRANSFER_NORMAL_SUCCEEDED,
  // ignore: constant_identifier_names
  TRANSFER_NORMAL_FAILED,
  // ignore: constant_identifier_names
  TRANSFER_REFUND_CREATED,
  // ignore: constant_identifier_names
  TRANSFER_REFUND_SUCCEEDED,
  // ignore: constant_identifier_names
  TRANSFER_REFUND_FAILED,

  // KYC events
  // ignore: constant_identifier_names
  KYC_CREATED,
  // ignore: constant_identifier_names
  KYC_VALIDATION_ASKED,
  // ignore: constant_identifier_names
  KYC_SUCCEEDED,
  // ignore: constant_identifier_names
  KYC_FAILED,
  // ignore: constant_identifier_names
  KYC_OUTDATED,

  // UBO events
  // ignore: constant_identifier_names
  UBO_DECLARATION_CREATED,
  // ignore: constant_identifier_names
  UBO_DECLARATION_VALIDATION_ASKED,
  // ignore: constant_identifier_names
  UBO_DECLARATION_VALIDATED,
  // ignore: constant_identifier_names
  UBO_DECLARATION_REFUSED,
  // ignore: constant_identifier_names
  UBO_DECLARATION_INCOMPLETE,

  // Preauthorization events
  // ignore: constant_identifier_names
  PREAUTHORIZATION_CREATED,
  // ignore: constant_identifier_names
  PREAUTHORIZATION_SUCCEEDED,
  // ignore: constant_identifier_names
  PREAUTHORIZATION_FAILED,

  // Card validation events
  // ignore: constant_identifier_names
  CARD_VALIDATION_CREATED,
  // ignore: constant_identifier_names
  CARD_VALIDATION_SUCCEEDED,
  // ignore: constant_identifier_names
  CARD_VALIDATION_FAILED,

  // User events
  // ignore: constant_identifier_names
  USER_KYC_REGULAR,
  // ignore: constant_identifier_names
  USER_KYC_LIGHT,
  // ignore: constant_identifier_names
  USER_INFLOWS_BLOCKED,
  // ignore: constant_identifier_names
  USER_INFLOWS_UNBLOCKED,
  // ignore: constant_identifier_names
  USER_OUTFLOWS_BLOCKED,
  // ignore: constant_identifier_names
  USER_OUTFLOWS_UNBLOCKED,

  // Recurring payment events
  // ignore: constant_identifier_names
  RECURRING_REGISTRATION_CREATED,
  // ignore: constant_identifier_names
  RECURRING_REGISTRATION_AUTH_NEEDED,
  // ignore: constant_identifier_names
  RECURRING_REGISTRATION_IN_PROGRESS,
  // ignore: constant_identifier_names
  RECURRING_REGISTRATION_ENDED,
}

/// FAM-specific webhook event types.
enum FamEventType {
  // Subscription events
  // ignore: constant_identifier_names
  FAM_SUBSCRIPTION_CREATED,
  // ignore: constant_identifier_names
  FAM_SUBSCRIPTION_UPDATED,
  // ignore: constant_identifier_names
  FAM_SUBSCRIPTION_CANCELLED,
  // ignore: constant_identifier_names
  FAM_SUBSCRIPTION_PAYMENT_SCHEDULED,
  // ignore: constant_identifier_names
  FAM_SUBSCRIPTION_PAYMENT_SUCCEEDED,
  // ignore: constant_identifier_names
  FAM_SUBSCRIPTION_PAYMENT_FAILED,
}

/// Base webhook event.
abstract class WebhookEvent {
  /// Creates a webhook event.
  const WebhookEvent({
    required this.id,
    required this.date,
    required this.resourceId,
    this.customData,
  });

  /// Event ID.
  final String id;

  /// Event timestamp (Unix).
  final int date;

  /// ID of the related resource.
  final String resourceId;

  /// Custom data attached to the event.
  final String? customData;

  /// Event type string.
  String get eventType;

  /// Event date as DateTime.
  DateTime get dateTime =>
      DateTime.fromMillisecondsSinceEpoch(date * 1000, isUtc: true);
}

/// Mangopay webhook event.
class MangopayWebhookEvent extends WebhookEvent {
  /// Creates a Mangopay webhook event.
  const MangopayWebhookEvent({
    required super.id,
    required super.date,
    required super.resourceId,
    required this.type,
    super.customData,
  });

  /// Creates from JSON.
  factory MangopayWebhookEvent.fromJson(Map<String, Object?> json) =>
      MangopayWebhookEvent(
        id: json['Id'] as String,
        date: json['Date'] as int,
        resourceId: json['ResourceId'] as String,
        type: MangopayEventType.values.byName(json['EventType'] as String),
        customData: json['CustomData'] as String?,
      );

  /// Event type.
  final MangopayEventType type;

  @override
  String get eventType => type.name;

  /// Converts to JSON.
  Map<String, Object?> toJson() => {
        'Id': id,
        'Date': date,
        'EventType': type.name,
        'ResourceId': resourceId,
        if (customData != null) 'CustomData': customData,
      };
}

/// FAM webhook event.
class FamWebhookEvent extends WebhookEvent {
  /// Creates a FAM webhook event.
  const FamWebhookEvent({
    required super.id,
    required super.date,
    required super.resourceId,
    required this.type,
    super.customData,
  });

  /// Creates from JSON.
  factory FamWebhookEvent.fromJson(Map<String, Object?> json) =>
      FamWebhookEvent(
        id: json['Id'] as String,
        date: json['Date'] as int,
        resourceId: json['ResourceId'] as String,
        type: FamEventType.values.byName(json['EventType'] as String),
        customData: json['CustomData'] as String?,
      );

  /// Event type.
  final FamEventType type;

  @override
  String get eventType => type.name;

  /// Converts to JSON.
  Map<String, Object?> toJson() => {
        'Id': id,
        'Date': date,
        'EventType': type.name,
        'ResourceId': resourceId,
        if (customData != null) 'CustomData': customData,
      };
}

/// Checks if an event type string is a Mangopay event.
bool isMangopayEvent(String eventType) {
  try {
    MangopayEventType.values.byName(eventType);
    return true;
  } on ArgumentError {
    return false;
  }
}

/// Checks if an event type string is a FAM event.
bool isFamEvent(String eventType) {
  try {
    FamEventType.values.byName(eventType);
    return true;
  } on ArgumentError {
    return false;
  }
}

/// Parses a webhook event from JSON.
///
/// Returns either [MangopayWebhookEvent] or [FamWebhookEvent]
/// based on the event type.
WebhookEvent parseWebhookEvent(Map<String, Object?> json) {
  final eventType = json['EventType'] as String;

  if (isFamEvent(eventType)) {
    return FamWebhookEvent.fromJson(json);
  }

  return MangopayWebhookEvent.fromJson(json);
}

/// Webhook handler configuration.
class WebhookHandlerConfig {
  /// Creates webhook handler config.
  const WebhookHandlerConfig({
    this.secret,
    this.tolerance = const Duration(minutes: 5),
  });

  /// Webhook signing secret for signature verification.
  final String? secret;

  /// Timestamp tolerance for replay attack prevention.
  final Duration tolerance;
}
