# FAM SDK for Flutter

A native Flutter SDK for FAM API integrations including payments, subscriptions, and user management. Built with zero third-party dependencies (except `crypto` for webhook signature verification).

## Features

- **Users**: Create and manage natural (individual) and legal (company) users
- **Wallets**: Manage e-wallets and view transactions
- **Pay-ins**: Process card payments and recurring payments
- **Pay-outs**: Withdraw funds to bank accounts
- **Transfers**: Transfer funds between wallets
- **Cards**: Card tokenization and management
- **Bank Accounts**: IBAN, GB, US, CA, and other bank account types
- **KYC**: Document submission and verification
- **UBO**: Ultimate beneficial owner declarations
- **Subscriptions**: Recurring subscription management
- **Portal**: Customer portal sessions
- **Webhooks**: Secure webhook handling with HMAC-SHA256 signature verification
- **UI Components**: Pre-built payment widgets (PaymentSheet, CardForm, CardField)

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  fam_sdk:
    git:
      url: https://github.com/globodai-group/fam-flutter-sdk.git
      ref: main
```

Then run:

```bash
flutter pub get
```

## Quick Start

### Initialize the SDK

```dart
import 'package:fam_sdk/fam_sdk.dart';

final fam = Fam(
  FamOptions(
    baseUrl: 'https://api.fam.example.com',
    token: 'your-api-token',
  ),
);
```

### Create a User

```dart
// Create a natural (individual) user
final user = await fam.users.createNatural(
  CreateNaturalUserRequest(
    firstName: 'John',
    lastName: 'Doe',
    email: 'john@example.com',
    birthday: 631152000, // Unix timestamp
    nationality: 'FR',
    countryOfResidence: 'FR',
  ),
);

print('User created: ${user.id}');
```

### Create a Wallet

```dart
final wallet = await fam.wallets.create(
  CreateWalletRequest(
    owners: [user.id],
    description: 'Main Wallet',
    currency: Currency.EUR,
  ),
);

print('Wallet balance: ${wallet.balance.format()}');
```

### Process a Card Payment

```dart
// 1. Create a card registration
final registration = await fam.cardRegistrations.create(
  CreateCardRegistrationRequest(
    userId: user.id,
    currency: Currency.EUR,
  ),
);

// 2. Tokenize card data (via your secure form)
// The card data should be sent directly to the CardRegistrationURL

// 3. Update registration with tokenized data
final updatedRegistration = await fam.cardRegistrations.update(
  registration.id,
  UpdateCardRegistrationRequest(
    registrationData: 'tokenized_data_from_form',
  ),
);

// 4. Create a pay-in
final payin = await fam.payins.createCardDirect(
  CreateCardDirectPayinRequest(
    authorId: user.id,
    creditedWalletId: wallet.id,
    debitedFunds: Money(amount: 1000, currency: Currency.EUR),
    fees: Money(amount: 0, currency: Currency.EUR),
    cardId: updatedRegistration.cardId!,
    secureModeReturnURL: 'https://your-app.com/payment-return',
  ),
);

if (payin.status == TransactionStatus.SUCCEEDED) {
  print('Payment successful!');
}
```

### Clean Up

```dart
fam.close();
```

## UI Components

The SDK includes pre-built UI components for payment flows.

### Setup Theme

```dart
import 'package:fam_sdk/ui.dart';

MaterialApp(
  home: FamThemeProvider(
    theme: FamTheme(
      primaryColor: Colors.indigo,
      errorColor: Colors.red,
      borderRadius: BorderRadius.circular(12),
    ),
    child: MyApp(),
  ),
);
```

### PaymentSheet

Display a complete payment flow:

```dart
await FamPaymentSheet.show(
  context: context,
  config: PaymentSheetConfig(
    walletId: wallet.id,
    amount: 1000, // in cents
    currency: Currency.EUR,
    title: 'Complete Purchase',
    description: 'Premium Subscription',
  ),
  onComplete: (result) {
    if (result.status == PaymentStatus.succeeded) {
      print('Payment successful: ${result.payinId}');
    } else if (result.status == PaymentStatus.failed) {
      print('Payment failed: ${result.error}');
    }
  },
);
```

### CardForm

Use individual card form components:

```dart
CardForm(
  onCardChanged: (details) {
    if (details.complete) {
      print('Card valid: ${details.brand}');
    }
  },
);
```

### CardField

Single-line card input:

```dart
CardField(
  onCardChanged: (details) {
    print('Card number valid: ${details.complete}');
  },
);
```

## Error Handling

All SDK errors extend `FamException`:

```dart
try {
  await fam.users.getUser('user_123');
} on AuthenticationException catch (e) {
  // 401 - Invalid or expired token
  print('Authentication failed: ${e.message}');
} on AuthorizationException catch (e) {
  // 403 - Access denied
  print('Authorization failed: ${e.message}');
} on NotFoundException catch (e) {
  // 404 - Resource not found
  print('Not found: ${e.message}');
} on ValidationException catch (e) {
  // 400/422 - Validation errors
  print('Validation failed: ${e.message}');
  for (final entry in e.errors.entries) {
    print('  ${entry.key}: ${entry.value.join(', ')}');
  }
} on RateLimitException catch (e) {
  // 429 - Rate limited
  print('Rate limited. Retry after ${e.retryAfter} seconds');
} on NetworkException catch (e) {
  // Connection issues
  print('Network error: ${e.message}');
} on TimeoutException catch (e) {
  // Request timeout
  print('Timeout: ${e.message}');
} on FamException catch (e) {
  // Any other SDK error
  print('Error: ${e.message}');
}
```

## Webhooks

Handle incoming webhooks with signature verification:

```dart
final webhooks = Webhooks(
  config: WebhookHandlerConfig(
    secret: 'whsec_your_webhook_secret',
    tolerance: Duration(minutes: 5), // Reject old events
  ),
);

