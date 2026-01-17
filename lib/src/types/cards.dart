/// Card types for the FAM SDK.
///
/// Provides types for card registration, validation, and preauthorizations.
library;

import 'common.dart';

/// Supported card types.
enum CardType {
  /// Visa, Mastercard, CB.
  // ignore: constant_identifier_names
  CB_VISA_MASTERCARD,

  /// Diners Club.
  DINERS,

  /// Masterpass.
  MASTERPASS,

  /// Maestro.
  MAESTRO,

  /// Przelewy24.
  P24,

  /// iDEAL.
  IDEAL,

  /// Bancontact.
  BCMC,

  /// Paylib.
  PAYLIB,
}

/// Card registration status.
enum CardRegistrationStatus {
  /// Registration created, awaiting card data.
  CREATED,

  /// Card data received and validated.
  VALIDATED,

  /// Registration failed.
  ERROR,
}

/// Card validity status.
enum CardValidity {
  /// Validity unknown.
  UNKNOWN,

  /// Card is valid.
  VALID,

  /// Card is invalid.
  INVALID,
}

/// Preauthorization status.
enum PreauthorizationStatus {
  /// Preauthorization created.
  CREATED,

  /// Preauthorization succeeded.
  SUCCEEDED,

  /// Preauthorization failed.
  FAILED,
}

/// Preauthorization execution status.
enum PreauthorizationExecutionStatus {
  /// Not yet captured.
  // ignore: constant_identifier_names
  NOT_SPECIFIED,

  /// Waiting for execution.
  WAITING,

  /// Successfully executed.
  SUCCEEDED,

  /// Cancelled by user/merchant.
  CANCELLED,
}

/// Card registration for tokenizing card data.
///
/// Used to securely collect and tokenize card information.
///
/// ```dart
/// final registration = await fam.cardRegistrations.create(
///   CreateCardRegistrationRequest(
///     userId: 'user_123',
///     currency: Currency.EUR,
///     cardType: CardType.CB_VISA_MASTERCARD,
///   ),
/// );
///
/// // Client-side: Post card data to CardRegistrationURL
/// // Then update with the RegistrationData received
/// await fam.cardRegistrations.update(
///   registration.id,
///   UpdateCardRegistrationRequest(registrationData: data),
/// );
/// ```
class CardRegistration {
  /// Creates a card registration.
  const CardRegistration({
    required this.id,
    required this.userId,
    required this.cardType,
    required this.currency,
    required this.status,
    required this.cardRegistrationUrl,
    required this.accessKey,
    required this.preregistrationData,
    this.cardId,
    this.registrationData,
    this.resultCode,
    this.resultMessage,
    this.tag,
    this.creationDate,
  });

  /// Creates a CardRegistration from JSON.
  factory CardRegistration.fromJson(Map<String, Object?> json) =>
      CardRegistration(
        id: json['Id'] as String,
        userId: json['UserId'] as String,
        cardType: CardType.values.byName(json['CardType'] as String),
        currency: Currency.values.byName(json['Currency'] as String),
        status: CardRegistrationStatus.values.byName(json['Status'] as String),
        cardRegistrationUrl: json['CardRegistrationURL'] as String,
        accessKey: json['AccessKey'] as String,
        preregistrationData: json['PreregistrationData'] as String,
        cardId: json['CardId'] as String?,
        registrationData: json['RegistrationData'] as String?,
        resultCode: json['ResultCode'] as String?,
        resultMessage: json['ResultMessage'] as String?,
        tag: json['Tag'] as String?,
        creationDate: json['CreationDate'] as int?,
      );

  /// Registration ID.
  final String id;

  /// User ID.
  final String userId;

  /// Card type.
  final CardType cardType;

  /// Card currency.
  final Currency currency;

  /// Registration status.
  final CardRegistrationStatus status;

  /// URL to post card data to.
  final String cardRegistrationUrl;

  /// Access key for posting card data.
  final String accessKey;

  /// Pre-registration data to include in post.
  final String preregistrationData;

  /// Resulting card ID after validation.
  final String? cardId;

  /// Registration data received after posting card.
  final String? registrationData;

  /// Result code.
  final String? resultCode;

  /// Result message.
  final String? resultMessage;

  /// Custom tag.
  final String? tag;

  /// Creation timestamp.
  final int? creationDate;

  /// Converts to JSON.
  Map<String, Object?> toJson() => {
        'Id': id,
        'UserId': userId,
        'CardType': cardType.name,
        'Currency': currency.name,
        'Status': status.name,
        'CardRegistrationURL': cardRegistrationUrl,
        'AccessKey': accessKey,
        'PreregistrationData': preregistrationData,
        if (cardId != null) 'CardId': cardId,
        if (registrationData != null) 'RegistrationData': registrationData,
        if (resultCode != null) 'ResultCode': resultCode,
        if (resultMessage != null) 'ResultMessage': resultMessage,
        if (tag != null) 'Tag': tag,
        if (creationDate != null) 'CreationDate': creationDate,
      };
}

