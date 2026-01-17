<p align="center">
  <img src="https://img.shields.io/badge/FAM-Flutter_SDK-0066FF?style=for-the-badge&logoColor=white" alt="FAM Flutter SDK" height="40">
</p>

<h1 align="center">FAM Flutter SDK</h1>

<p align="center">
  <strong>Official Flutter/Dart SDK for the FAM API</strong><br>
  <em>A type-safe, developer-friendly wrapper for Mangopay payment services</em>
</p>

<p align="center">
  <a href="https://github.com/globodai-group/fam-flutter-sdk/actions/workflows/ci.yml"><img src="https://github.com/globodai-group/fam-flutter-sdk/actions/workflows/ci.yml/badge.svg" alt="CI"></a>
  <a href="https://pub.dev/packages/fam_sdk"><img src="https://img.shields.io/pub/v/fam_sdk.svg?color=0066FF&label=pub.dev" alt="pub.dev version"></a>
  <a href="https://pub.dev/packages/fam_sdk"><img src="https://img.shields.io/pub/dm/fam_sdk.svg?color=green&label=downloads" alt="pub.dev downloads"></a>
  <a href="https://pub.dev/packages/fam_sdk"><img src="https://img.shields.io/badge/platform-android%20%7C%20ios%20%7C%20web%20%7C%20desktop-orange" alt="platforms"></a>
  <a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="License: MIT"></a>
</p>

<p align="center">
  <a href="#installation">Installation</a> •
  <a href="#quick-start">Quick Start</a> •
  <a href="#api-reference">API Reference</a> •
  <a href="#ui-components">UI Components</a> •
  <a href="#webhooks">Webhooks</a> •
  <a href="#error-handling">Error Handling</a> •
  <a href="#contributing">Contributing</a>
</p>

---

## Highlights

- **Full Dart Type Safety** — Strict types for all API requests and responses
- **Zero Dependencies** — Only `crypto` for HMAC, no other external dependencies
- **Multi-Platform** — Works on Android, iOS, Web, macOS, Windows, and Linux
- **Automatic Retries** — Built-in retry logic with exponential backoff
- **Comprehensive Errors** — Typed exception classes for precise error handling
- **Webhook Verification** — Secure signature verification out of the box
- **Pre-built UI** — Ready-to-use payment widgets (PaymentSheet, CardForm)

## Requirements

- Dart SDK 3.0.0 or higher
- Flutter 3.16.0 or higher

## Installation

```bash
flutter pub add fam_sdk
```

<details>
<summary>Using pubspec.yaml directly</summary>

```yaml
dependencies:
  fam_sdk: ^1.0.0
```

Then run:

```bash
flutter pub get
```

</details>

<details>
<summary>Installing from Git</summary>

```yaml
dependencies:
  fam_sdk:
    git:
      url: https://github.com/globodai-group/fam-flutter-sdk.git
      ref: main
```

</details>

## Quick Start

```dart
import 'package:fam_sdk/fam_sdk.dart';

// Initialize the client
final fam = Fam(
  apiKey: 'your-auth-token',
  options: FamOptions(
    baseUrl: 'https://api.fam.com',
  ),
);

// Create a user
final user = await fam.users.createNatural(
  CreateNaturalUserRequest(
    email: 'john.doe@example.com',
    firstName: 'John',
    lastName: 'Doe',
    birthday: DateTime(1990, 1, 15),
    nationality: 'FR',
    countryOfResidence: 'FR',
  ),
);

// Create a wallet
final wallet = await fam.wallets.create(
  CreateWalletRequest(
    owners: [user.id],
    description: 'Main wallet',
    currency: Currency.EUR,
  ),
);

print('Wallet created: ${wallet.id}');
```

## Configuration

