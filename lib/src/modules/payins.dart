/// PayIns module for the FAM SDK.
///
/// Provides methods for card payments and recurring payments.
library;

import 'package:fam_sdk/src/client.dart';
import 'package:fam_sdk/src/modules/base.dart';
import 'package:fam_sdk/src/types/types.dart';

/// Module for pay-in operations.
///
/// ```dart
/// // Create a card payment
/// final payin = await fam.payins.create(
///   CreateCardDirectPayinRequest(
///     authorId: 'user_123',
///     creditedWalletId: 'wallet_456',
///     debitedFunds: Money(amount: 1000, currency: Currency.EUR),
///     fees: Money(amount: 50, currency: Currency.EUR),
///     cardId: 'card_789',
///     secureModeReturnUrl: 'https://example.com/callback',
///   ),
/// );
///
/// // Check if 3DS redirect is needed
/// if (payin.requiresSecureModeRedirect) {
///   // Redirect user to payin.secureModeRedirectUrl
/// }
/// ```
class PayinsModule extends BaseModule {
  /// Creates a payins module.
  const PayinsModule(HttpClient client) : super(client, '/api/v1/mangopay/payins');

  // ─────────────────────────────────────────────────────────────────────────
  // Direct Card PayIn
  // ─────────────────────────────────────────────────────────────────────────

  /// Creates a direct card pay-in.
  Future<Payin> create(CreateCardDirectPayinRequest data) => post(
        '/card/direct',
        body: data.toJson(),
        fromJson: (json) => Payin.fromJson(json! as Map<String, Object?>),
      );

  /// Gets a pay-in by ID.
  Future<Payin> getPayin(String payinId) => get(
        '/$payinId',
        fromJson: (json) => Payin.fromJson(json! as Map<String, Object?>),
      );

  /// Refunds a pay-in.
  Future<Refund> refund(String payinId, CreateRefundRequest data) => post(
        '/$payinId/refunds',
        body: data.toJson(),
        fromJson: (json) => Refund.fromJson(json! as Map<String, Object?>),
      );

  // ─────────────────────────────────────────────────────────────────────────
  // Recurring Payments
  // ─────────────────────────────────────────────────────────────────────────

  /// Creates a recurring payment registration.
  Future<RecurringPaymentRegistration> createRecurringPayment(
    CreateRecurringPaymentRequest data,
  ) =>
      post(
        '/recurring/registrations',
        body: data.toJson(),
        fromJson: (json) =>
            RecurringPaymentRegistration.fromJson(json! as Map<String, Object?>),
      );

  /// Gets a recurring payment registration.
  Future<RecurringPaymentRegistration> viewRecurringPayment(
    String registrationId,
  ) =>
      get(
        '/recurring/registrations/$registrationId',
        fromJson: (json) =>
            RecurringPaymentRegistration.fromJson(json! as Map<String, Object?>),
      );

  /// Updates a recurring payment registration.
  Future<RecurringPaymentRegistration> updateRecurringPayment(
    String registrationId,
    UpdateRecurringPaymentRequest data,
  ) =>
      put(
        '/recurring/registrations/$registrationId',
        body: data.toJson(),
        fromJson: (json) =>
            RecurringPaymentRegistration.fromJson(json! as Map<String, Object?>),
      );

  /// Ends a recurring payment registration.
  Future<RecurringPaymentRegistration> endRecurringPayment(
    String registrationId,
  ) =>
      put(
        '/recurring/registrations/$registrationId',
        body: {'Status': 'ENDED'},
        fromJson: (json) =>
            RecurringPaymentRegistration.fromJson(json! as Map<String, Object?>),
      );

  // ─────────────────────────────────────────────────────────────────────────
  // Recurring CIT/MIT
  // ─────────────────────────────────────────────────────────────────────────

  /// Creates a recurring CIT (Customer-Initiated Transaction).
  ///
  /// Used for the first payment in a recurring series where
  /// the customer is present and can authenticate.
  Future<Payin> createRecurringCit(CreateRecurringCitPayinRequest data) => post(
        '/recurring/cit',
        body: data.toJson(),
        fromJson: (json) => Payin.fromJson(json! as Map<String, Object?>),
      );

  /// Creates a recurring MIT (Merchant-Initiated Transaction).
  ///
  /// Used for subsequent payments in a recurring series where
  /// the customer is not present.
  Future<Payin> createRecurringMit(CreateRecurringMitPayinRequest data) => post(
        '/recurring/mit',
        body: data.toJson(),
        fromJson: (json) => Payin.fromJson(json! as Map<String, Object?>),
      );
}
