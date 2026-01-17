/// Example usage of the FAM SDK.
///
/// This example demonstrates the basic usage of the FAM SDK
/// for payment and subscription integrations.
library;

import 'package:fam_sdk/fam_sdk.dart';

void main() async {
  // Initialize the SDK
  final fam = Fam(
    apiKey: 'your_api_key_here',
    options: FamOptions(
      baseUrl: 'https://api.fam.example.com',
      timeout: Duration(seconds: 30),
      maxRetries: 3,
    ),
  );

  // Example: Create a natural user
  await createUser(fam);

  // Example: Create a wallet
  await createWallet(fam);

  // Example: Process a payment
  await processPayment(fam);

  // Example: Handle webhooks
  handleWebhooks();
}

/// Creates a natural (individual) user.
Future<void> createUser(Fam fam) async {
  try {
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

    print('User created: ${user.id}');
    print('Email: ${user.email}');
  } on ValidationException catch (e) {
    print('Validation error: ${e.message}');
    for (final error in e.fieldErrors) {
      print('  - ${error.field}: ${error.message}');
    }
  } on ApiException catch (e) {
    print('API error: ${e.message} (${e.statusCode})');
  }
}

/// Creates a wallet for a user.
Future<void> createWallet(Fam fam) async {
  try {
    final wallet = await fam.wallets.create(
      CreateWalletRequest(
        owners: ['user_123'],
        description: 'Main EUR Wallet',
        currency: Currency.EUR,
      ),
    );

    print('Wallet created: ${wallet.id}');
    print('Balance: ${wallet.balance.formatted}');
  } on FamException catch (e) {
    print('Error: $e');
  }
}

/// Processes a card payment.
Future<void> processPayment(Fam fam) async {
  try {
    final payin = await fam.payins.create(
      CreateCardDirectPayinRequest(
        authorId: 'user_123',
        creditedWalletId: 'wallet_456',
        debitedFunds: Money(amount: 5000, currency: Currency.EUR), // 50.00 EUR
        fees: Money(amount: 100, currency: Currency.EUR), // 1.00 EUR
        cardId: 'card_789',
        secureModeReturnUrl: 'https://example.com/payment/callback',
        statementDescriptor: 'ACME Store',
      ),
    );

    print('Payment created: ${payin.id}');
    print('Status: ${payin.status}');

    // Check if 3DS authentication is required
    if (payin.secureModeNeeded == true && payin.secureModeRedirectUrl != null) {
      print('3DS required - redirect to: ${payin.secureModeRedirectUrl}');
    }
  } on FamException catch (e) {
    print('Payment error: $e');
  }
}

/// Handles incoming webhooks.
void handleWebhooks() {
  // Configure webhook handler with your secret
  final webhooks = Webhooks(
    config: WebhookHandlerConfig(
      secret: 'whsec_your_webhook_secret',
      tolerance: Duration(minutes: 5),
    ),
  );

  // Example webhook payload (would come from HTTP request)
  const payload = '''
  {
    "EventType": "PAYIN_NORMAL_SUCCEEDED",
    "ResourceId": "pay_123456",
    "Id": "evt_789",
    "Date": 1704067200
  }
  ''';
  const signature = 'abc123...'; // From X-Webhook-Signature header

  try {
    // Verify signature and parse event
    final event = webhooks.constructEvent(payload, signature);

    if (event is MangopayWebhookEvent) {
      switch (event.type) {
        case MangopayEventType.PAYIN_NORMAL_SUCCEEDED:
          print('Payment succeeded: ${event.resourceId}');
        case MangopayEventType.PAYIN_NORMAL_FAILED:
          print('Payment failed: ${event.resourceId}');
        default:
          print('Received event: ${event.type}');
      }
    } else if (event is FamWebhookEvent) {
      switch (event.type) {
        case FamEventType.FAM_SUBSCRIPTION_CREATED:
          print('Subscription created: ${event.resourceId}');
        default:
          print('Received FAM event: ${event.type}');
      }
    }
  } on WebhookSignatureException catch (e) {
    print('Invalid webhook signature: $e');
  }
}
