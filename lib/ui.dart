/// FAM SDK UI Components for Flutter
///
/// Pre-built payment UI widgets including PaymentSheet, CardForm, and CardField.
///
/// ## Usage
///
/// ```dart
/// import 'package:fam_sdk/fam_sdk.dart';
/// import 'package:fam_sdk/ui.dart';
///
/// // Use the theme
/// MaterialApp(
///   home: FamThemeProvider(
///     theme: FamTheme(
///       primaryColor: Colors.blue,
///       errorColor: Colors.red,
///     ),
///     child: MyApp(),
///   ),
/// );
///
/// // Show the payment sheet
/// await FamPaymentSheet.show(
///   context: context,
///   config: PaymentSheetConfig(
///     walletId: 'wallet_123',
///     amount: 1000,
///     currency: Currency.EUR,
///   ),
///   onComplete: (result) {
///     if (result.status == PaymentStatus.succeeded) {
///       print('Payment successful!');
///     }
///   },
/// );
///
/// // Or use individual components
/// CardForm(
///   onCardChanged: (details) {
///     print('Card complete: ${details.complete}');
///   },
/// );
/// ```
///
/// ## Theming
///
/// Customize the appearance of all FAM UI components:
///
/// ```dart
/// FamTheme(
///   primaryColor: Colors.indigo,
///   backgroundColor: Colors.white,
///   surfaceColor: Colors.grey[100]!,
///   textColor: Colors.grey[900]!,
///   hintColor: Colors.grey[500]!,
///   errorColor: Colors.red,
///   borderColor: Colors.grey[300]!,
///   borderRadius: BorderRadius.circular(12),
///   inputPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
/// );
/// ```
library fam_sdk.ui;

export 'src/ui/ui.dart';
