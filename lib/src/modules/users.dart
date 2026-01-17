/// Users module for the FAM SDK.
///
/// Provides methods for managing natural and legal users.
library;

import 'package:fam_sdk/src/client.dart';
import 'package:fam_sdk/src/modules/base.dart';
import 'package:fam_sdk/src/types/types.dart';

/// Module for user management operations.
///
/// ```dart
/// // Create a natural user
/// final user = await fam.users.createNatural(
///   CreateNaturalUserRequest(
///     firstName: 'John',
///     lastName: 'Doe',
///     email: 'john@example.com',
///     birthday: 315532800,
///     nationality: 'FR',
///     countryOfResidence: 'FR',
///   ),
/// );
///
/// // Get user
/// final retrieved = await fam.users.getUser(user.id);
/// ```
class UsersModule extends BaseModule {
  /// Creates a users module.
  const UsersModule(HttpClient client) : super(client, '/api/v1/mangopay/users');

  // ─────────────────────────────────────────────────────────────────────────
  // Natural Users
  // ─────────────────────────────────────────────────────────────────────────

  /// Creates a natural (individual) user.
  Future<NaturalUser> createNatural(CreateNaturalUserRequest data) => post(
        '/natural',
        body: data.toJson(),
        fromJson: (json) => NaturalUser.fromJson(json! as Map<String, Object?>),
      );

  /// Gets a natural user by ID.
  Future<NaturalUser> getNaturalUser(String userId) => get(
        '/natural/$userId',
        fromJson: (json) => NaturalUser.fromJson(json! as Map<String, Object?>),
      );

  /// Updates a natural user.
  Future<NaturalUser> updateNatural(
    String userId,
    UpdateNaturalUserRequest data,
  ) =>
      put(
        '/natural/$userId',
        body: data.toJson(),
        fromJson: (json) => NaturalUser.fromJson(json! as Map<String, Object?>),
      );

  // ─────────────────────────────────────────────────────────────────────────
  // Legal Users
  // ─────────────────────────────────────────────────────────────────────────

  /// Creates a legal (company) user.
  Future<LegalUser> createLegal(CreateLegalUserRequest data) => post(
        '/legal',
        body: data.toJson(),
        fromJson: (json) => LegalUser.fromJson(json! as Map<String, Object?>),
      );

  /// Gets a legal user by ID.
  Future<LegalUser> getLegalUser(String userId) => get(
        '/legal/$userId',
        fromJson: (json) => LegalUser.fromJson(json! as Map<String, Object?>),
      );

  /// Updates a legal user.
  Future<LegalUser> updateLegal(
    String userId,
    UpdateLegalUserRequest data,
  ) =>
      put(
        '/legal/$userId',
        body: data.toJson(),
        fromJson: (json) => LegalUser.fromJson(json! as Map<String, Object?>),
      );

  // ─────────────────────────────────────────────────────────────────────────
  // Generic User Operations
  // ─────────────────────────────────────────────────────────────────────────

  /// Gets a user by ID (returns NaturalUser or LegalUser).
  Future<User> getUser(String userId) => get(
        '/$userId',
        fromJson: (json) => parseUser(json! as Map<String, Object?>),
      );

  // ─────────────────────────────────────────────────────────────────────────
  // User Resources
  // ─────────────────────────────────────────────────────────────────────────

  /// Gets wallets owned by a user.
  Future<PaginatedResponse<Wallet>> getWallets(
    String userId, {
    PaginationParams? params,
  }) =>
      get(
        '/$userId/wallets',
        options: RequestOptions(params: params?.toQueryParams()),
        fromJson: (json) => PaginatedResponse.fromJson(
          json! as Map<String, Object?>,
          Wallet.fromJson,
        ),
      );

  /// Gets cards registered to a user.
  Future<PaginatedResponse<Card>> getCards(
    String userId, {
    PaginationParams? params,
  }) =>
      get(
        '/$userId/cards',
        options: RequestOptions(params: params?.toQueryParams()),
        fromJson: (json) => PaginatedResponse.fromJson(
          json! as Map<String, Object?>,
          Card.fromJson,
        ),
      );

  /// Gets bank accounts owned by a user.
  Future<PaginatedResponse<BankAccount>> getBankAccounts(
    String userId, {
    PaginationParams? params,
  }) =>
      get(
        '/$userId/bankaccounts',
        options: RequestOptions(params: params?.toQueryParams()),
        fromJson: (json) => PaginatedResponse.fromJson(
          json! as Map<String, Object?>,
          parseBankAccount,
        ),
      );

  /// Gets transactions for a user.
  Future<PaginatedResponse<WalletTransaction>> getTransactions(
    String userId, {
    PaginationParams? params,
  }) =>
      get(
        '/$userId/transactions',
        options: RequestOptions(params: params?.toQueryParams()),
        fromJson: (json) => PaginatedResponse.fromJson(
          json! as Map<String, Object?>,
          WalletTransaction.fromJson,
        ),
      );
}
