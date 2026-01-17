/// Main FAM SDK class.
///
/// Provides access to all API modules and functionality.
library;

import 'package:fam_sdk/src/client.dart';
import 'package:fam_sdk/src/modules/modules.dart';

export 'package:fam_sdk/src/client.dart' show FamOptions, RequestOptions;

/// FAM SDK client.
///
/// Main entry point for interacting with the FAM API.
///
/// ```dart
/// // Initialize the SDK
/// final fam = Fam(
///   FamOptions(
///     baseUrl: 'https://api.fam.example.com',
///     token: 'your-api-token',
///   ),
/// );
///
/// // Use modules
/// final user = await fam.users.createNatural(...);
/// final wallet = await fam.wallets.create(...);
/// final payin = await fam.payins.create(...);
///
/// // User-scoped modules
/// final bankAccounts = fam.bankAccounts(user.id);
/// await bankAccounts.createIban(...);
///
/// // Update token
/// fam.setToken('new-token');
///
/// // Clean up
/// fam.close();
/// ```
class Fam {
  /// Creates a new FAM SDK instance.
  Fam(FamOptions options) : _client = HttpClient(options) {
    _initializeModules();
  }

  final HttpClient _client;

  // ─────────────────────────────────────────────────────────────────────────
  // Core Modules
  // ─────────────────────────────────────────────────────────────────────────

  /// Users module for managing natural and legal users.
  late final UsersModule users;

  /// Wallets module for wallet operations.
  late final WalletsModule wallets;

  /// Pay-ins module for card payments and recurring payments.
  late final PayinsModule payins;

  /// Pay-outs module for bank wire withdrawals.
  late final PayoutsModule payouts;

  /// Transfers module for wallet-to-wallet transfers.
  late final TransfersModule transfers;

  // ─────────────────────────────────────────────────────────────────────────
  // Card Modules
  // ─────────────────────────────────────────────────────────────────────────

  /// Card registrations module for tokenizing cards.
  late final CardRegistrationsModule cardRegistrations;

  /// Cards module for card operations.
  late final CardsModule cards;

  /// Preauthorizations module for holding funds.
  late final PreauthorizationsModule preauthorizations;

  // ─────────────────────────────────────────────────────────────────────────
  // FAM Custom Modules
  // ─────────────────────────────────────────────────────────────────────────

  /// Subscriptions module for recurring subscription management.
  late final SubscriptionsModule subscriptions;

  /// Portal module for customer portal sessions.
  late final PortalModule portal;

  void _initializeModules() {
    users = UsersModule(_client);
    wallets = WalletsModule(_client);
    payins = PayinsModule(_client);
    payouts = PayoutsModule(_client);
    transfers = TransfersModule(_client);
    cardRegistrations = CardRegistrationsModule(_client);
    cards = CardsModule(_client);
    preauthorizations = PreauthorizationsModule(_client);
    subscriptions = SubscriptionsModule(_client);
    portal = PortalModule(_client);
  }

  // ─────────────────────────────────────────────────────────────────────────
  // User-Scoped Modules
  // ─────────────────────────────────────────────────────────────────────────

  /// Gets a bank accounts module for a specific user.
  ///
  /// ```dart
  /// final bankAccounts = fam.bankAccounts('user_123');
  /// await bankAccounts.createIban(...);
  /// ```
  BankAccountsModule bankAccounts(String userId) =>
      BankAccountsModule(_client, userId);

  /// Gets a KYC module for a specific user.
  ///
  /// ```dart
  /// final kyc = fam.kyc('user_123');
  /// await kyc.create(CreateKycDocumentRequest(...));
  /// ```
  KycModule kyc(String userId) => KycModule(_client, userId);

  /// Gets a UBO module for a specific legal user.
  ///
  /// ```dart
  /// final ubo = fam.ubo('legal_user_123');
  /// await ubo.createDeclaration();
  /// ```
  UboModule ubo(String userId) => UboModule(_client, userId);

  /// Gets an SCA recipients module for a specific user.
  ///
  /// ```dart
  /// final recipients = fam.scaRecipients('user_123');
  /// await recipients.create(...);
  /// ```
  ScaRecipientsModule scaRecipients(String userId) =>
      ScaRecipientsModule(_client, userId);

  // ─────────────────────────────────────────────────────────────────────────
  // Token Management
  // ─────────────────────────────────────────────────────────────────────────

  /// Updates the authentication token.
  ///
  /// Use this when the token is refreshed or when switching users.
  void setToken(String token) {
    _client.setToken(token);
  }

  /// Clears the authentication token.
  ///
  /// Subsequent requests will not include the Authorization header.
  void clearToken() {
    _client.clearToken();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Lifecycle
  // ─────────────────────────────────────────────────────────────────────────

  /// Closes the SDK and releases resources.
  ///
  /// Call this when you're done using the SDK.
  void close() {
    _client.close();
  }
}