```dart
import 'package:fam_sdk/fam_sdk.dart';

final fam = Fam(
  apiKey: 'your-auth-token',
  options: FamOptions(
    baseUrl: 'https://api.fam.com',
    timeout: Duration(seconds: 30),  // Request timeout (default: 30s)
    maxRetries: 3,                    // Retry attempts (default: 3)
  ),
);
```

## API Reference

### Users

<details open>
<summary><strong>Natural Users</strong></summary>

```dart
// Create a natural user
final user = await fam.users.createNatural(
  CreateNaturalUserRequest(
    email: 'user@example.com',
    firstName: 'John',
    lastName: 'Doe',
    birthday: DateTime(1990, 1, 15),
    nationality: 'FR',
    countryOfResidence: 'FR',
  ),
);

// Update a natural user
await fam.users.updateNatural(userId, UpdateNaturalUserRequest(
  firstName: 'Jane',
));

// Get user details
final user = await fam.users.getUser(userId);
final naturalUser = await fam.users.getNaturalUser(userId);
```

</details>

<details>
<summary><strong>Legal Users</strong></summary>

```dart
// Create a legal user
final company = await fam.users.createLegal(
  CreateLegalUserRequest(
    email: 'contact@company.com',
    name: 'ACME Corp',
    legalPersonType: LegalPersonType.BUSINESS,
    legalRepresentativeFirstName: 'John',
    legalRepresentativeLastName: 'Doe',
    legalRepresentativeBirthday: DateTime(1980, 5, 20),
    legalRepresentativeNationality: 'FR',
    legalRepresentativeCountryOfResidence: 'FR',
  ),
);

// Update and retrieve
await fam.users.updateLegal(userId, UpdateLegalUserRequest(name: 'ACME Corporation'));
final legalUser = await fam.users.getLegalUser(userId);
```

</details>

<details>
<summary><strong>User Resources</strong></summary>

```dart
// Get user's wallets, cards, bank accounts, and transactions
final wallets = await fam.users.getWallets(userId);
final cards = await fam.users.getCards(userId);
final bankAccounts = await fam.users.getBankAccounts(userId);
final transactions = await fam.users.getTransactions(userId);
```

</details>

### Wallets

```dart
// Create a wallet
final wallet = await fam.wallets.create(
  CreateWalletRequest(
    owners: [userId],
    description: 'EUR Wallet',
    currency: Currency.EUR,
  ),
);

// Get wallet details and transactions
final wallet = await fam.wallets.getWallet(walletId);
final transactions = await fam.wallets.getTransactions(walletId);
```

### Payments

<details open>
<summary><strong>Pay-ins</strong></summary>

```dart
// Create a card direct payin
final payin = await fam.payins.create(
  CreateCardDirectPayinRequest(
    authorId: userId,
    creditedWalletId: walletId,
    debitedFunds: Money(amount: 1000, currency: Currency.EUR),
    fees: Money(amount: 0, currency: Currency.EUR),
    cardId: cardId,
    secureModeReturnUrl: 'https://example.com/return',
  ),
);

// Get payin details
final payin = await fam.payins.getPayin(payinId);

// Refund a payin
final refund = await fam.payins.refund(payinId, CreateRefundRequest(
  authorId: userId,
));
```

</details>

<details>
<summary><strong>Recurring Payments</strong></summary>

```dart
// Create recurring payment registration
final recurring = await fam.payins.createRecurringPayment(
  CreateRecurringPaymentRequest(
    authorId: userId,
    cardId: cardId,
    creditedWalletId: walletId,
    firstTransactionDebitedFunds: Money(amount: 1000, currency: Currency.EUR),
    firstTransactionFees: Money(amount: 0, currency: Currency.EUR),
  ),
);

// Create Customer-Initiated Transaction (CIT)
final cit = await fam.payins.createRecurringCit(
  CreateRecurringCitPayinRequest(
    recurringPayinRegistrationId: recurring.id,
    debitedFunds: Money(amount: 1000, currency: Currency.EUR),
    fees: Money(amount: 0, currency: Currency.EUR),
    secureModeReturnUrl: 'https://example.com/return',
  ),
);

// Create Merchant-Initiated Transaction (MIT)
final mit = await fam.payins.createRecurringMit(
  CreateRecurringMitPayinRequest(
    recurringPayinRegistrationId: recurring.id,
    debitedFunds: Money(amount: 1000, currency: Currency.EUR),
    fees: Money(amount: 0, currency: Currency.EUR),
  ),
);
```

