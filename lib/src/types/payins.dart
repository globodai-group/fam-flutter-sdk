/// PayIn types for the FAM SDK.
///
/// Provides types for card payments, recurring payments, and refunds.
library;

import 'common.dart';

/// Payment method type for pay-ins.
enum PayinType {
  /// Card payment.
  CARD,

  /// Preauthorized payment.
  PREAUTHORIZED,

  /// Bank wire transfer.
  // ignore: constant_identifier_names
  BANK_WIRE,

  /// Direct debit.
  // ignore: constant_identifier_names
  DIRECT_DEBIT,

  /// PayPal payment.
  PAYPAL,
}

/// A pay-in transaction (receiving funds).
///
/// Represents money received into a wallet from an external source.
///
/// ```dart
/// final payin = await fam.payins.create(
///   CreateCardDirectPayinRequest(
///     authorId: 'user_123',
///     creditedWalletId: 'wallet_456',
///     debitedFunds: Money(amount: 1000, currency: Currency.EUR),
///     fees: Money(amount: 50, currency: Currency.EUR),
///     cardId: 'card_789',
///     secureModeReturnUrl: 'https://example.com/callback',
///   ),
/// );
/// ```
class Payin {
  /// Creates a pay-in.
  const Payin({
    required this.id,
    required this.authorId,
    required this.creditedWalletId,
    required this.debitedFunds,
    required this.creditedFunds,
    required this.fees,
    required this.status,
    required this.type,
    required this.nature,
    this.creditedUserId,
    this.paymentType,
    this.executionType,
    this.secureMode,
    this.secureModeReturnUrl,
    this.secureModeRedirectUrl,
    this.secureModeNeeded,
    this.cardId,
    this.statementDescriptor,
    this.tag,
    this.creationDate,
    this.executionDate,
    this.resultCode,
    this.resultMessage,
  });

  /// Creates a Payin from JSON.
  factory Payin.fromJson(Map<String, Object?> json) => Payin(
        id: json['Id'] as String,
        authorId: json['AuthorId'] as String,
        creditedWalletId: json['CreditedWalletId'] as String,
        debitedFunds:
            Money.fromJson(json['DebitedFunds'] as Map<String, Object?>),
        creditedFunds:
            Money.fromJson(json['CreditedFunds'] as Map<String, Object?>),
        fees: Money.fromJson(json['Fees'] as Map<String, Object?>),
        status: TransactionStatus.values.byName(json['Status'] as String),
        type: json['Type'] != null
            ? PayinType.values.byName(json['Type'] as String)
            : PayinType.CARD,
        nature: TransactionNature.values.byName(json['Nature'] as String),
        creditedUserId: json['CreditedUserId'] as String?,
        paymentType: json['PaymentType'] as String?,
        executionType: json['ExecutionType'] != null
            ? ExecutionType.values.byName(json['ExecutionType'] as String)
            : null,
        secureMode: json['SecureMode'] != null
            ? SecureMode.values.byName(json['SecureMode'] as String)
            : null,
        secureModeReturnUrl: json['SecureModeReturnURL'] as String?,
        secureModeRedirectUrl: json['SecureModeRedirectURL'] as String?,
        secureModeNeeded: json['SecureModeNeeded'] as bool?,
        cardId: json['CardId'] as String?,
        statementDescriptor: json['StatementDescriptor'] as String?,
        tag: json['Tag'] as String?,
        creationDate: json['CreationDate'] as int?,
        executionDate: json['ExecutionDate'] as int?,
        resultCode: json['ResultCode'] as String?,
        resultMessage: json['ResultMessage'] as String?,
      );

  /// Unique pay-in identifier.
  final String id;

  /// ID of the user initiating payment.
  final String authorId;

  /// ID of the credited wallet.
  final String creditedWalletId;

  /// Amount debited from payment source.
  final Money debitedFunds;

  /// Amount credited to wallet.
  final Money creditedFunds;

  /// Fees charged.
  final Money fees;

  /// Transaction status.
  final TransactionStatus status;

  /// Pay-in type.
  final PayinType type;

