/// SCA Recipient types for the FAM SDK.
///
/// Provides types for SCA-compliant recipient management.
library;

import 'common.dart';

/// Recipient status.
enum RecipientStatus {
  /// Pending validation.
  PENDING,

  /// Active and ready for transfers.
  ACTIVE,

  /// Cancelled.
  CANCELLED,
}

/// Payout method type.
enum PayoutMethodType {
  /// International bank transfer (SWIFT).
  // ignore: constant_identifier_names
  INTERNATIONAL_BANK_TRANSFER,

  /// Local bank transfer.
  // ignore: constant_identifier_names
  LOCAL_BANK_TRANSFER,
}

/// Recipient type.
enum RecipientType {
  /// Individual recipient.
  INDIVIDUAL,

  /// Business recipient.
  BUSINESS,
}

/// Individual recipient details.
class IndividualRecipient {
  /// Creates an individual recipient.
  const IndividualRecipient({
    required this.firstName,
    required this.lastName,
  });

  /// Creates from JSON.
  factory IndividualRecipient.fromJson(Map<String, Object?> json) =>
      IndividualRecipient(
        firstName: json['FirstName'] as String,
        lastName: json['LastName'] as String,
      );

  /// First name.
  final String firstName;

  /// Last name.
  final String lastName;

  /// Full name.
  String get fullName => '$firstName $lastName';

  /// Converts to JSON.
  Map<String, Object?> toJson() => {
        'FirstName': firstName,
        'LastName': lastName,
      };
}

/// Business recipient details.
class BusinessRecipient {
  /// Creates a business recipient.
  const BusinessRecipient({
    required this.businessName,
  });

  /// Creates from JSON.
  factory BusinessRecipient.fromJson(Map<String, Object?> json) =>
      BusinessRecipient(
        businessName: json['BusinessName'] as String,
      );

  /// Business name.
  final String businessName;

  /// Converts to JSON.
  Map<String, Object?> toJson() => {
        'BusinessName': businessName,
      };
}

/// Local bank transfer details.
class LocalBankTransfer {
  /// Creates local bank transfer details.
  const LocalBankTransfer({
    required this.accountNumber,
    this.sortCode,
    this.aba,
  });

  /// Creates from JSON.
  factory LocalBankTransfer.fromJson(Map<String, Object?> json) =>
      LocalBankTransfer(
        accountNumber: json['AccountNumber'] as String,
        sortCode: json['SortCode'] as String?,
        aba: json['ABA'] as String?,
      );

  /// Account number.
  final String accountNumber;

  /// Sort code (UK).
  final String? sortCode;

  /// ABA routing number (US).
  final String? aba;

  /// Converts to JSON.
  Map<String, Object?> toJson() => {
        'AccountNumber': accountNumber,
        if (sortCode != null) 'SortCode': sortCode,
        if (aba != null) 'ABA': aba,
      };
}

/// International bank transfer details.
class InternationalBankTransfer {
  /// Creates international bank transfer details.
  const InternationalBankTransfer({
    this.iban,
    this.bic,
    this.accountNumber,
  });

  /// Creates from JSON.
  factory InternationalBankTransfer.fromJson(Map<String, Object?> json) =>
      InternationalBankTransfer(
        iban: json['IBAN'] as String?,
        bic: json['BIC'] as String?,
        accountNumber: json['AccountNumber'] as String?,
      );

  /// IBAN number.
  final String? iban;

  /// BIC/SWIFT code.
  final String? bic;

  /// Account number.
  final String? accountNumber;

  /// Converts to JSON.
  Map<String, Object?> toJson() => {
        if (iban != null) 'IBAN': iban,
        if (bic != null) 'BIC': bic,
        if (accountNumber != null) 'AccountNumber': accountNumber,
      };
}

