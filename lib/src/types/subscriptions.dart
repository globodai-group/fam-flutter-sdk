/// Subscription types for the FAM SDK.
///
/// Provides types for recurring subscription management (FAM custom feature).
library;

import 'common.dart';

/// Subscription status.
enum SubscriptionStatus {
  /// Subscription is active and processing payments.
  ACTIVE,

  /// Subscription is paused (no payments processed).
  PAUSED,

  /// Subscription has been cancelled.
  CANCELLED,

  /// Subscription has ended (reached end date).
  ENDED,

  /// Subscription failed (payment issues).
  FAILED,
}

/// Subscription payment frequency.
enum SubscriptionFrequency {
  /// Daily payments.
  DAILY,

  /// Weekly payments.
  WEEKLY,

  /// Monthly payments.
  MONTHLY,

  /// Yearly payments.
  YEARLY,
}

/// Subscription payment status.
enum SubscriptionPaymentStatus {
  /// Payment is pending/scheduled.
  PENDING,

  /// Payment succeeded.
  SUCCEEDED,

  /// Payment failed.
  FAILED,
}

/// A recurring subscription.
///
/// FAM-specific feature for managing recurring payments.
///
/// ```dart
/// final subscription = await fam.subscriptions.register(
///   RegisterSubscriptionRequest(
///     userId: 'user_123',
///     mangopayUserId: 'mp_user_456',
///     walletId: 'wallet_789',
///     cardId: 'card_abc',
///     amount: 999, // 9.99 EUR
///     currency: Currency.EUR,
///     frequency: SubscriptionFrequency.MONTHLY,
///   ),
/// );
/// ```
class RecurringSubscription {
  /// Creates a subscription.
  const RecurringSubscription({
    required this.id,
    required this.userId,
    required this.mangopayUserId,
    required this.walletId,
    required this.status,
    required this.amount,
    required this.currency,
    required this.frequency,
    required this.startDate,
    required this.createdAt,
    required this.updatedAt,
    this.cardId,
    this.recurringPayinRegistrationId,
    this.nextPaymentDate,
    this.lastPaymentDate,
    this.endDate,
    this.processingEnabled,
    this.webhookNotificationEnabled,
    this.metadata,
  });

  /// Creates a RecurringSubscription from JSON.
  factory RecurringSubscription.fromJson(Map<String, Object?> json) =>
      RecurringSubscription(
        id: json['id'] as String,
        userId: json['userId'] as String,
        mangopayUserId: json['mangopayUserId'] as String,
        walletId: json['walletId'] as String,
        status: SubscriptionStatus.values.byName(json['status'] as String),
        amount: json['amount'] as int,
        currency: Currency.values.byName(json['currency'] as String),
        frequency:
            SubscriptionFrequency.values.byName(json['frequency'] as String),
        startDate: json['startDate'] as String,
        createdAt: json['createdAt'] as String,
        updatedAt: json['updatedAt'] as String,
        cardId: json['cardId'] as String?,
        recurringPayinRegistrationId:
            json['recurringPayinRegistrationId'] as String?,
        nextPaymentDate: json['nextPaymentDate'] as String?,
        lastPaymentDate: json['lastPaymentDate'] as String?,
        endDate: json['endDate'] as String?,
        processingEnabled: json['processingEnabled'] as bool?,
        webhookNotificationEnabled: json['webhookNotificationEnabled'] as bool?,
        metadata: json['metadata'] as Map<String, Object?>?,
      );

  /// Subscription ID.
  final String id;

  /// Internal user ID.
  final String userId;

  /// Mangopay user ID.
  final String mangopayUserId;

  /// Wallet ID.
  final String walletId;

  /// Card ID.
  final String? cardId;

  /// Mangopay recurring registration ID.
  final String? recurringPayinRegistrationId;

  /// Subscription status.
  final SubscriptionStatus status;

  /// Amount in smallest currency unit.
  final int amount;

  /// Currency.
  final Currency currency;

  /// Payment frequency.
  final SubscriptionFrequency frequency;

  /// Next scheduled payment date (ISO 8601).
  final String? nextPaymentDate;

  /// Last successful payment date (ISO 8601).
  final String? lastPaymentDate;

  /// Subscription start date (ISO 8601).
  final String startDate;

  /// Subscription end date (ISO 8601).
  final String? endDate;

  /// Whether automatic processing is enabled.
  final bool? processingEnabled;

  /// Whether webhook notifications are enabled.
  final bool? webhookNotificationEnabled;

  /// Custom metadata.
  final Map<String, Object?>? metadata;

  /// Creation timestamp (ISO 8601).
  final String createdAt;

  /// Last update timestamp (ISO 8601).
  final String updatedAt;

  /// Whether the subscription is active.
  bool get isActive => status == SubscriptionStatus.ACTIVE;

