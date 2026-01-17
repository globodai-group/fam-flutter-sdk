/// Bank account types for the FAM SDK.
///
/// Provides types for different bank account formats.
library;

import 'common.dart';

/// Bank account type.
enum BankAccountType {
  /// IBAN account (Europe).
  IBAN,

  /// UK account (Sort code + Account number).
  GB,

  /// US account (ABA + Account number).
  US,

  /// Canadian account.
  CA,

  /// Other account format.
  OTHER,
}

/// Deposit account type for US accounts.
enum DepositAccountType {
  /// Checking account.
  CHECKING,

  /// Savings account.
  SAVINGS,
}

/// Base bank account.
abstract class BankAccount {
  /// Creates a bank account.
  const BankAccount({
    required this.id,
    required this.type,
    required this.ownerName,
    this.ownerAddress,
    this.userId,
    this.active,
    this.tag,
    this.creationDate,
  });

  /// Account ID.
  final String id;

  /// Account type.
  final BankAccountType type;

  /// Account owner name.
  final String ownerName;

  /// Account owner address.
  final Address? ownerAddress;

  /// Owner user ID.
  final String? userId;

  /// Whether account is active.
  final bool? active;

  /// Custom tag.
  final String? tag;

  /// Creation timestamp.
  final int? creationDate;

  /// Converts to JSON map.
  Map<String, Object?> toJson();
}

/// IBAN bank account (European format).
class IbanBankAccount extends BankAccount {
  /// Creates an IBAN bank account.
  const IbanBankAccount({
    required super.id,
    required super.ownerName,
    required this.iban,
    super.ownerAddress,
    super.userId,
    super.active,
    super.tag,
    super.creationDate,
    this.bic,
  }) : super(type: BankAccountType.IBAN);

  /// Creates from JSON.
  factory IbanBankAccount.fromJson(Map<String, Object?> json) =>
      IbanBankAccount(
        id: json['Id'] as String,
        ownerName: json['OwnerName'] as String,
        iban: json['IBAN'] as String,
        bic: json['BIC'] as String?,
        ownerAddress: json['OwnerAddress'] != null
            ? Address.fromJson(json['OwnerAddress'] as Map<String, Object?>)
            : null,
        userId: json['UserId'] as String?,
        active: json['Active'] as bool?,
        tag: json['Tag'] as String?,
        creationDate: json['CreationDate'] as int?,
      );

  /// IBAN number.
  final String iban;

  /// BIC/SWIFT code.
  final String? bic;

  @override
  Map<String, Object?> toJson() => {
        'Id': id,
        'Type': type.name,
        'OwnerName': ownerName,
        'IBAN': iban,
        if (bic != null) 'BIC': bic,
        if (ownerAddress != null) 'OwnerAddress': ownerAddress!.toJson(),
        if (userId != null) 'UserId': userId,
        if (active != null) 'Active': active,
        if (tag != null) 'Tag': tag,
        if (creationDate != null) 'CreationDate': creationDate,
      };
}

/// UK bank account (Sort code format).
class GbBankAccount extends BankAccount {
  /// Creates a UK bank account.
  const GbBankAccount({
    required super.id,
    required super.ownerName,
    required this.accountNumber,
    required this.sortCode,
    super.ownerAddress,
    super.userId,
    super.active,
    super.tag,
    super.creationDate,
  }) : super(type: BankAccountType.GB);

  /// Creates from JSON.
  factory GbBankAccount.fromJson(Map<String, Object?> json) => GbBankAccount(
        id: json['Id'] as String,
        ownerName: json['OwnerName'] as String,
        accountNumber: json['AccountNumber'] as String,
        sortCode: json['SortCode'] as String,
        ownerAddress: json['OwnerAddress'] != null
            ? Address.fromJson(json['OwnerAddress'] as Map<String, Object?>)
            : null,
        userId: json['UserId'] as String?,
        active: json['Active'] as bool?,
        tag: json['Tag'] as String?,
        creationDate: json['CreationDate'] as int?,
      );

  /// Account number.
  final String accountNumber;

  /// Sort code.
  final String sortCode;

  @override
  Map<String, Object?> toJson() => {
        'Id': id,
        'Type': type.name,
        'OwnerName': ownerName,
        'AccountNumber': accountNumber,
        'SortCode': sortCode,
        if (ownerAddress != null) 'OwnerAddress': ownerAddress!.toJson(),
        if (userId != null) 'UserId': userId,
        if (active != null) 'Active': active,
        if (tag != null) 'Tag': tag,
        if (creationDate != null) 'CreationDate': creationDate,
      };
}

/// US bank account (ABA routing format).
class UsBankAccount extends BankAccount {
  /// Creates a US bank account.
  const UsBankAccount({
    required super.id,
    required super.ownerName,
    required this.accountNumber,
    required this.aba,
    super.ownerAddress,
    super.userId,
    super.active,
    super.tag,
    super.creationDate,
    this.depositAccountType,
  }) : super(type: BankAccountType.US);

