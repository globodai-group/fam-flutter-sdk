/// Subscriptions module for the FAM SDK.
///
/// Provides methods for managing recurring subscriptions (FAM custom feature).
library;

import 'package:fam_sdk/src/client.dart';
import 'package:fam_sdk/src/modules/base.dart';
import 'package:fam_sdk/src/types/types.dart';

/// Module for subscription operations.
///
/// This is a FAM-specific feature for managing recurring payments.
///
/// ```dart
/// // Register a subscription
/// final subscription = await fam.subscriptions.register(
///   RegisterSubscriptionRequest(
///     userId: 'internal_user_id',
///     mangopayUserId: 'mp_user_123',
///     walletId: 'wallet_456',
///     cardId: 'card_789',
///     amount: 999, // 9.99 EUR
///     currency: Currency.EUR,
///     frequency: SubscriptionFrequency.MONTHLY,
///   ),
/// );
///
/// // Get subscription with payments
/// final details = await fam.subscriptions.getSubscription(subscription.id);
/// print('Next payment: ${details.nextPaymentDate}');
///
/// // Cancel subscription
/// await fam.subscriptions.cancel(subscription.id);
/// ```
class SubscriptionsModule extends BaseModule {
  /// Creates a subscriptions module.
  const SubscriptionsModule(HttpClient client)
      : super(client, '/api/v1/mangopay/recurring-subscriptions');

  /// Registers a new subscription.
  Future<RecurringSubscription> register(RegisterSubscriptionRequest data) =>
      post(
        '',
        body: data.toJson(),
        fromJson: (json) =>
            RecurringSubscription.fromJson(json! as Map<String, Object?>),
      );

  /// Gets a subscription with its payment history.
  Future<SubscriptionWithPayments> getSubscription(String subscriptionId) =>
      get(
        '/$subscriptionId',
        fromJson: (json) =>
            SubscriptionWithPayments.fromJson(json! as Map<String, Object?>),
      );

  /// Lists subscriptions with optional filters.
  Future<PaginatedResponse<RecurringSubscription>> list({
    SubscriptionListFilters? filters,
  }) =>
      get(
        '',
        options: RequestOptions(params: filters?.toQueryParams()),
        fromJson: (json) => PaginatedResponse.fromJson(
          json! as Map<String, Object?>,
          RecurringSubscription.fromJson,
        ),
      );

  /// Updates a subscription.
  Future<RecurringSubscription> update(
    String subscriptionId,
    UpdateSubscriptionRequest data,
  ) =>
      patch(
        '/$subscriptionId',
        body: data.toJson(),
        fromJson: (json) =>
            RecurringSubscription.fromJson(json! as Map<String, Object?>),
      );

  /// Syncs a subscription with the payment provider.
  ///
  /// Updates the local subscription state to match the provider.
  Future<SyncSubscriptionResponse> sync(String subscriptionId) => post(
        '/$subscriptionId/sync',
        fromJson: (json) =>
            SyncSubscriptionResponse.fromJson(json! as Map<String, Object?>),
      );

  /// Cancels a subscription.
  ///
  /// No more payments will be processed after cancellation.
  Future<RecurringSubscription> cancel(String subscriptionId) => post(
        '/$subscriptionId/cancel',
        fromJson: (json) =>
            RecurringSubscription.fromJson(json! as Map<String, Object?>),
      );

  /// Enables processing for a subscription.
  ///
  /// Resumes automatic payment processing.
  Future<RecurringSubscription> enable(String subscriptionId) => post(
        '/$subscriptionId/enable',
        fromJson: (json) =>
            RecurringSubscription.fromJson(json! as Map<String, Object?>),
      );

  /// Disables processing for a subscription.
  ///
  /// Pauses automatic payment processing without cancelling.
  Future<RecurringSubscription> disable(String subscriptionId) => post(
        '/$subscriptionId/disable',
        fromJson: (json) =>
            RecurringSubscription.fromJson(json! as Map<String, Object?>),
      );
}