  /// Whether the subscription can be cancelled.
  bool get canCancel =>
      status == SubscriptionStatus.ACTIVE ||
      status == SubscriptionStatus.PAUSED;

  /// Formatted amount.
  Money get amountAsMoney => Money(amount: amount, currency: currency);

  /// Converts to JSON.
  Map<String, Object?> toJson() => {
        'id': id,
        'userId': userId,
        'mangopayUserId': mangopayUserId,
        'walletId': walletId,
        'status': status.name,
        'amount': amount,
        'currency': currency.name,
        'frequency': frequency.name,
        'startDate': startDate,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        if (cardId != null) 'cardId': cardId,
        if (recurringPayinRegistrationId != null)
          'recurringPayinRegistrationId': recurringPayinRegistrationId,
        if (nextPaymentDate != null) 'nextPaymentDate': nextPaymentDate,
        if (lastPaymentDate != null) 'lastPaymentDate': lastPaymentDate,
        if (endDate != null) 'endDate': endDate,
        if (processingEnabled != null) 'processingEnabled': processingEnabled,
        if (webhookNotificationEnabled != null)
          'webhookNotificationEnabled': webhookNotificationEnabled,
        if (metadata != null) 'metadata': metadata,
      };
}

/// A subscription payment record.
class SubscriptionPayment {
  /// Creates a subscription payment.
  const SubscriptionPayment({
    required this.id,
    required this.subscriptionId,
    required this.amount,
    required this.currency,
    required this.status,
    required this.scheduledDate,
    this.payinId,
    this.processedAt,
    this.errorMessage,
  });

  /// Creates from JSON.
  factory SubscriptionPayment.fromJson(Map<String, Object?> json) =>
      SubscriptionPayment(
        id: json['id'] as String,
        subscriptionId: json['subscriptionId'] as String,
        amount: json['amount'] as int,
        currency: Currency.values.byName(json['currency'] as String),
        status:
            SubscriptionPaymentStatus.values.byName(json['status'] as String),
        scheduledDate: json['scheduledDate'] as String,
        payinId: json['payinId'] as String?,
        processedAt: json['processedAt'] as String?,
        errorMessage: json['errorMessage'] as String?,
      );

  /// Payment ID.
  final String id;

  /// Subscription ID.
  final String subscriptionId;

  /// Associated payin ID.
  final String? payinId;

  /// Amount.
  final int amount;

  /// Currency.
  final Currency currency;

  /// Payment status.
  final SubscriptionPaymentStatus status;

  /// Scheduled date (ISO 8601).
  final String scheduledDate;

  /// Processing timestamp (ISO 8601).
  final String? processedAt;

  /// Error message if failed.
  final String? errorMessage;

  /// Whether payment succeeded.
  bool get isSuccessful => status == SubscriptionPaymentStatus.SUCCEEDED;

  /// Converts to JSON.
  Map<String, Object?> toJson() => {
        'id': id,
        'subscriptionId': subscriptionId,
        'amount': amount,
        'currency': currency.name,
        'status': status.name,
        'scheduledDate': scheduledDate,
        if (payinId != null) 'payinId': payinId,
        if (processedAt != null) 'processedAt': processedAt,
        if (errorMessage != null) 'errorMessage': errorMessage,
      };
}

/// Subscription with payment history.
class SubscriptionWithPayments extends RecurringSubscription {
  /// Creates a subscription with payments.
  SubscriptionWithPayments({
    required super.id,
    required super.userId,
    required super.mangopayUserId,
    required super.walletId,
    required super.status,
    required super.amount,
    required super.currency,
    required super.frequency,
    required super.startDate,
    required super.createdAt,
    required super.updatedAt,
    required this.payments,
    super.cardId,
    super.recurringPayinRegistrationId,
    super.nextPaymentDate,
    super.lastPaymentDate,
    super.endDate,
    super.processingEnabled,
    super.webhookNotificationEnabled,
    super.metadata,
  });

  /// Creates from JSON.
  factory SubscriptionWithPayments.fromJson(Map<String, Object?> json) {
    final base = RecurringSubscription.fromJson(json);
    return SubscriptionWithPayments(
      id: base.id,
      userId: base.userId,
      mangopayUserId: base.mangopayUserId,
      walletId: base.walletId,
      status: base.status,
      amount: base.amount,
      currency: base.currency,
      frequency: base.frequency,
      startDate: base.startDate,
      createdAt: base.createdAt,
      updatedAt: base.updatedAt,
      cardId: base.cardId,
      recurringPayinRegistrationId: base.recurringPayinRegistrationId,
      nextPaymentDate: base.nextPaymentDate,
      lastPaymentDate: base.lastPaymentDate,
      endDate: base.endDate,
      processingEnabled: base.processingEnabled,
      webhookNotificationEnabled: base.webhookNotificationEnabled,
      metadata: base.metadata,
      payments: (json['payments'] as List<Object?>? ?? [])
          .cast<Map<String, Object?>>()
          .map(SubscriptionPayment.fromJson)
          .toList(growable: false),
    );
  }