  /// Creates from JSON.
  factory UsBankAccount.fromJson(Map<String, Object?> json) => UsBankAccount(
        id: json['Id'] as String,
        ownerName: json['OwnerName'] as String,
        accountNumber: json['AccountNumber'] as String,
        aba: json['ABA'] as String,
        depositAccountType: json['DepositAccountType'] != null
            ? DepositAccountType.values
                .byName(json['DepositAccountType'] as String)
            : null,
        ownerAddress: json['OwnerAddress'] != null
            ? Address.fromJson(json['OwnerAddress'] as Map<String, Object?>)
            : null,
        userId: json['UserId'] as String?,
        active: json['Active'] as bool?,
        tag: json['Tag'] as String?,
        creationDate: json['CreationDate'] as int?,
      );

  /// Account number.
  final String accountNumber;

  /// ABA routing number.
  final String aba;

  /// Deposit account type.
  final DepositAccountType? depositAccountType;

  @override
  Map<String, Object?> toJson() => {
        'Id': id,
        'Type': type.name,
        'OwnerName': ownerName,
        'AccountNumber': accountNumber,
        'ABA': aba,
        if (depositAccountType != null)
          'DepositAccountType': depositAccountType!.name,
        if (ownerAddress != null) 'OwnerAddress': ownerAddress!.toJson(),
        if (userId != null) 'UserId': userId,
        if (active != null) 'Active': active,
        if (tag != null) 'Tag': tag,
        if (creationDate != null) 'CreationDate': creationDate,
      };
}

/// Canadian bank account.
class CaBankAccount extends BankAccount {
  /// Creates a Canadian bank account.
  const CaBankAccount({
    required super.id,
    required super.ownerName,
    required this.bankName,
    required this.institutionNumber,
    required this.branchCode,
    required this.accountNumber,
    super.ownerAddress,
    super.userId,
    super.active,
    super.tag,
    super.creationDate,
  }) : super(type: BankAccountType.CA);

  /// Creates from JSON.
  factory CaBankAccount.fromJson(Map<String, Object?> json) => CaBankAccount(
        id: json['Id'] as String,
        ownerName: json['OwnerName'] as String,
        bankName: json['BankName'] as String,
        institutionNumber: json['InstitutionNumber'] as String,
        branchCode: json['BranchCode'] as String,
        accountNumber: json['AccountNumber'] as String,
        ownerAddress: json['OwnerAddress'] != null
            ? Address.fromJson(json['OwnerAddress'] as Map<String, Object?>)
            : null,
        userId: json['UserId'] as String?,
        active: json['Active'] as bool?,
        tag: json['Tag'] as String?,
        creationDate: json['CreationDate'] as int?,
      );

  /// Bank name.
  final String bankName;

  /// Institution number.
  final String institutionNumber;

  /// Branch code (transit number).
  final String branchCode;

  /// Account number.
  final String accountNumber;

  @override
  Map<String, Object?> toJson() => {
        'Id': id,
        'Type': type.name,
        'OwnerName': ownerName,
        'BankName': bankName,
        'InstitutionNumber': institutionNumber,
        'BranchCode': branchCode,
        'AccountNumber': accountNumber,
        if (ownerAddress != null) 'OwnerAddress': ownerAddress!.toJson(),
        if (userId != null) 'UserId': userId,
        if (active != null) 'Active': active,
        if (tag != null) 'Tag': tag,
        if (creationDate != null) 'CreationDate': creationDate,
      };
}

/// Other format bank account.
class OtherBankAccount extends BankAccount {
  /// Creates an other format bank account.
  const OtherBankAccount({
    required super.id,
    required super.ownerName,
    required this.country,
    required this.bic,
    required this.accountNumber,
    super.ownerAddress,
    super.userId,
    super.active,
    super.tag,
    super.creationDate,
  }) : super(type: BankAccountType.OTHER);

  /// Creates from JSON.
  factory OtherBankAccount.fromJson(Map<String, Object?> json) =>
      OtherBankAccount(
        id: json['Id'] as String,
        ownerName: json['OwnerName'] as String,
        country: json['Country'] as String,
        bic: json['BIC'] as String,
        accountNumber: json['AccountNumber'] as String,
        ownerAddress: json['OwnerAddress'] != null
            ? Address.fromJson(json['OwnerAddress'] as Map<String, Object?>)
            : null,
        userId: json['UserId'] as String?,
        active: json['Active'] as bool?,
        tag: json['Tag'] as String?,
        creationDate: json['CreationDate'] as int?,
      );

  /// Country code.
  final String country;

  /// BIC/SWIFT code.
  final String bic;

  /// Account number.
  final String accountNumber;

  @override
  Map<String, Object?> toJson() => {
        'Id': id,
        'Type': type.name,
        'OwnerName': ownerName,
        'Country': country,
        'BIC': bic,
        'AccountNumber': accountNumber,
        if (ownerAddress != null) 'OwnerAddress': ownerAddress!.toJson(),
        if (userId != null) 'UserId': userId,
        if (active != null) 'Active': active,
        if (tag != null) 'Tag': tag,
        if (creationDate != null) 'CreationDate': creationDate,
      };
}