  /// Transaction nature.
  final TransactionNature nature;

  /// ID of the credited user.
  final String? creditedUserId;

  /// Payment method type string.
  final String? paymentType;

  /// Execution type.
  final ExecutionType? executionType;

  /// 3D Secure mode.
  final SecureMode? secureMode;

  /// Return URL after 3DS authentication.
  final String? secureModeReturnUrl;

  /// Redirect URL for 3DS authentication.
  final String? secureModeRedirectUrl;

  /// Whether 3DS is required.
  final bool? secureModeNeeded;

  /// ID of the card used.
  final String? cardId;

  /// Statement descriptor.
  final String? statementDescriptor;

  /// Custom tag.
  final String? tag;

  /// Creation timestamp.
  final int? creationDate;

  /// Execution timestamp.
  final int? executionDate;

  /// Result code.
  final String? resultCode;

  /// Result message.
  final String? resultMessage;

  /// Whether 3DS redirect is required.
  bool get requiresSecureModeRedirect =>
      secureModeNeeded == true && secureModeRedirectUrl != null;

  /// Converts to JSON map.
  Map<String, Object?> toJson() => {
        'Id': id,
        'AuthorId': authorId,
        'CreditedWalletId': creditedWalletId,
        'DebitedFunds': debitedFunds.toJson(),
        'CreditedFunds': creditedFunds.toJson(),
        'Fees': fees.toJson(),
        'Status': status.name,
        'Type': type.name,
        'Nature': nature.name,
        if (creditedUserId != null) 'CreditedUserId': creditedUserId,
        if (paymentType != null) 'PaymentType': paymentType,
        if (executionType != null) 'ExecutionType': executionType!.name,
        if (secureMode != null) 'SecureMode': secureMode!.name,
        if (secureModeReturnUrl != null)
          'SecureModeReturnURL': secureModeReturnUrl,
        if (secureModeRedirectUrl != null)
          'SecureModeRedirectURL': secureModeRedirectUrl,
        if (secureModeNeeded != null) 'SecureModeNeeded': secureModeNeeded,
        if (cardId != null) 'CardId': cardId,
        if (statementDescriptor != null)
          'StatementDescriptor': statementDescriptor,
        if (tag != null) 'Tag': tag,
        if (creationDate != null) 'CreationDate': creationDate,
        if (executionDate != null) 'ExecutionDate': executionDate,
        if (resultCode != null) 'ResultCode': resultCode,
        if (resultMessage != null) 'ResultMessage': resultMessage,
      };
}

/// Request to create a direct card pay-in.
class CreateCardDirectPayinRequest {
  /// Creates a card direct pay-in request.
  const CreateCardDirectPayinRequest({
    required this.authorId,
    required this.creditedWalletId,
    required this.debitedFunds,
    required this.fees,
    required this.cardId,
    required this.secureModeReturnUrl,
    this.creditedUserId,
    this.secureMode,
    this.statementDescriptor,
    this.browserInfo,
    this.ipAddress,
    this.tag,
  });

  /// ID of the user making payment.
  final String authorId;

  /// ID of the wallet to credit.
  final String creditedWalletId;

  /// Amount to debit.
  final Money debitedFunds;

  /// Fees to charge.
  final Money fees;

  /// ID of the card to charge.
  final String cardId;

  /// Return URL after 3DS.
  final String secureModeReturnUrl;

  /// ID of the user to credit.
  final String? creditedUserId;

  /// 3D Secure mode.
  final SecureMode? secureMode;

  /// Statement descriptor.
  final String? statementDescriptor;

  /// Browser info for 3DS.
  final BrowserInfo? browserInfo;

  /// Customer IP address.
  final String? ipAddress;

  /// Custom tag.
  final String? tag;

