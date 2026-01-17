/// Wallets module for the FAM SDK.
///
/// Provides methods for wallet management.
library;

import 'package:fam_sdk/src/client.dart';
import 'package:fam_sdk/src/modules/base.dart';
import 'package:fam_sdk/src/types/types.dart';

/// Module for wallet operations.
///
/// ```dart
/// // Create a wallet
/// final wallet = await fam.wallets.create(
///   CreateWalletRequest(
///     owners: ['user_123'],
///     description: 'Main Wallet',
///     currency: Currency.EUR,
///   ),
/// );
///
/// // Check balance
/// print('Balance: ${wallet.balance}');
/// ```
class WalletsModule extends BaseModule {
  /// Creates a wallets module.
  const WalletsModule(HttpClient client) : super(client, '/api/v1/mangopay/wallets');

  /// Creates a new wallet.
  Future<Wallet> create(CreateWalletRequest data) => post(
        '',
        body: data.toJson(),
        fromJson: (json) => Wallet.fromJson(json! as Map<String, Object?>),
      );

  /// Gets a wallet by ID.
  Future<Wallet> getWallet(String walletId) => get(
        '/$walletId',
        fromJson: (json) => Wallet.fromJson(json! as Map<String, Object?>),
      );

  /// Updates a wallet.
  Future<Wallet> update(String walletId, UpdateWalletRequest data) => put(
        '/$walletId',
        body: data.toJson(),
        fromJson: (json) => Wallet.fromJson(json! as Map<String, Object?>),
      );

  /// Gets transactions for a wallet.
  Future<PaginatedResponse<WalletTransaction>> getTransactions(
    String walletId, {
    PaginationParams? params,
  }) =>
      get(
        '/$walletId/transactions',
        options: RequestOptions(params: params?.toQueryParams()),
        fromJson: (json) => PaginatedResponse.fromJson(
          json! as Map<String, Object?>,
          WalletTransaction.fromJson,
        ),
      );
}