</details>

<details>
<summary><strong>Pay-outs</strong></summary>

```dart
// Create a payout to bank account
final payout = await fam.payouts.create(
  CreatePayoutRequest(
    authorId: userId,
    debitedWalletId: walletId,
    debitedFunds: Money(amount: 1000, currency: Currency.EUR),
    fees: Money(amount: 0, currency: Currency.EUR),
    bankAccountId: bankAccountId,
  ),
);

// Get payout details
final payout = await fam.payouts.getPayout(payoutId);
```

</details>

<details>
<summary><strong>Transfers</strong></summary>

```dart
// Create a wallet-to-wallet transfer
final transfer = await fam.transfers.create(
  CreateTransferRequest(
    authorId: userId,
    debitedWalletId: sourceWalletId,
    creditedWalletId: targetWalletId,
    debitedFunds: Money(amount: 1000, currency: Currency.EUR),
    fees: Money(amount: 0, currency: Currency.EUR),
  ),
);

// Get transfer details
final transfer = await fam.transfers.getTransfer(transferId);

// Refund a transfer
final refund = await fam.transfers.refund(transferId, CreateRefundRequest(
  authorId: userId,
));
```

</details>

### Cards

<details open>
<summary><strong>Card Registration</strong></summary>

```dart
// Create card registration
final registration = await fam.cardRegistrations.create(
  CreateCardRegistrationRequest(
    userId: userId,
    currency: Currency.EUR,
    cardType: CardType.CB_VISA_MASTERCARD,
  ),
);

// Update with tokenized card data
final updated = await fam.cardRegistrations.update(
  registration.id,
  UpdateCardRegistrationRequest(registrationData: tokenizedData),
);

// Get card from registration
final card = await fam.cards.getCard(updated.cardId!);
```

</details>

<details>
<summary><strong>Card Operations</strong></summary>

```dart
// Get card details
final card = await fam.cards.getCard(cardId);

// Deactivate a card
await fam.cards.deactivate(cardId);

// Validate a card
final validation = await fam.cardValidations.create(
  CreateCardValidationRequest(
    authorId: userId,
    cardId: cardId,
    secureModeReturnUrl: 'https://example.com/return',
    ipAddress: '192.168.1.1',
    browserInfo: browserInfo,
  ),
);
```

</details>

### User-Scoped Modules

<details open>
<summary><strong>Bank Accounts</strong></summary>

```dart
final bankAccounts = fam.bankAccounts(userId);

// Create IBAN bank account
final iban = await bankAccounts.createIban(
  CreateIbanBankAccountRequest(
    ownerName: 'John Doe',
    ownerAddress: Address(
      addressLine1: '1 rue de la Paix',
      city: 'Paris',
      postalCode: '75001',
      country: 'FR',
    ),
    iban: 'FR7630004000031234567890143',
  ),
);

// List and manage
final accounts = await bankAccounts.list();
final account = await bankAccounts.getAccount(accountId);
await bankAccounts.deactivate(accountId);
```

</details>

<details>
<summary><strong>KYC Documents</strong></summary>

```dart
final kyc = fam.kyc(userId);

// Create and submit KYC document
final document = await kyc.create(
  CreateKycDocumentRequest(type: KycDocumentType.IDENTITY_PROOF),
);
await kyc.createPage(document.id, fileBase64);
await kyc.submit(document.id);

// Check status
final status = await kyc.getDocument(document.id);
```