/// An SCA-compliant transfer recipient.
///
/// Used for transfers that require Strong Customer Authentication.
///
/// ```dart
/// final recipientsModule = fam.scaRecipients('user_123');
///
/// final recipient = await recipientsModule.create(
///   CreateRecipientRequest(
///     displayName: 'My Bank Account',
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
class Recipient {
  /// Creates a recipient.
  const Recipient({
    required this.id,
    required this.displayName,
    required this.payoutMethodType,
    required this.recipientType,
    required this.currency,
    required this.country,
    required this.status,
    this.individualRecipient,
    this.businessRecipient,
    this.localBankTransfer,
    this.internationalBankTransfer,
    this.tag,
    this.creationDate,
  });

  /// Creates a Recipient from JSON.
  factory Recipient.fromJson(Map<String, Object?> json) => Recipient(
        id: json['Id'] as String,
        displayName: json['DisplayName'] as String,
        payoutMethodType: PayoutMethodType.values
            .byName(json['PayoutMethodType'] as String),
        recipientType:
            RecipientType.values.byName(json['RecipientType'] as String),
        currency: Currency.values.byName(json['Currency'] as String),
        country: json['Country'] as String,
        status: RecipientStatus.values.byName(json['Status'] as String),
        individualRecipient: json['IndividualRecipient'] != null
            ? IndividualRecipient.fromJson(
                json['IndividualRecipient'] as Map<String, Object?>,
              )
            : null,
        businessRecipient: json['BusinessRecipient'] != null
            ? BusinessRecipient.fromJson(
                json['BusinessRecipient'] as Map<String, Object?>,
              )
            : null,
        localBankTransfer: json['LocalBankTransfer'] != null
            ? LocalBankTransfer.fromJson(
                json['LocalBankTransfer'] as Map<String, Object?>,
              )
            : null,
        internationalBankTransfer: json['InternationalBankTransfer'] != null
            ? InternationalBankTransfer.fromJson(
                json['InternationalBankTransfer'] as Map<String, Object?>,
              )
            : null,
        tag: json['Tag'] as String?,
        creationDate: json['CreationDate'] as int?,
      );

  /// Recipient ID.
  final String id;

  /// Display name.
  final String displayName;

  /// Payout method type.
  final PayoutMethodType payoutMethodType;

  /// Recipient type.
  final RecipientType recipientType;

  /// Currency.
  final Currency currency;

  /// Country.
  final String country;

  /// Status.
  final RecipientStatus status;

  /// Individual recipient details.
  final IndividualRecipient? individualRecipient;

  /// Business recipient details.
  final BusinessRecipient? businessRecipient;

  /// Local bank transfer details.
  final LocalBankTransfer? localBankTransfer;

  /// International bank transfer details.
  final InternationalBankTransfer? internationalBankTransfer;

  /// Custom tag.
  final String? tag;

  /// Creation timestamp.
  final int? creationDate;

  /// Whether the recipient is active.
  bool get isActive => status == RecipientStatus.ACTIVE;

  /// Converts to JSON.
  Map<String, Object?> toJson() => {
        'Id': id,
        'DisplayName': displayName,
        'PayoutMethodType': payoutMethodType.name,
        'RecipientType': recipientType.name,
        'Currency': currency.name,
        'Country': country,
        'Status': status.name,
        if (individualRecipient != null)
          'IndividualRecipient': individualRecipient!.toJson(),
        if (businessRecipient != null)
          'BusinessRecipient': businessRecipient!.toJson(),
        if (localBankTransfer != null)
          'LocalBankTransfer': localBankTransfer!.toJson(),
        if (internationalBankTransfer != null)
          'InternationalBankTransfer': internationalBankTransfer!.toJson(),
        if (tag != null) 'Tag': tag,
        if (creationDate != null) 'CreationDate': creationDate,
      };
}

