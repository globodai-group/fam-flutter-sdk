/// PayOuts module for the FAM SDK.
///
/// Provides methods for bank wire withdrawals.
library;

import 'package:fam_sdk/src/client.dart';
import 'package:fam_sdk/src/modules/base.dart';
import 'package:fam_sdk/src/types/types.dart';

/// Module for pay-out operations.
///
/// ```dart
/// // Create a payout to bank account
/// final payout = await fam.payouts.create(
///   CreatePayoutRequest(
///     authorId: 'user_123',
///     debitedWalletId: 'wallet_456',
///     debitedFunds: Money(amount: 10000, currency: Currency.EUR),
///     fees: Money(amount: 0, currency: Currency.EUR),
///     bankAccountId: 'bank_789',
///     payoutModeRequested: PayoutMode.INSTANT_PAYMENT,
///   ),
/// );
/// ```
class PayoutsModule extends BaseModule {
  /// Creates a payouts module.
  const PayoutsModule(HttpClient client) : super(client, '/api/v1/mangopay/payouts');

  /// Creates a new payout.
  Future<Payout> create(CreatePayoutRequest data) => post(
        '',
        body: data.toJson(),
        fromJson: (json) => Payout.fromJson(json! as Map<String, Object?>),
      );

  /// Gets a payout by ID.
  Future<Payout> getPayout(String payoutId) => get(
        '/$payoutId',
        fromJson: (json) => Payout.fromJson(json! as Map<String, Object?>),
      );
}