</details>

<details>
<summary><strong>UBO Declarations</strong></summary>

```dart
final ubo = fam.ubo(userId);

// Create UBO declaration
final declaration = await ubo.createDeclaration();

// Add Ultimate Beneficial Owner
final owner = await ubo.createUbo(
  declaration.id,
  CreateUboRequest(
    firstName: 'John',
    lastName: 'Doe',
    birthday: DateTime(1980, 1, 15),
    nationality: 'FR',
    address: Address(
      addressLine1: '1 rue de la Paix',
      city: 'Paris',
      postalCode: '75001',
      country: 'FR',
    ),
    birthplace: Birthplace(city: 'Paris', country: 'FR'),
  ),
);

// Submit declaration
await ubo.submit(declaration.id);
```

</details>

<details>
<summary><strong>SCA Recipients</strong></summary>

```dart
final recipients = fam.scaRecipients(userId);

// Get schema for recipient type
final schema = await recipients.getSchema(
  payoutMethodType: 'IBAN',
  recipientType: 'Individual',
  currency: 'EUR',
  country: 'FR',
);

// Create recipient
final recipient = await recipients.create(
  CreateRecipientRequest(
    displayName: 'John Doe - Main Account',
    payoutMethodType: PayoutMethodType.IBAN,
    recipientType: RecipientType.Individual,
    currency: Currency.EUR,
    // ... schema-specific fields
  ),
);
```

</details>

### Subscriptions

```dart
// Register a subscription
final subscription = await fam.subscriptions.register(
  CreateSubscriptionRequest(
    userId: userId,
    walletId: walletId,
    cardId: cardId,
    amount: Money(amount: 999, currency: Currency.EUR),
    frequency: SubscriptionFrequency.MONTHLY,
  ),
);

// Manage subscriptions
final subscriptions = await fam.subscriptions.list(userId: userId);
final subscription = await fam.subscriptions.getSubscription(subscriptionId);

// Lifecycle operations
await fam.subscriptions.enable(subscriptionId);
await fam.subscriptions.disable(subscriptionId);
await fam.subscriptions.cancel(subscriptionId);
```

### Portal

```dart
// Create a portal session for user self-service
final session = await fam.portal.createSession(
  CreatePortalSessionRequest(
    userId: userId,
    returnUrl: 'https://example.com/account',
    features: [PortalFeature.MANAGE_CARDS, PortalFeature.VIEW_TRANSACTIONS],
  ),
);

// Redirect user to session.url
```

## UI Components

The SDK includes pre-built Flutter widgets for payment collection:

```dart
import 'package:fam_sdk/ui.dart';
```

<details open>
<summary><strong>PaymentSheet</strong></summary>

A ready-to-use modal for collecting card payments:

```dart
final result = await PaymentSheet.show(
  context: context,
  amount: Money(amount: 2500, currency: Currency.EUR),
  onTokenized: (cardData) async {
    // Process payment with cardData
    return true; // Return true on success
  },
  theme: FamTheme(
    primaryColor: Colors.blue,
    borderRadius: 12,
  ),
);

if (result.success) {
  print('Payment completed!');
}
```

</details>

<details>
<summary><strong>CardForm</strong></summary>

A complete card input form:

```dart
CardForm(
  onCardChanged: (cardData) {
    setState(() => _isValid = cardData.isComplete);
  },
  onSubmit: (cardData) async {
    // Handle card submission
  },
  showPostalCode: true,
  theme: FamTheme.light(),
)
```

</details>

<details>
<summary><strong>CardField</strong></summary>

Individual card input fields for custom layouts:

```dart
Column(
  children: [
    CardField(
      type: CardFieldType.number,
      onChanged: (value) => _cardNumber = value,
      decoration: InputDecoration(labelText: 'Card Number'),
    ),
    Row(
      children: [
        Expanded(
          child: CardField(
            type: CardFieldType.expiry,
            onChanged: (value) => _expiry = value,
          ),
        ),
        Expanded(
          child: CardField(
            type: CardFieldType.cvc,
            onChanged: (value) => _cvc = value,
          ),
        ),
      ],
    ),
  ],
)
```

