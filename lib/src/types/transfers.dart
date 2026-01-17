/// Transfer types for the FAM SDK.
///
/// Provides types for wallet-to-wallet transfers.
library;

import 'common.dart';
import 'payins.dart';

/// A transfer between wallets.
///
/// Represents money moved from one wallet to another.
///
/// ```dart
/// final transfer = await fam.transfers.create(
///   CreateTransferRequest(
///     authorId: 'user_123',
///     debitedWalletId: 'wallet_source',
///     creditedWalletId: 'wallet_dest',
///     debitedFunds: Money(amount: 1000, currency: Currency.EUR),
///     fees: Money(amount: 0, currency: Currency.EUR),
///   ),
/// );
/// ```
class Transfer {
  /// Creates a transfer.
  const Transfer({
    required this.id,
    required this.authorId,
    required this.debitedWalletId,
    required this.creditedWalletId,
    required this.debitedFunds,
    required this.creditedFunds,
    required this.fees,
    required this.status,
    required this.nature,
    this.creditedUserId,
    this.tag,
    this.creationDate,
    this.executionDate,
    this.resultCode,
    this.resultMessage,
  });

  /// Creates a Transfer from JSON.
  factory Transfer.fromJson(Map<String, Object?> json) => Transfer(
        id: json['Id'] as String,
        authorId: json['AuthorId'] as String,
        debitedWalletId: json['DebitedWalletId'] as String,
        creditedWalletId: json['CreditedWalletId'] as String,
        debitedFunds:
            Money.fromJson(json['DebitedFunds'] as Map<String, Object?>),
        creditedFunds:
            Money.fromJson(json['CreditedFunds'] as Map<String, Object?>),
        fees: Money.fromJson(json['Fees'] as Map<String, Object?>),
        status: TransactionStatus.values.byName(json['Status'] as String),
        nature: TransactionNature.values.byName(json['Nature'] as String),
        creditedUserId: json['CreditedUserId'] as String?,
        tag: json['Tag'] as String?,
        creationDate: json['CreationDate'] as int?,
        executionDate: json['ExecutionDate'] as int?,
        resultCode: json['ResultCode'] as String?,
        resultMessage: json['ResultMessage'] as String?,
      );

  /// Unique transfer identifier.
  final String id;

  /// ID of the user initiating transfer.
  final String authorId;

  /// ID of the source wallet.
  final String debitedWalletId;

  /// ID of the destination wallet.
  final String creditedWalletId;

  /// Amount debited from source wallet.
  final Money debitedFunds;

  /// Amount credited to destination wallet.
  final Money creditedFunds;

  /// Fees charged.
  final Money fees;

  /// Transaction status.
  final TransactionStatus status;

  /// Transaction nature.
  final TransactionNature nature;

  /// ID of the credited user.
  final String? creditedUserId;

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
        'CreditedWalletId': creditedWalletId,
        'DebitedFunds': debitedFunds.toJson(),
        'CreditedFunds': creditedFunds.toJson(),
        'Fees': fees.toJson(),
        'Status': status.name,
        'Nature': nature.name,
        if (creditedUserId != null) 'CreditedUserId': creditedUserId,
        if (tag != null) 'Tag': tag,
        if (creationDate != null) 'CreationDate': creationDate,
        if (executionDate != null) 'ExecutionDate': executionDate,
        if (resultCode != null) 'ResultCode': resultCode,
        if (resultMessage != null) 'ResultMessage': resultMessage,
      };
}

/// Request to create a transfer.
class CreateTransferRequest {
  /// Creates a transfer request.
  const CreateTransferRequest({
    required this.authorId,
    required this.debitedWalletId,
    required this.creditedWalletId,
    required this.debitedFunds,
    required this.fees,
    this.creditedUserId,
    this.tag,
  });

  /// ID of the user making transfer.
  final String authorId;

  /// ID of the source wallet.
  final String debitedWalletId;

  /// ID of the destination wallet.
  final String creditedWalletId;

  /// Amount to transfer.
  final Money debitedFunds;

  /// Fees to charge.
  final Money fees;

  /// ID of the user to credit.
  final String? creditedUserId;

  /// Custom tag.
  final String? tag;

  /// Converts to JSON map.
  Map<String, Object?> toJson() => {
        'AuthorId': authorId,
        'DebitedWalletId': debitedWalletId,
        'CreditedWalletId': creditedWalletId,
        'DebitedFunds': debitedFunds.toJson(),
        'Fees': fees.toJson(),
        if (creditedUserId != null) 'CreditedUserId': creditedUserId,
        if (tag != null) 'Tag': tag,
      };
}

/// Request to create a SCA transfer.
class CreateScaTransferRequest {
  /// Creates a SCA transfer request.
  const CreateScaTransferRequest({
    required this.authorId,
    required this.debitedWalletId,
    required this.creditedWalletId,
    required this.debitedFunds,
    required this.fees,
    required this.recipientId,
    this.creditedUserId,
    this.tag,
  });

  /// ID of the user making transfer.
  final String authorId;

  /// ID of the source wallet.
  final String debitedWalletId;

  /// ID of the destination wallet.
  final String creditedWalletId;

  /// Amount to transfer.
  final Money debitedFunds;

  /// Fees to charge.
  final Money fees;

  /// ID of the SCA recipient.
  final String recipientId;

  /// ID of the user to credit.
  final String? creditedUserId;

  /// Custom tag.
  final String? tag;

  /// Converts to JSON map.
  Map<String, Object?> toJson() => {
        'AuthorId': authorId,
        'DebitedWalletId': debitedWalletId,
        'CreditedWalletId': creditedWalletId,
        'DebitedFunds': debitedFunds.toJson(),
        'Fees': fees.toJson(),
        'RecipientId': recipientId,
        if (creditedUserId != null) 'CreditedUserId': creditedUserId,
        if (tag != null) 'Tag': tag,
      };
}

/// Request to create a transfer refund.
class CreateTransferRefundRequest {
  /// Creates a transfer refund request.
  const CreateTransferRefundRequest({
    required this.authorId,
    this.tag,
  });

  /// ID of the user making the refund.
  final String authorId;

  /// Custom tag.
  final String? tag;

  /// Converts to JSON map.
  Map<String, Object?> toJson() => {
        'AuthorId': authorId,
        if (tag != null) 'Tag': tag,
      };
}

/// Type alias for transfer refund (same as payin refund).
typedef TransferRefund = Refund;