/// Request to create a card registration.
class CreateCardRegistrationRequest {
  /// Creates a card registration request.
  const CreateCardRegistrationRequest({
    required this.userId,
    required this.currency,
    this.cardType = CardType.CB_VISA_MASTERCARD,
    this.tag,
  });

  /// User ID.
  final String userId;

  /// Card currency.
  final Currency currency;

  /// Card type.
  final CardType cardType;

  /// Custom tag.
  final String? tag;

  /// Converts to JSON.
  Map<String, Object?> toJson() => {
        'UserId': userId,
        'Currency': currency.name,
        'CardType': cardType.name,
        if (tag != null) 'Tag': tag,
      };
}

/// Request to update a card registration.
class UpdateCardRegistrationRequest {
  /// Creates an update request.
  const UpdateCardRegistrationRequest({
    this.registrationData,
    this.tag,
  });

  /// Registration data from card posting.
  final String? registrationData;

  /// Custom tag.
  final String? tag;

  /// Converts to JSON.
  Map<String, Object?> toJson() => {
        if (registrationData != null) 'RegistrationData': registrationData,
        if (tag != null) 'Tag': tag,
      };
}

/// A tokenized card.
///
/// Represents a user's card that can be used for payments.
class Card {
  /// Creates a card.
  const Card({
    required this.id,
    required this.userId,
    required this.expirationDate,
    required this.alias,
    required this.cardType,
    required this.active,
    this.country,
    this.validity,
    this.fingerprint,
    this.cardProvider,
    this.tag,
    this.creationDate,
  });

  /// Creates a Card from JSON.
  factory Card.fromJson(Map<String, Object?> json) => Card(
        id: json['Id'] as String,
        userId: json['UserId'] as String,
        expirationDate: json['ExpirationDate'] as String,
        alias: json['Alias'] as String,
        cardType: CardType.values.byName(json['CardType'] as String),
        active: json['Active'] as bool,
        country: json['Country'] as String?,
        validity: json['Validity'] != null
            ? CardValidity.values.byName(json['Validity'] as String)
            : null,
        fingerprint: json['Fingerprint'] as String?,
        cardProvider: json['CardProvider'] as String?,
        tag: json['Tag'] as String?,
        creationDate: json['CreationDate'] as int?,
      );

  /// Card ID.
  final String id;

  /// Owner user ID.
  final String userId;

  /// Expiration date (MMYY format).
  final String expirationDate;

  /// Masked card number alias.
  final String alias;

  /// Card type.
  final CardType cardType;

  /// Whether card is active.
  final bool active;

  /// Card issuing country.
  final String? country;

  /// Card validity.
  final CardValidity? validity;

  /// Card fingerprint for duplicate detection.
  final String? fingerprint;

  /// Card provider (Visa, Mastercard, etc.).
  final String? cardProvider;

  /// Custom tag.
  final String? tag;

  /// Creation timestamp.
  final int? creationDate;

  /// Whether the card is valid and usable.
  bool get isUsable => active && validity != CardValidity.INVALID;

  /// Converts to JSON.
  Map<String, Object?> toJson() => {
        'Id': id,
        'UserId': userId,
        'ExpirationDate': expirationDate,
        'Alias': alias,
        'CardType': cardType.name,
        'Active': active,
        if (country != null) 'Country': country,
        if (validity != null) 'Validity': validity!.name,
        if (fingerprint != null) 'Fingerprint': fingerprint,
        if (cardProvider != null) 'CardProvider': cardProvider,
        if (tag != null) 'Tag': tag,
        if (creationDate != null) 'CreationDate': creationDate,
      };
}

/// A card preauthorization.
///
/// Reserves funds on a card for later capture.
class Preauthorization {
  /// Creates a preauthorization.
  const Preauthorization({
    required this.id,
    required this.authorId,
    required this.cardId,
    required this.debitedFunds,
    required this.remainingFunds,
    required this.status,
    this.executionStatus,
    this.paymentStatus,
    this.secureModeReturnUrl,
    this.secureModeRedirectUrl,
    this.secureModeNeeded,
    this.secureMode,
    this.expirationDate,
    this.payInId,
    this.authorizationDate,
    this.tag,
    this.creationDate,
    this.resultCode,
    this.resultMessage,
  });