  /// Converts to JSON map.
  Map<String, Object?> toJson() => {
        'AuthorId': authorId,
        'CreditedWalletId': creditedWalletId,
        'DebitedFunds': debitedFunds.toJson(),
        'Fees': fees.toJson(),
        'CardId': cardId,
        'SecureModeReturnURL': secureModeReturnUrl,
        if (creditedUserId != null) 'CreditedUserId': creditedUserId,
        if (secureMode != null) 'SecureMode': secureMode!.name,
        if (statementDescriptor != null)
          'StatementDescriptor': statementDescriptor,
        if (browserInfo != null) 'BrowserInfo': browserInfo!.toJson(),
        if (ipAddress != null) 'IpAddress': ipAddress,
        if (tag != null) 'Tag': tag,
      };
}

/// Recurring payment registration.
///
/// Used to set up recurring card payments.
class RecurringPaymentRegistration {
  /// Creates a recurring payment registration.
  const RecurringPaymentRegistration({
    required this.id,
    required this.authorId,
    required this.cardId,
    required this.creditedWalletId,
    required this.status,
    this.currentState,
    this.firstTransactionDebitedFunds,
    this.firstTransactionFees,
    this.nextTransactionDebitedFunds,
    this.nextTransactionFees,
    this.endDate,
    this.frequency,
    this.fixedNextAmount,
    this.fractionedPayment,
    this.migration,
    this.totalAmount,
    this.cycleNumber,
    this.tag,
    this.creationDate,
  });

  /// Creates from JSON.
  factory RecurringPaymentRegistration.fromJson(Map<String, Object?> json) =>
      RecurringPaymentRegistration(
        id: json['Id'] as String,
        authorId: json['AuthorId'] as String,
        cardId: json['CardId'] as String,
        creditedWalletId: json['CreditedWalletId'] as String,
        status: json['Status'] as String,
        currentState: json['CurrentState'] as String?,
        firstTransactionDebitedFunds:
            json['FirstTransactionDebitedFunds'] != null
                ? Money.fromJson(
                    json['FirstTransactionDebitedFunds'] as Map<String, Object?>,
                  )
                : null,
        firstTransactionFees: json['FirstTransactionFees'] != null
            ? Money.fromJson(
                json['FirstTransactionFees'] as Map<String, Object?>,
              )
            : null,
        nextTransactionDebitedFunds:
            json['NextTransactionDebitedFunds'] != null
                ? Money.fromJson(
                    json['NextTransactionDebitedFunds'] as Map<String, Object?>,
                  )
                : null,
        nextTransactionFees: json['NextTransactionFees'] != null
            ? Money.fromJson(
                json['NextTransactionFees'] as Map<String, Object?>,
              )
            : null,
        endDate: json['EndDate'] as int?,
        frequency: json['Frequency'] as String?,
        fixedNextAmount: json['FixedNextAmount'] as bool?,
        fractionedPayment: json['FractionedPayment'] as bool?,
        migration: json['Migration'] as bool?,
        totalAmount: json['TotalAmount'] != null
            ? Money.fromJson(json['TotalAmount'] as Map<String, Object?>)
            : null,
        cycleNumber: json['CycleNumber'] as int?,
        tag: json['Tag'] as String?,
        creationDate: json['CreationDate'] as int?,
      );

  /// Registration ID.
  final String id;

  /// Author user ID.
  final String authorId;

  /// Card ID.
  final String cardId;

  /// Credited wallet ID.
  final String creditedWalletId;

  /// Registration status.
  final String status;

  /// Current state.
  final String? currentState;

  /// First transaction amount.
  final Money? firstTransactionDebitedFunds;

  /// First transaction fees.
  final Money? firstTransactionFees;

  /// Next transaction amount.
  final Money? nextTransactionDebitedFunds;

  /// Next transaction fees.
  final Money? nextTransactionFees;

  /// End date timestamp.
  final int? endDate;

  /// Payment frequency.
  final String? frequency;

  /// Whether next amount is fixed.
  final bool? fixedNextAmount;

  /// Whether payment is fractioned.
  final bool? fractionedPayment;

  /// Migration flag.
  final bool? migration;

  /// Total amount.
  final Money? totalAmount;

  /// Cycle number.
  final int? cycleNumber;

  /// Custom tag.
  final String? tag;

  /// Creation timestamp.
  final int? creationDate;