/// Request to create a recipient.
class CreateRecipientRequest {
  /// Creates a recipient request.
  const CreateRecipientRequest({
    required this.displayName,
    required this.payoutMethodType,
    required this.recipientType,
    required this.currency,
    required this.country,
    this.individualRecipient,
    this.businessRecipient,
    this.localBankTransfer,
    this.internationalBankTransfer,
    this.tag,
  });

  /// Display name.
  final String displayName;

  /// Payout method type.
  final PayoutMethodType payoutMethodType;

  /// Recipient type.
  final RecipientType recipientType;

  /// Currency.
  final Currency currency;

  /// Country.
  final String country;

  /// Individual recipient details.
  final IndividualRecipient? individualRecipient;

  /// Business recipient details.
  final BusinessRecipient? businessRecipient;

  /// Local bank transfer details.
  final LocalBankTransfer? localBankTransfer;

  /// International bank transfer details.
  final InternationalBankTransfer? internationalBankTransfer;

  /// Custom tag.
  final String? tag;

  /// Converts to JSON.
  Map<String, Object?> toJson() => {
        'DisplayName': displayName,
        'PayoutMethodType': payoutMethodType.name,
        'RecipientType': recipientType.name,
        'Currency': currency.name,
        'Country': country,
        if (individualRecipient != null)
          'IndividualRecipient': individualRecipient!.toJson(),
        if (businessRecipient != null)
          'BusinessRecipient': businessRecipient!.toJson(),
        if (localBankTransfer != null)
          'LocalBankTransfer': localBankTransfer!.toJson(),
        if (internationalBankTransfer != null)
          'InternationalBankTransfer': internationalBankTransfer!.toJson(),
        if (tag != null) 'Tag': tag,
      };
}

/// Request to get recipient schema.
class RecipientSchemaRequest {
  /// Creates a schema request.
  const RecipientSchemaRequest({
    required this.payoutMethodType,
    required this.recipientType,
    required this.currency,
    required this.country,
  });

  /// Payout method type.
  final PayoutMethodType payoutMethodType;

  /// Recipient type.
  final RecipientType recipientType;

  /// Currency.
  final Currency currency;

  /// Country.
  final String country;

  /// Converts to query params.
  Map<String, String> toQueryParams() => {
        'PayoutMethodType': payoutMethodType.name,
        'RecipientType': recipientType.name,
        'Currency': currency.name,
        'Country': country,
      };
}

/// Recipient schema (fields required for a specific configuration).
class RecipientSchema {
  /// Creates a recipient schema.
  const RecipientSchema({
    required this.fields,
  });

  /// Creates from JSON.
  factory RecipientSchema.fromJson(Map<String, Object?> json) => RecipientSchema(
        fields: (json['Fields'] as List<Object?>? ?? [])
            .cast<Map<String, Object?>>()
            .map(RecipientSchemaField.fromJson)
            .toList(growable: false),
      );

  /// Required fields.
  final List<RecipientSchemaField> fields;
}

/// A field in a recipient schema.
class RecipientSchemaField {
  /// Creates a schema field.
  const RecipientSchemaField({
    required this.name,
    required this.type,
    this.required,
    this.label,
    this.description,
    this.pattern,
    this.minLength,
    this.maxLength,
  });

  /// Creates from JSON.
  factory RecipientSchemaField.fromJson(Map<String, Object?> json) =>
      RecipientSchemaField(
        name: json['Name'] as String,
        type: json['Type'] as String,
        required: json['Required'] as bool?,
        label: json['Label'] as String?,
        description: json['Description'] as String?,
        pattern: json['Pattern'] as String?,
        minLength: json['MinLength'] as int?,
        maxLength: json['MaxLength'] as int?,
      );

  /// Field name.
  final String name;

  /// Field type.
  final String type;

  /// Whether field is required.
  final bool? required;

  /// Display label.
  final String? label;

  /// Description.
  final String? description;

  /// Validation pattern (regex).
  final String? pattern;

  /// Minimum length.
  final int? minLength;

  /// Maximum length.
  final int? maxLength;
}