  /// Payment history.
  final List<SubscriptionPayment> payments;
}

/// Request to register a new subscription.
class RegisterSubscriptionRequest {
  /// Creates a subscription registration request.
  const RegisterSubscriptionRequest({
    required this.userId,
    required this.mangopayUserId,
    required this.walletId,
    required this.cardId,
    required this.amount,
    required this.currency,
    required this.frequency,
    this.startDate,
    this.endDate,
    this.metadata,
    this.webhookNotificationEnabled,
  });

  /// Internal user ID.
  final String userId;

  /// Mangopay user ID.
  final String mangopayUserId;

  /// Wallet ID to credit.
  final String walletId;

  /// Card ID to charge.
  final String cardId;

  /// Amount in smallest currency unit.
  final int amount;

  /// Currency.
  final Currency currency;

  /// Payment frequency.
  final SubscriptionFrequency frequency;

  /// Start date (ISO 8601). Defaults to now.
  final String? startDate;

  /// End date (ISO 8601). Optional.
  final String? endDate;

  /// Custom metadata.
  final Map<String, Object?>? metadata;

  /// Enable webhook notifications.
  final bool? webhookNotificationEnabled;

  /// Converts to JSON.
  Map<String, Object?> toJson() => {
        'userId': userId,
        'mangopayUserId': mangopayUserId,
        'walletId': walletId,
        'cardId': cardId,
        'amount': amount,
        'currency': currency.name,
        'frequency': frequency.name,
        if (startDate != null) 'startDate': startDate,
        if (endDate != null) 'endDate': endDate,
        if (metadata != null) 'metadata': metadata,
        if (webhookNotificationEnabled != null)
          'webhookNotificationEnabled': webhookNotificationEnabled,
      };
}

/// Request to update a subscription.
class UpdateSubscriptionRequest {
  /// Creates an update request.
  const UpdateSubscriptionRequest({
    this.amount,
    this.cardId,
    this.endDate,
    this.processingEnabled,
    this.webhookNotificationEnabled,
    this.metadata,
  });

  /// New amount.
  final int? amount;

  /// New card ID.
  final String? cardId;

  /// New end date.
  final String? endDate;

  /// Enable/disable processing.
  final bool? processingEnabled;

  /// Enable/disable webhooks.
  final bool? webhookNotificationEnabled;

  /// New metadata.
  final Map<String, Object?>? metadata;

  /// Converts to JSON.
  Map<String, Object?> toJson() => {
        if (amount != null) 'amount': amount,
        if (cardId != null) 'cardId': cardId,
        if (endDate != null) 'endDate': endDate,
        if (processingEnabled != null) 'processingEnabled': processingEnabled,
        if (webhookNotificationEnabled != null)
          'webhookNotificationEnabled': webhookNotificationEnabled,
        if (metadata != null) 'metadata': metadata,
      };
}

/// Filters for listing subscriptions.
class SubscriptionListFilters {
  /// Creates list filters.
  const SubscriptionListFilters({
    this.userId,
    this.mangopayUserId,
    this.status,
    this.page,
    this.perPage,
  });

  /// Filter by internal user ID.
  final String? userId;

  /// Filter by Mangopay user ID.
  final String? mangopayUserId;

  /// Filter by status.
  final SubscriptionStatus? status;

  /// Page number.
  final int? page;

  /// Items per page.
  final int? perPage;

  /// Converts to query params.
  Map<String, String> toQueryParams() => {
        if (userId != null) 'userId': userId!,
        if (mangopayUserId != null) 'mangopayUserId': mangopayUserId!,
        if (status != null) 'status': status!.name,
        if (page != null) 'page': page.toString(),
        if (perPage != null) 'per_page': perPage.toString(),
      };
}

/// Response from syncing a subscription.
class SyncSubscriptionResponse {
  /// Creates a sync response.
  const SyncSubscriptionResponse({
    required this.subscription,
    required this.synced,
    this.message,
  });

  /// Creates from JSON.
  factory SyncSubscriptionResponse.fromJson(Map<String, Object?> json) =>
      SyncSubscriptionResponse(
        subscription: RecurringSubscription.fromJson(
          json['subscription'] as Map<String, Object?>,
        ),
        synced: json['synced'] as bool,
        message: json['message'] as String?,
      );

  /// Updated subscription.
  final RecurringSubscription subscription;

  /// Whether sync was successful.
  final bool synced;

  /// Sync message.
  final String? message;
}