</details>

## Webhooks

Verify and process webhook events securely:

```dart
import 'package:fam_sdk/fam_sdk.dart';

final webhooks = Webhooks(
  config: WebhookHandlerConfig(
    secret: 'whsec_your_webhook_secret',
  ),
);

// In your server handler
void handleWebhook(String payload, String signature) {
  try {
    final event = webhooks.constructEvent(payload, signature);

    if (event is MangopayWebhookEvent) {
      switch (event.type) {
        case MangopayEventType.PAYIN_NORMAL_SUCCEEDED:
          handleSuccessfulPayin(event);
          break;
        case MangopayEventType.PAYIN_NORMAL_FAILED:
          handleFailedPayin(event);
          break;
        case MangopayEventType.KYC_SUCCEEDED:
          handleKycValidation(event);
          break;
        default:
          print('Unhandled event: ${event.type}');
      }
    } else if (event is FamWebhookEvent) {
      switch (event.type) {
        case FamEventType.FAM_SUBSCRIPTION_PAYMENT_SUCCEEDED:
          handleSubscriptionPayment(event);
          break;
        default:
          print('Unhandled FAM event: ${event.type}');
      }
    }
  } on WebhookSignatureException catch (e) {
    print('Invalid webhook signature: $e');
    // Return 400 Bad Request
  }
}
```

## Error Handling

The SDK provides typed exception classes for precise error handling:

```dart
import 'package:fam_sdk/fam_sdk.dart';

try {
  final user = await fam.users.getUser('invalid-id');
} on NotFoundException catch (e) {
  // Resource not found (404)
  print('User not found');
} on AuthenticationException catch (e) {
  // Invalid or expired token (401)
  print('Please re-authenticate');
} on ValidationException catch (e) {
  // Invalid request data (400/422)
  print('Validation errors:');
  for (final error in e.fieldErrors) {
    print('  ${error.field}: ${error.message}');
  }
} on RateLimitException catch (e) {
  // Too many requests (429)
  print('Rate limited. Retry after ${e.retryAfter?.inSeconds}s');
} on NetworkException catch (e) {
  // Connection/timeout errors
  print('Network error: ${e.message}');
} on ApiException catch (e) {
  // Other API errors
  print('API error ${e.statusCode}: ${e.message}');
}
```

## Dart Types

Full type definitions are included for all API operations:

```dart
import 'package:fam_sdk/fam_sdk.dart';

// Users
NaturalUser user;
LegalUser company;
CreateNaturalUserRequest request;
CreateLegalUserRequest legalRequest;

// Payments
Wallet wallet;
Payin payin;
Payout payout;
Transfer transfer;

// Cards
Card card;
CardRegistration registration;

// KYC
KycDocument document;
UboDeclaration declaration;

// Subscriptions
Subscription subscription;

// Common
Money amount;
Currency currency;
Address address;
```

## Development

```bash
# Install dependencies
flutter pub get

# Run tests
flutter test

# Run tests with coverage
flutter test --coverage

# Analyze code
flutter analyze

# Format code
dart format .
```

## Contributing

We welcome contributions! Please see our contributing guidelines:

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Write tests for your changes
4. Ensure all tests pass (`flutter test`)
5. Commit using [Conventional Commits](https://conventionalcommits.org) (`git commit -m 'feat: add amazing feature'`)
6. Push to the branch (`git push origin feature/amazing-feature`)
7. Open a Pull Request

## Security

If you discover a security vulnerability, please send an email to security@globodai.com instead of using the issue tracker.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

<p align="center">
  Made with care by the <a href="https://globodai.com">Globodai</a> team
</p>