  /// Creates a Preauthorization from JSON.
  factory Preauthorization.fromJson(Map<String, Object?> json) =>
      Preauthorization(
        id: json['Id'] as String,
        authorId: json['AuthorId'] as String,
        cardId: json['CardId'] as String,
        debitedFunds:
            Money.fromJson(json['DebitedFunds'] as Map<String, Object?>),
        remainingFunds:
            Money.fromJson(json['RemainingFunds'] as Map<String, Object?>),
        status:
            PreauthorizationStatus.values.byName(json['Status'] as String),
        executionStatus: json['PaymentStatus'] != null
            ? PreauthorizationExecutionStatus.values
                .byName(json['PaymentStatus'] as String)
            : null,
        paymentStatus: json['PaymentStatus'] as String?,
        secureModeReturnUrl: json['SecureModeReturnURL'] as String?,
        secureModeRedirectUrl: json['SecureModeRedirectURL'] as String?,
        secureModeNeeded: json['SecureModeNeeded'] as bool?,
        secureMode: json['SecureMode'] != null
            ? SecureMode.values.byName(json['SecureMode'] as String)
            : null,
        expirationDate: json['ExpirationDate'] as int?,
        payInId: json['PayInId'] as String?,
        authorizationDate: json['AuthorizationDate'] as int?,
        tag: json['Tag'] as String?,
        creationDate: json['CreationDate'] as int?,
        resultCode: json['ResultCode'] as String?,
        resultMessage: json['ResultMessage'] as String?,
      );

  /// Preauthorization ID.
  final String id;

  /// Author user ID.
  final String authorId;

  /// Card ID.
  final String cardId;

  /// Amount preauthorized.
  final Money debitedFunds;

  /// Remaining amount to capture.
  final Money remainingFunds;

  /// Preauthorization status.
  final PreauthorizationStatus status;

  /// Execution status.
  final PreauthorizationExecutionStatus? executionStatus;

  /// Payment status string.
  final String? paymentStatus;

  /// 3DS return URL.
  final String? secureModeReturnUrl;

  /// 3DS redirect URL.
  final String? secureModeRedirectUrl;

  /// Whether 3DS is needed.
  final bool? secureModeNeeded;

  /// 3DS mode.
  final SecureMode? secureMode;

  /// Expiration date timestamp.
  final int? expirationDate;

  /// Associated pay-in ID (after capture).
  final String? payInId;

  /// Authorization date timestamp.
  final int? authorizationDate;

  /// Custom tag.
  final String? tag;

  /// Creation timestamp.
  final int? creationDate;

  /// Result code.
  final String? resultCode;

  /// Result message.
  final String? resultMessage;

  /// Whether 3DS redirect is required.
  bool get requiresSecureModeRedirect =>
      secureModeNeeded == true && secureModeRedirectUrl != null;

  /// Converts to JSON.
  Map<String, Object?> toJson() => {
        'Id': id,
        'AuthorId': authorId,
        'CardId': cardId,
        'DebitedFunds': debitedFunds.toJson(),
        'RemainingFunds': remainingFunds.toJson(),
        'Status': status.name,
        if (executionStatus != null) 'PaymentStatus': executionStatus!.name,
        if (paymentStatus != null) 'PaymentStatus': paymentStatus,
        if (secureModeReturnUrl != null)
          'SecureModeReturnURL': secureModeReturnUrl,
        if (secureModeRedirectUrl != null)
          'SecureModeRedirectURL': secureModeRedirectUrl,
        if (secureModeNeeded != null) 'SecureModeNeeded': secureModeNeeded,
        if (secureMode != null) 'SecureMode': secureMode!.name,
        if (expirationDate != null) 'ExpirationDate': expirationDate,
        if (payInId != null) 'PayInId': payInId,
        if (authorizationDate != null) 'AuthorizationDate': authorizationDate,
        if (tag != null) 'Tag': tag,
        if (creationDate != null) 'CreationDate': creationDate,
        if (resultCode != null) 'ResultCode': resultCode,
        if (resultMessage != null) 'ResultMessage': resultMessage,
      };
}

/// Request to create a preauthorization.
class CreatePreauthorizationRequest {
  /// Creates a preauthorization request.
  const CreatePreauthorizationRequest({
    required this.authorId,
    required this.cardId,
    required this.debitedFunds,
    required this.secureModeReturnUrl,
    this.secureMode,
    this.browserInfo,
    this.ipAddress,
    this.statementDescriptor,
    this.tag,
  });

  /// Author user ID.
  final String authorId;

  /// Card ID.
  final String cardId;

  /// Amount to preauthorize.
  final Money debitedFunds;

  /// 3DS return URL.
  final String secureModeReturnUrl;

  /// 3DS mode.
  final SecureMode? secureMode;

  /// Browser info for 3DS.
  final BrowserInfo? browserInfo;

  /// Customer IP address.
  final String? ipAddress;

  /// Statement descriptor.
  final String? statementDescriptor;

  /// Custom tag.
  final String? tag;

  /// Converts to JSON.
  Map<String, Object?> toJson() => {
        'AuthorId': authorId,
        'CardId': cardId,
        'DebitedFunds': debitedFunds.toJson(),
        'SecureModeReturnURL': secureModeReturnUrl,
        if (secureMode != null) 'SecureMode': secureMode!.name,
        if (browserInfo != null) 'BrowserInfo': browserInfo!.toJson(),
        if (ipAddress != null) 'IpAddress': ipAddress,
        if (statementDescriptor != null)
          'StatementDescriptor': statementDescriptor,
        if (tag != null) 'Tag': tag,
      };
}
