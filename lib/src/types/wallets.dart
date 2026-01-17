/// Wallet types for the FAM SDK.
///
/// Provides types for wallet management and transactions.
library;

import 'common.dart';

/// Wallet status.
enum WalletStatus {
  /// Wallet is active and usable.
  CREATED,

  /// Wallet is closed and cannot be used.
  CLOSED,
}

/// Type of funds in wallet.
enum FundsType {
  /// Default wallet funds.
  DEFAULT,

  /// Fees wallet.
  FEES,

  /// Credit wallet.
  CREDIT,
}

/// A user's e-wallet for holding funds.
///
/// Wallets are used to receive payments and make transfers/payouts.
///
/// ```dart
/// final wallet = await fam.wallets.create(
///   CreateWalletRequest(
///     owners: ['user_123'],
///     description: 'Main Wallet',
///     currency: Currency.EUR,
///   ),
/// );
/// print('Balance: ${wallet.balance}');
/// ```
class Wallet {
  /// Creates a wallet.
  const Wallet({
    required this.id,
    required this.owners,
    required this.description,
    required this.balance,
    required this.currency,
    this.fundsType = FundsType.DEFAULT,
    this.tag,
    this.creationDate,
  });

  /// Creates a Wallet from JSON.
  factory Wallet.fromJson(Map<String, Object?> json) => Wallet(
        id: json['Id'] as String,
        owners: (json['Owners'] as List<Object?>).cast<String>(),
        description: json['Description'] as String,
        balance: Money.fromJson(json['Balance'] as Map<String, Object?>),
        currency: Currency.values.byName(json['Currency'] as String),
        fundsType: json['FundsType'] != null
            ? FundsType.values.byName(json['FundsType'] as String)
            : FundsType.DEFAULT,
        tag: json['Tag'] as String?,
        creationDate: json['CreationDate'] as int?,
      );

  /// Unique wallet identifier.
  final String id;

  /// List of owner user IDs.
  final List<String> owners;

  /// Wallet description.
  final String description;

  /// Current balance.
  final Money balance;

  /// Wallet currency.
  final Currency currency;

  /// Type of funds.
  final FundsType fundsType;

  /// Custom tag.
  final String? tag;

  /// Creation timestamp.
  final int? creationDate;

  /// Converts to JSON map.
  Map<String, Object?> toJson() => {
        'Id': id,
        'Owners': owners,
        'Description': description,
        'Balance': balance.toJson(),
        'Currency': currency.name,
        'FundsType': fundsType.name,
        if (tag != null) 'Tag': tag,
        if (creationDate != null) 'CreationDate': creationDate,
      };
}

/// Request to create a wallet.
class CreateWalletRequest {
  /// Creates a wallet creation request.
  const CreateWalletRequest({
    required this.owners,
    required this.description,
    required this.currency,
    this.tag,
  });

  /// List of owner user IDs.
  final List<String> owners;

  /// Wallet description.
  final String description;

  /// Wallet currency.
  final Currency currency;

  /// Custom tag.
  final String? tag;

  /// Converts to JSON map.
  Map<String, Object?> toJson() => {
        'Owners': owners,
        'Description': description,
        'Currency': currency.name,
        if (tag != null) 'Tag': tag,
      };
}

/// Request to update a wallet.
class UpdateWalletRequest {
  /// Creates a wallet update request.
  const UpdateWalletRequest({
    this.description,
    this.tag,
  });

  /// New description.
  final String? description;

  /// New tag.
  final String? tag;

  /// Converts to JSON map.
  Map<String, Object?> toJson() => {
        if (description != null) 'Description': description,
        if (tag != null) 'Tag': tag,
      };
}

/// Transaction type within a wallet.
enum WalletTransactionType {
  /// Payment received.
  PAYIN,

  /// Payment sent out.
  PAYOUT,

  /// Transfer between wallets.
  TRANSFER,
}

/// A transaction on a wallet.
///
/// Represents any fund movement on a wallet (payin, payout, or transfer).
class WalletTransaction {
  /// Creates a wallet transaction.
  const WalletTransaction({
    required this.id,
    required this.type,
    required this.nature,
    required this.status,
    required this.authorId,
    required this.debitedFunds,
    required this.creditedFunds,
    required this.fees,
    this.debitedWalletId,
    this.creditedWalletId,
    this.tag,
    this.creationDate,
    this.executionDate,
    this.resultCode,
    this.resultMessage,
  });

  /// Creates a WalletTransaction from JSON.
  factory WalletTransaction.fromJson(Map<String, Object?> json) =>
      WalletTransaction(
        id: json['Id'] as String,
        type: WalletTransactionType.values.byName(json['Type'] as String),
        nature: TransactionNature.values.byName(json['Nature'] as String),
        status: TransactionStatus.values.byName(json['Status'] as String),
        authorId: json['AuthorId'] as String,
        debitedFunds:
            Money.fromJson(json['DebitedFunds'] as Map<String, Object?>),
        creditedFunds:
            Money.fromJson(json['CreditedFunds'] as Map<String, Object?>),
        fees: Money.fromJson(json['Fees'] as Map<String, Object?>),
        debitedWalletId: json['DebitedWalletId'] as String?,
        creditedWalletId: json['CreditedWalletId'] as String?,
        tag: json['Tag'] as String?,
        creationDate: json['CreationDate'] as int?,
        executionDate: json['ExecutionDate'] as int?,
        resultCode: json['ResultCode'] as String?,
        resultMessage: json['ResultMessage'] as String?,
      );

  /// Transaction ID.
  final String id;

  /// Transaction type.
  final WalletTransactionType type;

  /// Transaction nature.
  final TransactionNature nature;

  /// Transaction status.
  final TransactionStatus status;

  /// ID of the user who initiated the transaction.
  final String authorId;

  /// Amount debited.
  final Money debitedFunds;

  /// Amount credited.
  final Money creditedFunds;

  /// Fees charged.
  final Money fees;

  /// Source wallet ID (for transfers/payouts).
  final String? debitedWalletId;

  /// Destination wallet ID (for payins/transfers).
  final String? creditedWalletId;

  /// Custom tag.
  final String? tag;

  /// Creation timestamp.
  final int? creationDate;

  /// Execution timestamp.
  final int? executionDate;

  /// Result code from payment processor.
  final String? resultCode;

  /// Result message.
  final String? resultMessage;

  /// Converts to JSON map.
  Map<String, Object?> toJson() => {
        'Id': id,
        'Type': type.name,
        'Nature': nature.name,
        'Status': status.name,
        'AuthorId': authorId,
        'DebitedFunds': debitedFunds.toJson(),
        'CreditedFunds': creditedFunds.toJson(),
        'Fees': fees.toJson(),
        if (debitedWalletId != null) 'DebitedWalletId': debitedWalletId,
        if (creditedWalletId != null) 'CreditedWalletId': creditedWalletId,
        if (tag != null) 'Tag': tag,
        if (creationDate != null) 'CreationDate': creationDate,
        if (executionDate != null) 'ExecutionDate': executionDate,
        if (resultCode != null) 'ResultCode': resultCode,
        if (resultMessage != null) 'ResultMessage': resultMessage,
      };
}
