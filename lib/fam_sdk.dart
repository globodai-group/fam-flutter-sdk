/// FAM SDK for Flutter
///
/// A native Flutter SDK for FAM API integrations including payments,
/// subscriptions, and user management.
///
/// ## Quick Start
///
/// ```dart
/// import 'package:fam_sdk/fam_sdk.dart';
///
/// // Initialize the SDK
/// final fam = Fam(
///   FamOptions(
///     baseUrl: 'https://api.fam.example.com',
///     token: 'your-api-token',
///   ),
/// );
///
/// // Create a user
/// final user = await fam.users.createNatural(
///   CreateNaturalUserRequest(
///     email: 'user@example.com',
///     firstName: 'John',
///     lastName: 'Doe',
///     birthday: DateTime(1990, 1, 15),
///     nationality: 'FR',
///     countryOfResidence: 'FR',
///   ),
/// );
///
/// // Create a wallet
/// final wallet = await fam.wallets.create(
///   CreateWalletRequest(
///     owners: [user.id],
///     description: 'Main Wallet',
///     currency: Currency.EUR,
///   ),
/// );
///
/// // Clean up
/// fam.close();
/// ```
///
/// ## Features
///
/// - **Users**: Create and manage natural and legal users
/// - **Wallets**: Manage e-wallets and view transactions
/// - **Pay-ins**: Process card payments and recurring payments
/// - **Pay-outs**: Withdraw funds to bank accounts
/// - **Transfers**: Transfer funds between wallets
/// - **Cards**: Card tokenization and management
/// - **Bank Accounts**: IBAN, GB, US, CA, and other bank accounts
/// - **KYC**: Document submission and verification
/// - **UBO**: Ultimate beneficial owner declarations
/// - **Subscriptions**: Recurring subscription management
/// - **Portal**: Customer portal sessions
/// - **Webhooks**: Secure webhook handling with signature verification
/// - **UI Components**: Pre-built payment widgets (PaymentSheet, CardForm)
///
/// ## UI Components
///
/// For applications requiring payment UI, import the UI library:
///
/// ```dart
/// import 'package:fam_sdk/ui.dart';
///
/// // Show the payment sheet
/// await FamPaymentSheet.show(
///   context: context,
///   config: PaymentSheetConfig(
///     walletId: wallet.id,
///     amount: 1000,
///     currency: Currency.EUR,
///   ),
///   onComplete: (result) => print('Payment: ${result.status}'),
/// );
/// ```
///
/// ## Error Handling
///
/// All SDK errors extend [FamException]:
///
/// ```dart
/// try {
///   await fam.users.getUser('user_123');
/// } on AuthenticationException catch (e) {
///   // Invalid or expired token
/// } on NotFoundException catch (e) {
///   // Resource not found
/// } on ValidationException catch (e) {
///   // Validation errors
///   print(e.errors);
/// } on FamException catch (e) {
///   // Any other SDK error
/// }
/// ```
library fam_sdk;

// Core
export 'src/fam.dart';
export 'src/client.dart' show FamOptions, RequestOptions;

// Errors
export 'src/errors/errors.dart';

// Types
export 'src/types/types.dart';

// Modules (for advanced usage)
export 'src/modules/modules.dart';

// Webhooks
export 'src/webhooks/webhooks.dart';
