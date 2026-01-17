/// PayOut types for the FAM SDK.
///
/// Provides types for bank wire withdrawals.
library;

import 'common.dart';

/// Payout mode.
enum PayoutMode {
  /// Standard bank wire (2-5 business days).
  STANDARD,

  /// Instant payment if available.
  // ignore: constant_identifier_names
  INSTANT_PAYMENT,

  /// Instant payment only (fails if not available).
  // ignore: constant_identifier_names
  INSTANT_PAYMENT_ONLY,
}

/// A pay-out transaction (withdrawing funds).
///
/// Represents money sent from a wallet to a bank account.
///
/// ```dart
/// final payout = await fam.payouts.create(
///   CreatePayoutRequest(
///     authorId: 'user_123',
///     debitedWalletId: 'wallet_456',
///     debitedFunds: Money(amount: 10000, currency: Currency.EUR),
///     fees: Money(amount: 0, currency: Currency.EUR),
///     bankAccountId: 'bank_789',
///   ),
/// );
/// ```
class Payout {
  /// Creates a payout.
  const Payout({
    required this.id,
    required this.authorId,
    required this.debitedWalletId,
    required this.debitedFunds,
    required this.creditedFunds,
    required this.fees,
    required this.status,
    required this.bankAccountId,
    this.creditedUserId,
    this.paymentType,
    this.bankWireRef,
    this.payoutModeRequested,
    this.payoutModeApplied,
    this.fallbackReason,
    this.endToEndId,
    this.tag,
    this.creationDate,
    this.executionDate,
    this.resultCode,
    this.resultMessage,
  });

  /// Creates a Payout from JSON.
  factory Payout.fromJson(Map<String, Object?> json) => Payout(
        id: json['Id'] as String,
        authorId: json['AuthorId'] as String,
        debitedWalletId: json['DebitedWalletId'] as String,
        debitedFunds:
            Money.fromJson(json['DebitedFunds'] as Map<String, Object?>),
        creditedFunds:
            Money.fromJson(json['CreditedFunds'] as Map<String, Object?>),
        fees: Money.fromJson(json['Fees'] as Map<String, Object?>),
        status: TransactionStatus.values.byName(json['Status'] as String),
        bankAccountId: json['BankAccountId'] as String,
        creditedUserId: json['CreditedUserId'] as String?,
        paymentType: json['PaymentType'] as String?,
        bankWireRef: json['BankWireRef'] as String?,
        payoutModeRequested: json['PayoutModeRequested'] != null
            ? PayoutMode.values.byName(json['PayoutModeRequested'] as String)
            : null,
        payoutModeApplied: json['PayoutModeApplied'] != null
            ? PayoutMode.values.byName(json['PayoutModeApplied'] as String)
            : null,
        fallbackReason: json['FallbackReason'] as String?,
        endToEndId: json['EndToEndId'] as String?,
        tag: json['Tag'] as String?,
        creationDate: json['CreationDate'] as int?,
        executionDate: json['ExecutionDate'] as int?,
        resultCode: json['ResultCode'] as String?,
        resultMessage: json['ResultMessage'] as String?,
      );

  /// Unique payout identifier.
  final String id;

  /// ID of the user initiating payout.
  final String authorId;

  /// ID of the debited wallet.
  final String debitedWalletId;

  /// Amount debited from wallet.
  final Money debitedFunds;

  /// Amount credited to bank account.
  final Money creditedFunds;

  /// Fees charged.
  final Money fees;

  /// Transaction status.
  final TransactionStatus status;

  /// ID of the destination bank account.
  final String bankAccountId;

  /// ID of the credited user.
  final String? creditedUserId;

  /// Payment type.
  final String? paymentType;

  /// Bank wire reference.
  final String? bankWireRef;

  /// Requested payout mode.
  final PayoutMode? payoutModeRequested;

  /// Actual payout mode applied.
  final PayoutMode? payoutModeApplied;

  /// Reason for fallback to standard mode.
  final String? fallbackReason;

  /// End-to-end ID.
  final String? endToEndId;

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

  /// Converts to JSON map.
  Map<String, Object?> toJson() => {
        'Id': id,
        'AuthorId': authorId,
        'DebitedWalletId': debitedWalletId,
        'DebitedFunds': debitedFunds.toJson(),
        'CreditedFunds': creditedFunds.toJson(),
        'Fees': fees.toJson(),
        'Status': status.name,
        'BankAccountId': bankAccountId,
        if (creditedUserId != null) 'CreditedUserId': creditedUserId,
        if (paymentType != null) 'PaymentType': paymentType,
        if (bankWireRef != null) 'BankWireRef': bankWireRef,
        if (payoutModeRequested != null)
          'PayoutModeRequested': payoutModeRequested!.name,
        if (payoutModeApplied != null)
          'PayoutModeApplied': payoutModeApplied!.name,
        if (fallbackReason != null) 'FallbackReason': fallbackReason,
        if (endToEndId != null) 'EndToEndId': endToEndId,
        if (tag != null) 'Tag': tag,
        if (creationDate != null) 'CreationDate': creationDate,
        if (executionDate != null) 'ExecutionDate': executionDate,
        if (resultCode != null) 'ResultCode': resultCode,
        if (resultMessage != null) 'ResultMessage': resultMessage,
      };
}

/// Request to create a payout.
class CreatePayoutRequest {
  /// Creates a payout request.
  const CreatePayoutRequest({
    required this.authorId,
    required this.debitedWalletId,
    required this.debitedFunds,
    required this.fees,
    required this.bankAccountId,
    this.bankWireRef,
    this.payoutModeRequested,
    this.tag,
  });

  /// ID of the user making payout.
  final String authorId;

  /// ID of the wallet to debit.
  final String debitedWalletId;

  /// Amount to debit.
  final Money debitedFunds;

  /// Fees to charge.
  final Money fees;

  /// ID of the destination bank account.
  final String bankAccountId;

  /// Bank wire reference.
  final String? bankWireRef;

  /// Requested payout mode.
  final PayoutMode? payoutModeRequested;

  /// Custom tag.
  final String? tag;

  /// Converts to JSON map.
  Map<String, Object?> toJson() => {
        'AuthorId': authorId,
        'DebitedWalletId': debitedWalletId,
        'DebitedFunds': debitedFunds.toJson(),
        'Fees': fees.toJson(),
        'BankAccountId': bankAccountId,
        if (bankWireRef != null) 'BankWireRef': bankWireRef,
        if (payoutModeRequested != null)
          'PayoutModeRequested': payoutModeRequested!.name,
        if (tag != null) 'Tag': tag,
      };
}