// In your webhook handler
void handleWebhook(String rawBody, String signature) {
  try {
    final event = webhooks.constructEvent(rawBody, signature);

    if (event is MangopayWebhookEvent) {
      switch (event.type) {
        case MangopayEventType.PAYIN_NORMAL_SUCCEEDED:
          handlePayinSuccess(event.resourceId);
          break;
        case MangopayEventType.PAYIN_NORMAL_FAILED:
          handlePayinFailure(event.resourceId);
          break;
        case MangopayEventType.KYC_SUCCEEDED:
          handleKycSuccess(event.resourceId);
          break;
        // ... handle other events
      }
    } else if (event is FamWebhookEvent) {
      switch (event.type) {
        case FamEventType.FAM_SUBSCRIPTION_PAYMENT_SUCCEEDED:
          handleSubscriptionPayment(event.resourceId);
          break;
        case FamEventType.FAM_SUBSCRIPTION_CANCELLED:
          handleSubscriptionCancelled(event.resourceId);
          break;
        // ... handle other events
      }
    }
  } on WebhookSignatureException catch (e) {
    // Invalid signature - reject the webhook
    print('Invalid webhook: ${e.message}');
  }
}
```

## API Reference

### Modules

| Module | Description |
|--------|-------------|
| `fam.users` | User management (natural and legal) |
| `fam.wallets` | Wallet operations and transactions |
| `fam.payins` | Card payments and recurring payments |
| `fam.payouts` | Bank wire withdrawals |
| `fam.transfers` | Wallet-to-wallet transfers |
| `fam.cardRegistrations` | Card tokenization |
| `fam.cards` | Card management |
| `fam.preauthorizations` | Hold funds on cards |
| `fam.subscriptions` | Recurring subscriptions |
| `fam.portal` | Customer portal sessions |

### User-Scoped Modules

These modules require a user ID:

```dart
// Bank accounts for a specific user
final bankAccounts = fam.bankAccounts('user_123');
await bankAccounts.createIban(...);

// KYC documents for a specific user
final kyc = fam.kyc('user_123');
await kyc.create(...);

// UBO declarations for a legal user
final ubo = fam.ubo('legal_user_123');
await ubo.createDeclaration();

// SCA recipients for a user
final recipients = fam.scaRecipients('user_123');
await recipients.create(...);
```

### Token Management

```dart
// Update the authentication token
fam.setToken('new-token');

// Clear the token (for logout)
fam.clearToken();
```

### Request Options

Customize individual requests:

```dart
final user = await fam.users.getUser(
  'user_123',
  options: RequestOptions(
    timeout: Duration(seconds: 30),
    headers: {'X-Custom-Header': 'value'},
  ),
);
```

## Configuration Options

```dart
final fam = Fam(
  FamOptions(
    baseUrl: 'https://api.fam.example.com',
    token: 'your-api-token',
    timeout: Duration(seconds: 30),      // Default request timeout
    maxRetries: 3,                        // Retry count for failed requests
    retryDelay: Duration(seconds: 1),    // Initial retry delay
    headers: {'X-Client-Version': '1.0'}, // Custom headers
  ),
);
```

## Supported Currencies

The SDK supports the following currencies:

- EUR (Euro)
- USD (US Dollar)
- GBP (British Pound)
- CHF (Swiss Franc)
- CAD (Canadian Dollar)
- AUD (Australian Dollar)
- JPY (Japanese Yen)
- PLN (Polish Zloty)
- SEK (Swedish Krona)
- NOK (Norwegian Krone)
- DKK (Danish Krone)

## Requirements

- Flutter SDK 3.16.0 or higher
- Dart SDK 3.0.0 or higher

## Dependencies

- `crypto: ^3.0.3` - For webhook HMAC-SHA256 signature verification

## License

MIT License - see [LICENSE](LICENSE) for details.

## Contributing

Contributions are welcome! Please read our contributing guidelines before submitting a pull request.

## Support

For issues and feature requests, please use the [GitHub Issues](https://github.com/globodai-group/fam-flutter-sdk/issues) page.
