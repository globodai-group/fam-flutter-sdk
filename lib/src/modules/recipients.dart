/// Recipients module for the FAM SDK.
///
/// Provides methods for SCA-compliant recipient management.
library;

import 'package:fam_sdk/src/client.dart';
import 'package:fam_sdk/src/modules/base.dart';
import 'package:fam_sdk/src/types/types.dart';

/// Module for SCA recipient operations (user-scoped).
///
/// Recipients are used for transfers that require Strong Customer Authentication.
///
/// ```dart
/// // Get the recipients module for a user
/// final recipients = fam.scaRecipients('user_123');
///
/// // Get the schema for required fields
/// final schema = await recipients.getSchema(
///   RecipientSchemaRequest(
///     payoutMethodType: PayoutMethodType.INTERNATIONAL_BANK_TRANSFER,
///     recipientType: RecipientType.INDIVIDUAL,
///     currency: Currency.EUR,
///     country: 'FR',
///   ),
/// );
///
/// // Create a recipient
/// final recipient = await recipients.create(
///   CreateRecipientRequest(
///     displayName: 'My French Account',
///     payoutMethodType: PayoutMethodType.INTERNATIONAL_BANK_TRANSFER,
///     recipientType: RecipientType.INDIVIDUAL,
///     currency: Currency.EUR,
///     country: 'FR',
///     individualRecipient: IndividualRecipient(
///       firstName: 'John',
///       lastName: 'Doe',
///     ),
///     internationalBankTransfer: InternationalBankTransfer(
///       iban: 'FR7630006000011234567890189',
///       bic: 'BNPAFRPP',
///     ),
///   ),
/// );
/// ```
class ScaRecipientsModule extends UserScopedModule {
  /// Creates an SCA recipients module for a specific user.
  ScaRecipientsModule(HttpClient client, String userId)
      : super(client, '/api/v1/mangopay/users/$userId/recipients', userId);

  /// Creates a new recipient.
  Future<Recipient> create(CreateRecipientRequest data) => post(
        '',
        body: data.toJson(),
        fromJson: (json) => Recipient.fromJson(json! as Map<String, Object?>),
      );

  /// Gets a recipient by ID.
  Future<Recipient> getRecipient(String recipientId) => get(
        '/$recipientId',
        fromJson: (json) => Recipient.fromJson(json! as Map<String, Object?>),
      );

  /// Lists all recipients for the user.
  Future<PaginatedResponse<Recipient>> list({PaginationParams? params}) => get(
        '',
        options: RequestOptions(params: params?.toQueryParams()),
        fromJson: (json) => PaginatedResponse.fromJson(
          json! as Map<String, Object?>,
          Recipient.fromJson,
        ),
      );

  /// Gets the schema for a specific recipient configuration.
  ///
  /// Returns the required fields based on the payout method,
  /// recipient type, currency, and country.
  Future<RecipientSchema> getSchema(RecipientSchemaRequest request) => get(
        '/schema',
        options: RequestOptions(params: request.toQueryParams()),
        fromJson: (json) =>
            RecipientSchema.fromJson(json! as Map<String, Object?>),
      );
}