  /// Converts to JSON.
  Map<String, Object?> toJson() => {
        'Id': id,
        'AuthorId': authorId,
        'CardId': cardId,
        'CreditedWalletId': creditedWalletId,
        'Status': status,
        if (currentState != null) 'CurrentState': currentState,
        if (firstTransactionDebitedFunds != null)
          'FirstTransactionDebitedFunds': firstTransactionDebitedFunds!.toJson(),
        if (firstTransactionFees != null)
          'FirstTransactionFees': firstTransactionFees!.toJson(),
        if (nextTransactionDebitedFunds != null)
          'NextTransactionDebitedFunds': nextTransactionDebitedFunds!.toJson(),
        if (nextTransactionFees != null)
          'NextTransactionFees': nextTransactionFees!.toJson(),
        if (endDate != null) 'EndDate': endDate,
        if (frequency != null) 'Frequency': frequency,
        if (fixedNextAmount != null) 'FixedNextAmount': fixedNextAmount,
        if (fractionedPayment != null) 'FractionedPayment': fractionedPayment,
        if (migration != null) 'Migration': migration,
        if (totalAmount != null) 'TotalAmount': totalAmount!.toJson(),
        if (cycleNumber != null) 'CycleNumber': cycleNumber,
        if (tag != null) 'Tag': tag,
        if (creationDate != null) 'CreationDate': creationDate,
      };
}

/// Request to create a recurring payment registration.
class CreateRecurringPaymentRequest {
  /// Creates a recurring payment request.
  const CreateRecurringPaymentRequest({
    required this.authorId,
    required this.cardId,
    required this.creditedWalletId,
    required this.firstTransactionDebitedFunds,
    required this.firstTransactionFees,
    this.creditedUserId,
    this.nextTransactionDebitedFunds,
    this.nextTransactionFees,
    this.endDate,
    this.frequency,
    this.fixedNextAmount,
    this.fractionedPayment,
    this.migration,
    this.tag,
  });

  /// Author user ID.
  final String authorId;

  /// Card ID.
  final String cardId;

  /// Wallet ID to credit.
  final String creditedWalletId;

  /// First transaction amount.
  final Money firstTransactionDebitedFunds;

  /// First transaction fees.
  final Money firstTransactionFees;

  /// User ID to credit.
  final String? creditedUserId;

  /// Next transaction amount.
  final Money? nextTransactionDebitedFunds;

  /// Next transaction fees.
  final Money? nextTransactionFees;

  /// End date timestamp.
  final int? endDate;

  /// Payment frequency.
  final String? frequency;

  /// Whether next amount is fixed.
  final bool? fixedNextAmount;

  /// Whether payment is fractioned.
  final bool? fractionedPayment;

  /// Migration flag.
  final bool? migration;

  /// Custom tag.
  final String? tag;

  /// Converts to JSON.
  Map<String, Object?> toJson() => {
        'AuthorId': authorId,
        'CardId': cardId,
        'CreditedWalletId': creditedWalletId,
        'FirstTransactionDebitedFunds': firstTransactionDebitedFunds.toJson(),
        'FirstTransactionFees': firstTransactionFees.toJson(),
        if (creditedUserId != null) 'CreditedUserId': creditedUserId,
        if (nextTransactionDebitedFunds != null)
          'NextTransactionDebitedFunds': nextTransactionDebitedFunds!.toJson(),
        if (nextTransactionFees != null)
          'NextTransactionFees': nextTransactionFees!.toJson(),
        if (endDate != null) 'EndDate': endDate,
        if (frequency != null) 'Frequency': frequency,
        if (fixedNextAmount != null) 'FixedNextAmount': fixedNextAmount,
        if (fractionedPayment != null) 'FractionedPayment': fractionedPayment,
        if (migration != null) 'Migration': migration,
        if (tag != null) 'Tag': tag,
      };
}

/// Request to update a recurring payment registration.
class UpdateRecurringPaymentRequest {
  /// Creates an update request.
  const UpdateRecurringPaymentRequest({
    this.cardId,
    this.status,
    this.tag,
  });