/// Parses a bank account from JSON.
BankAccount parseBankAccount(Map<String, Object?> json) {
  final type = BankAccountType.values.byName(json['Type'] as String);
  switch (type) {
    case BankAccountType.IBAN:
      return IbanBankAccount.fromJson(json);
    case BankAccountType.GB:
      return GbBankAccount.fromJson(json);
    case BankAccountType.US:
      return UsBankAccount.fromJson(json);
    case BankAccountType.CA:
      return CaBankAccount.fromJson(json);
    case BankAccountType.OTHER:
      return OtherBankAccount.fromJson(json);
  }
}

/// Request to create an IBAN bank account.
class CreateIbanBankAccountRequest {
  /// Creates an IBAN bank account request.
  const CreateIbanBankAccountRequest({
    required this.ownerName,
    required this.ownerAddress,
    required this.iban,
    this.bic,
    this.tag,
  });

  /// Owner name.
  final String ownerName;

  /// Owner address.
  final Address ownerAddress;

  /// IBAN number.
  final String iban;

  /// BIC/SWIFT code.
  final String? bic;

  /// Custom tag.
  final String? tag;

  /// Converts to JSON.
  Map<String, Object?> toJson() => {
        'OwnerName': ownerName,
        'OwnerAddress': ownerAddress.toJson(),
        'IBAN': iban,
        if (bic != null) 'BIC': bic,
        if (tag != null) 'Tag': tag,
      };
}

/// Request to create a UK bank account.
class CreateGbBankAccountRequest {
  /// Creates a UK bank account request.
  const CreateGbBankAccountRequest({
    required this.ownerName,
    required this.ownerAddress,
    required this.accountNumber,
    required this.sortCode,
    this.tag,
  });

  /// Owner name.
  final String ownerName;

  /// Owner address.
  final Address ownerAddress;

  /// Account number.
  final String accountNumber;

  /// Sort code.
  final String sortCode;

  /// Custom tag.
  final String? tag;

  /// Converts to JSON.
  Map<String, Object?> toJson() => {
        'OwnerName': ownerName,
        'OwnerAddress': ownerAddress.toJson(),
        'AccountNumber': accountNumber,
        'SortCode': sortCode,
        if (tag != null) 'Tag': tag,
      };
}

/// Request to create a US bank account.
class CreateUsBankAccountRequest {
  /// Creates a US bank account request.
  const CreateUsBankAccountRequest({
    required this.ownerName,
    required this.ownerAddress,
    required this.accountNumber,
    required this.aba,
    this.depositAccountType,
    this.tag,
  });

  /// Owner name.
  final String ownerName;

  /// Owner address.
  final Address ownerAddress;

  /// Account number.
  final String accountNumber;

  /// ABA routing number.
  final String aba;

  /// Deposit account type.
  final DepositAccountType? depositAccountType;

  /// Custom tag.
  final String? tag;

  /// Converts to JSON.
  Map<String, Object?> toJson() => {
        'OwnerName': ownerName,
        'OwnerAddress': ownerAddress.toJson(),
        'AccountNumber': accountNumber,
        'ABA': aba,
        if (depositAccountType != null)
          'DepositAccountType': depositAccountType!.name,
        if (tag != null) 'Tag': tag,
      };
}

/// Request to create a Canadian bank account.
class CreateCaBankAccountRequest {
  /// Creates a Canadian bank account request.
  const CreateCaBankAccountRequest({
    required this.ownerName,
    required this.ownerAddress,
    required this.bankName,
    required this.institutionNumber,
    required this.branchCode,
    required this.accountNumber,
    this.tag,
  });

  /// Owner name.
  final String ownerName;

  /// Owner address.
  final Address ownerAddress;

  /// Bank name.
  final String bankName;

  /// Institution number.
  final String institutionNumber;

  /// Branch code.
  final String branchCode;

  /// Account number.
  final String accountNumber;

  /// Custom tag.
  final String? tag;

  /// Converts to JSON.
  Map<String, Object?> toJson() => {
        'OwnerName': ownerName,
        'OwnerAddress': ownerAddress.toJson(),
        'BankName': bankName,
        'InstitutionNumber': institutionNumber,
        'BranchCode': branchCode,
        'AccountNumber': accountNumber,
        if (tag != null) 'Tag': tag,
      };
}

/// Request to create an other format bank account.
class CreateOtherBankAccountRequest {
  /// Creates an other format bank account request.
  const CreateOtherBankAccountRequest({
    required this.ownerName,
    required this.ownerAddress,
    required this.country,
    required this.bic,
    required this.accountNumber,
    this.tag,
  });

  /// Owner name.
  final String ownerName;

  /// Owner address.
  final Address ownerAddress;

  /// Country code.
  final String country;

  /// BIC/SWIFT code.
  final String bic;

  /// Account number.
  final String accountNumber;

  /// Custom tag.
  final String? tag;

  /// Converts to JSON.
  Map<String, Object?> toJson() => {
        'OwnerName': ownerName,
        'OwnerAddress': ownerAddress.toJson(),
        'Country': country,
        'BIC': bic,
        'AccountNumber': accountNumber,
        if (tag != null) 'Tag': tag,
      };
}
