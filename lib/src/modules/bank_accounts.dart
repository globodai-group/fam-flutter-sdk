/// Bank Accounts module for the FAM SDK.
///
/// Provides methods for managing user bank accounts.
library;

import 'package:fam_sdk/src/client.dart';
import 'package:fam_sdk/src/modules/base.dart';
import 'package:fam_sdk/src/types/types.dart';

/// Module for bank account operations (user-scoped).
///
/// ```dart
/// // Get the bank accounts module for a user
/// final bankAccounts = fam.bankAccounts('user_123');
///
/// // Create an IBAN account
/// final account = await bankAccounts.createIban(
///   CreateIbanBankAccountRequest(
///     ownerName: 'John Doe',
///     ownerAddress: Address(
///       addressLine1: '123 Main St',
///       city: 'Paris',
///       postalCode: '75001',
///       country: 'FR',
///     ),
///     iban: 'FR7630006000011234567890189',
///   ),
/// );
/// ```
class BankAccountsModule extends UserScopedModule {
  /// Creates a bank accounts module for a specific user.
  BankAccountsModule(HttpClient client, String userId)
      : super(client, '/api/v1/mangopay/users/$userId/bankaccounts', userId);

  // ───────────────────────────────────────────────────────────────────────────
  // Create Bank Accounts
  // ───────────────────────────────────────────────────────────────────────────

  /// Creates an IBAN bank account.
  Future<IbanBankAccount> createIban(CreateIbanBankAccountRequest data) => post(
        '/iban',
        body: data.toJson(),
        fromJson: (json) => IbanBankAccount.fromJson(
          json! as Map<String, Object?>,
        ),
      );

  /// Creates a UK (GB) bank account.
  Future<GbBankAccount> createGb(CreateGbBankAccountRequest data) => post(
        '/gb',
        body: data.toJson(),
        fromJson: (json) => GbBankAccount.fromJson(
          json! as Map<String, Object?>,
        ),
      );

  /// Creates a US bank account.
  Future<UsBankAccount> createUs(CreateUsBankAccountRequest data) => post(
        '/us',
        body: data.toJson(),
        fromJson: (json) => UsBankAccount.fromJson(
          json! as Map<String, Object?>,
        ),
      );

  /// Creates a Canadian bank account.
  Future<CaBankAccount> createCa(CreateCaBankAccountRequest data) => post(
        '/ca',
        body: data.toJson(),
        fromJson: (json) => CaBankAccount.fromJson(
          json! as Map<String, Object?>,
        ),
      );

  /// Creates an other format bank account.
  Future<OtherBankAccount> createOther(CreateOtherBankAccountRequest data) =>
      post(
        '/other',
        body: data.toJson(),
        fromJson: (json) => OtherBankAccount.fromJson(
          json! as Map<String, Object?>,
        ),
      );

  // ───────────────────────────────────────────────────────────────────────────
  // Read/List Bank Accounts
  // ───────────────────────────────────────────────────────────────────────────

  /// Gets a bank account by ID.
  Future<BankAccount> getAccount(String accountId) => get(
        '/$accountId',
        fromJson: (json) => parseBankAccount(json! as Map<String, Object?>),
      );

  /// Lists all bank accounts for the user.
  Future<PaginatedResponse<BankAccount>> list({PaginationParams? params}) =>
      get(
        '',
        options: RequestOptions(params: params?.toQueryParams()),
        fromJson: (json) => PaginatedResponse.fromJson(
          json! as Map<String, Object?>,
          parseBankAccount,
        ),
      );

  // ───────────────────────────────────────────────────────────────────────────
  // Update Bank Accounts
  // ───────────────────────────────────────────────────────────────────────────

  /// Deactivates a bank account.
  ///
  /// This action is irreversible.
  Future<BankAccount> deactivate(String accountId) => put(
        '/$accountId',
        body: {'Active': false},
        fromJson: (json) => parseBankAccount(json! as Map<String, Object?>),
      );
}