  /// New card ID.
  final String? cardId;

  /// New status.
  final String? status;

  /// New tag.
  final String? tag;

  /// Converts to JSON.
  Map<String, Object?> toJson() => {
        if (cardId != null) 'CardId': cardId,
        if (status != null) 'Status': status,
        if (tag != null) 'Tag': tag,
      };
}

/// Request to create a recurring CIT (Customer-Initiated Transaction).
class CreateRecurringCitPayinRequest {
  /// Creates a recurring CIT request.
  const CreateRecurringCitPayinRequest({
    required this.recurringPayinRegistrationId,
    required this.debitedFunds,
    required this.fees,
    required this.secureModeReturnUrl,
    this.browserInfo,
    this.ipAddress,
    this.statementDescriptor,
    this.tag,
  });

  /// Recurring registration ID.
  final String recurringPayinRegistrationId;

  /// Amount to debit.
  final Money debitedFunds;

  /// Fees to charge.
  final Money fees;

  /// Return URL after 3DS.
  final String secureModeReturnUrl;

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
        'RecurringPayinRegistrationId': recurringPayinRegistrationId,
        'DebitedFunds': debitedFunds.toJson(),
        'Fees': fees.toJson(),
        'SecureModeReturnURL': secureModeReturnUrl,
        if (browserInfo != null) 'BrowserInfo': browserInfo!.toJson(),
        if (ipAddress != null) 'IpAddress': ipAddress,
        if (statementDescriptor != null)
          'StatementDescriptor': statementDescriptor,
        if (tag != null) 'Tag': tag,
      };
}

/// Request to create a recurring MIT (Merchant-Initiated Transaction).
class CreateRecurringMitPayinRequest {
  /// Creates a recurring MIT request.
  const CreateRecurringMitPayinRequest({
    required this.recurringPayinRegistrationId,
    required this.debitedFunds,
    required this.fees,
    this.statementDescriptor,
    this.tag,
  });

  /// Recurring registration ID.
  final String recurringPayinRegistrationId;

  /// Amount to debit.
  final Money debitedFunds;

  /// Fees to charge.
  final Money fees;

  /// Statement descriptor.
  final String? statementDescriptor;

  /// Custom tag.
  final String? tag;

  /// Converts to JSON.
  Map<String, Object?> toJson() => {
        'RecurringPayinRegistrationId': recurringPayinRegistrationId,
        'DebitedFunds': debitedFunds.toJson(),
        'Fees': fees.toJson(),
        if (statementDescriptor != null)
          'StatementDescriptor': statementDescriptor,
        if (tag != null) 'Tag': tag,
      };
}

/// A refund transaction.
class Refund {
  /// Creates a refund.
  const Refund({
    required this.id,
    required this.authorId,
    required this.debitedFunds,
    required this.creditedFunds,
    required this.fees,
    required this.status,
    required this.nature,
    required this.initialTransactionId,
    required this.initialTransactionType,
    this.debitedWalletId,
    this.creditedWalletId,
    this.creditedUserId,
    this.refundReason,
    this.tag,
    this.creationDate,
    this.executionDate,
    this.resultCode,
    this.resultMessage,
  });

  /// Creates a Refund from JSON.
  factory Refund.fromJson(Map<String, Object?> json) => Refund(
        id: json['Id'] as String,
        authorId: json['AuthorId'] as String,
        debitedFunds:
            Money.fromJson(json['DebitedFunds'] as Map<String, Object?>),
        creditedFunds:
            Money.fromJson(json['CreditedFunds'] as Map<String, Object?>),
        fees: Money.fromJson(json['Fees'] as Map<String, Object?>),
        status: TransactionStatus.values.byName(json['Status'] as String),
        nature: TransactionNature.values.byName(json['Nature'] as String),
        initialTransactionId: json['InitialTransactionId'] as String,
        initialTransactionType: json['InitialTransactionType'] as String,
        debitedWalletId: json['DebitedWalletId'] as String?,
        creditedWalletId: json['CreditedWalletId'] as String?,
        creditedUserId: json['CreditedUserId'] as String?,
        refundReason: json['RefundReason'] != null
            ? RefundReason.fromJson(
                json['RefundReason'] as Map<String, Object?>,
              )
            : null,
        tag: json['Tag'] as String?,
        creationDate: json['CreationDate'] as int?,
        executionDate: json['ExecutionDate'] as int?,
        resultCode: json['ResultCode'] as String?,
        resultMessage: json['ResultMessage'] as String?,
      );

