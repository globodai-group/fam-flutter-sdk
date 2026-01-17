/// Transfers module for the FAM SDK.
///
/// Provides methods for wallet-to-wallet transfers.
library;

import 'package:fam_sdk/src/client.dart';
import 'package:fam_sdk/src/modules/base.dart';
import 'package:fam_sdk/src/types/types.dart';

/// Module for transfer operations.
///
/// ```dart
/// // Transfer between wallets
/// final transfer = await fam.transfers.create(
///   CreateTransferRequest(
///     authorId: 'user_123',
///     debitedWalletId: 'wallet_source',
///     creditedWalletId: 'wallet_dest',
///     debitedFunds: Money(amount: 1000, currency: Currency.EUR),
///     fees: Money(amount: 0, currency: Currency.EUR),
///   ),
/// );
/// ```
class TransfersModule extends BaseModule {
  /// Creates a transfers module.
  const TransfersModule(HttpClient client) : super(client, '/api/v1/mangopay/transfers');

  /// Creates a new transfer.
  Future<Transfer> create(CreateTransferRequest data) => post(
        '',
        body: data.toJson(),
        fromJson: (json) => Transfer.fromJson(json! as Map<String, Object?>),
      );

  /// Creates an SCA transfer.
  ///
  /// Used for transfers that require Strong Customer Authentication.
  Future<Transfer> createSca(CreateScaTransferRequest data) => post(
        '/sca',
        body: data.toJson(),
        fromJson: (json) => Transfer.fromJson(json! as Map<String, Object?>),
      );

  /// Gets a transfer by ID.
  Future<Transfer> getTransfer(String transferId) => get(
        '/$transferId',
        fromJson: (json) => Transfer.fromJson(json! as Map<String, Object?>),
      );

  /// Gets an SCA transfer by ID.
  Future<Transfer> getSca(String transferId) => get(
        '/sca/$transferId',
        fromJson: (json) => Transfer.fromJson(json! as Map<String, Object?>),
      );

  /// Refunds a transfer.
  Future<Refund> refund(String transferId, CreateTransferRefundRequest data) =>
      post(
        '/$transferId/refunds',
        body: data.toJson(),
        fromJson: (json) => Refund.fromJson(json! as Map<String, Object?>),
      );
}