  /// Refund ID.
  final String id;

  /// Author user ID.
  final String authorId;

  /// Debited amount.
  final Money debitedFunds;

  /// Credited amount.
  final Money creditedFunds;

  /// Fees.
  final Money fees;

  /// Refund status.
  final TransactionStatus status;

  /// Transaction nature.
  final TransactionNature nature;

  /// Original transaction ID.
  final String initialTransactionId;

  /// Original transaction type.
  final String initialTransactionType;

  /// Debited wallet ID.
  final String? debitedWalletId;

  /// Credited wallet ID.
  final String? creditedWalletId;

  /// Credited user ID.
  final String? creditedUserId;

  /// Refund reason.
  final RefundReason? refundReason;

  /// Custom tag.
  final String? tag;

  /// Creation timestamp.
  final int? creationDate;

  /// Execution timestamp.
  final int? executionDate;

  /// Result code.
  final String? resultCode;

  /// Result message.
  final String? resultMessage;

  /// Converts to JSON.
  Map<String, Object?> toJson() => {
        'Id': id,
        'AuthorId': authorId,
        'DebitedFunds': debitedFunds.toJson(),
        'CreditedFunds': creditedFunds.toJson(),
        'Fees': fees.toJson(),
        'Status': status.name,
        'Nature': nature.name,
        'InitialTransactionId': initialTransactionId,
        'InitialTransactionType': initialTransactionType,
        if (debitedWalletId != null) 'DebitedWalletId': debitedWalletId,
        if (creditedWalletId != null) 'CreditedWalletId': creditedWalletId,
        if (creditedUserId != null) 'CreditedUserId': creditedUserId,
        if (refundReason != null) 'RefundReason': refundReason!.toJson(),
        if (tag != null) 'Tag': tag,
        if (creationDate != null) 'CreationDate': creationDate,
        if (executionDate != null) 'ExecutionDate': executionDate,
        if (resultCode != null) 'ResultCode': resultCode,
        if (resultMessage != null) 'ResultMessage': resultMessage,
      };
}

/// Reason for a refund.
class RefundReason {
  /// Creates a refund reason.
  const RefundReason({
    this.refundReasonType,
    this.refundReasonMessage,
  });

  /// Creates from JSON.
  factory RefundReason.fromJson(Map<String, Object?> json) => RefundReason(
        refundReasonType: json['RefundReasonType'] as String?,
        refundReasonMessage: json['RefundReasonMessage'] as String?,
      );

  /// Reason type.
  final String? refundReasonType;

  /// Reason message.
  final String? refundReasonMessage;

  /// Converts to JSON.
  Map<String, Object?> toJson() => {
        if (refundReasonType != null) 'RefundReasonType': refundReasonType,
        if (refundReasonMessage != null)
          'RefundReasonMessage': refundReasonMessage,
      };
}

/// Request to create a refund.
class CreateRefundRequest {
  /// Creates a refund request.
  const CreateRefundRequest({
    required this.authorId,
    this.debitedFunds,
    this.fees,
    this.tag,
  });

  /// Author user ID.
  final String authorId;

  /// Amount to refund (partial refund).
  final Money? debitedFunds;

  /// Fees to refund.
  final Money? fees;

  /// Custom tag.
  final String? tag;

  /// Converts to JSON.
  Map<String, Object?> toJson() => {
        'AuthorId': authorId,
        if (debitedFunds != null) 'DebitedFunds': debitedFunds!.toJson(),
        if (fees != null) 'Fees': fees!.toJson(),
        if (tag != null) 'Tag': tag,
      };
}
