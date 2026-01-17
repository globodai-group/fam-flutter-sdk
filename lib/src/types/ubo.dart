/// UBO (Ultimate Beneficial Owner) types for the FAM SDK.
///
/// Provides types for UBO declarations required for legal entities.
library;

import 'common.dart';

/// UBO declaration status.
enum UboDeclarationStatus {
  /// Declaration created.
  CREATED,

  /// Declaration submitted for validation.
  // ignore: constant_identifier_names
  VALIDATION_ASKED,

  /// Declaration is incomplete.
  INCOMPLETE,

  /// Declaration validated.
  VALIDATED,

  /// Declaration refused.
  REFUSED,
}

/// Reason for refused UBO declaration.
enum UboDeclarationRefusedReason {
  /// Missing UBO information.
  // ignore: constant_identifier_names
  MISSING_UBO,

  /// Wrong UBO information.
  // ignore: constant_identifier_names
  WRONG_UBO_INFORMATION,

  /// UBO identity verification needed.
  // ignore: constant_identifier_names
  UBO_IDENTITY_NEEDED,

  /// Shareholders declaration needed.
  // ignore: constant_identifier_names
  SHAREHOLDERS_DECLARATION_NEEDED,

  /// Organization chart needed.
  // ignore: constant_identifier_names
  ORGANIZATION_CHART_NEEDED,

  /// Additional documents needed.
  // ignore: constant_identifier_names
  DOCUMENTS_NEEDED,

  /// Declaration does not match UBO information.
  // ignore: constant_identifier_names
  DECLARATION_DO_NOT_MATCH_UBO_INFORMATION,

  /// Specific case requiring manual review.
  // ignore: constant_identifier_names
  SPECIFIC_CASE,
}

/// Birthplace information.
class Birthplace {
  /// Creates a birthplace.
  const Birthplace({
    required this.city,
    required this.country,
  });

  /// Creates from JSON.
  factory Birthplace.fromJson(Map<String, Object?> json) => Birthplace(
        city: json['City'] as String,
        country: json['Country'] as String,
      );

  /// City of birth.
  final String city;

  /// Country of birth (ISO 3166-1 alpha-2).
  final String country;

  /// Converts to JSON.
  Map<String, Object?> toJson() => {
        'City': city,
        'Country': country,
      };
}

/// An Ultimate Beneficial Owner.
///
/// Represents a person who owns or controls more than 25%
/// of a legal entity.
class Ubo {
  /// Creates a UBO.
  const Ubo({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.address,
    required this.nationality,
    required this.birthday,
    required this.birthplace,
    this.isActive,
  });

  /// Creates a Ubo from JSON.
  factory Ubo.fromJson(Map<String, Object?> json) => Ubo(
        id: json['Id'] as String,
        firstName: json['FirstName'] as String,
        lastName: json['LastName'] as String,
        address: Address.fromJson(json['Address'] as Map<String, Object?>),
        nationality: json['Nationality'] as String,
        birthday: json['Birthday'] as int,
        birthplace:
            Birthplace.fromJson(json['Birthplace'] as Map<String, Object?>),
        isActive: json['IsActive'] as bool?,
      );

  /// UBO ID.
  final String id;

  /// First name.
  final String firstName;

  /// Last name.
  final String lastName;

  /// Address.
  final Address address;

  /// Nationality (ISO 3166-1 alpha-2).
  final String nationality;

  /// Birthday as Unix timestamp.
  final int birthday;

  /// Birthplace.
  final Birthplace birthplace;

  /// Whether the UBO is active.
  final bool? isActive;

  /// Full name.
  String get fullName => '$firstName $lastName';

  /// Converts to JSON.
  Map<String, Object?> toJson() => {
        'Id': id,
        'FirstName': firstName,
        'LastName': lastName,
        'Address': address.toJson(),
        'Nationality': nationality,
        'Birthday': birthday,
        'Birthplace': birthplace.toJson(),
        if (isActive != null) 'IsActive': isActive,
      };
}

/// A UBO declaration for a legal entity.
///
/// ```dart
/// final uboModule = fam.ubo('legal_user_123');
///
/// // Create a declaration
/// final declaration = await uboModule.createDeclaration();
///
/// // Add UBOs
/// await uboModule.createUbo(declaration.id, CreateUboRequest(...));
///
/// // Submit for validation
/// await uboModule.submit(declaration.id);
/// ```
class UboDeclaration {
  /// Creates a UBO declaration.
  const UboDeclaration({
    required this.id,
    required this.userId,
    required this.status,
    required this.ubos,
    this.processedDate,
    this.reason,
    this.message,
    this.creationDate,
  });

  /// Creates a UboDeclaration from JSON.
  factory UboDeclaration.fromJson(Map<String, Object?> json) => UboDeclaration(
        id: json['Id'] as String,
        userId: json['UserId'] as String,
        status: UboDeclarationStatus.values.byName(json['Status'] as String),
        ubos: (json['Ubos'] as List<Object?>)
            .cast<Map<String, Object?>>()
            .map(Ubo.fromJson)
            .toList(growable: false),
        processedDate: json['ProcessedDate'] as int?,
        reason: json['Reason'] != null
            ? UboDeclarationRefusedReason.values.byName(json['Reason'] as String)
            : null,
        message: json['Message'] as String?,
        creationDate: json['CreationDate'] as int?,
      );

  /// Declaration ID.
  final String id;

  /// Owner user ID.
  final String userId;

  /// Declaration status.
  final UboDeclarationStatus status;

  /// List of UBOs.
  final List<Ubo> ubos;

  /// Processing date timestamp.
  final int? processedDate;

  /// Refusal reason.
  final UboDeclarationRefusedReason? reason;

  /// Refusal message.
  final String? message;

  /// Creation timestamp.
  final int? creationDate;

  /// Whether the declaration is validated.
  bool get isValidated => status == UboDeclarationStatus.VALIDATED;

  /// Whether the declaration is pending review.
  bool get isPending => status == UboDeclarationStatus.VALIDATION_ASKED;

  /// Whether the declaration was refused.
  bool get isRefused => status == UboDeclarationStatus.REFUSED;

  /// Converts to JSON.
  Map<String, Object?> toJson() => {
        'Id': id,
        'UserId': userId,
        'Status': status.name,
        'Ubos': ubos.map((u) => u.toJson()).toList(growable: false),
        if (processedDate != null) 'ProcessedDate': processedDate,
        if (reason != null) 'Reason': reason!.name,
        if (message != null) 'Message': message,
        if (creationDate != null) 'CreationDate': creationDate,
      };
}

/// Request to create a UBO.
class CreateUboRequest {
  /// Creates a UBO request.
  const CreateUboRequest({
    required this.firstName,
    required this.lastName,
    required this.address,
    required this.nationality,
    required this.birthday,
    required this.birthplace,
  });

  /// First name.
  final String firstName;

  /// Last name.
  final String lastName;

  /// Address.
  final Address address;

  /// Nationality (ISO 3166-1 alpha-2).
  final String nationality;

  /// Birthday as Unix timestamp.
  final int birthday;

  /// Birthplace.
  final Birthplace birthplace;

  /// Converts to JSON.
  Map<String, Object?> toJson() => {
        'FirstName': firstName,
        'LastName': lastName,
        'Address': address.toJson(),
        'Nationality': nationality,
        'Birthday': birthday,
        'Birthplace': birthplace.toJson(),
      };
}

/// Request to update a UBO.
class UpdateUboRequest {
  /// Creates a UBO update request.
  const UpdateUboRequest({
    this.firstName,
    this.lastName,
    this.address,
    this.nationality,
    this.birthday,
    this.birthplace,
    this.isActive,
  });

  /// First name.
  final String? firstName;

  /// Last name.
  final String? lastName;

  /// Address.
  final Address? address;

  /// Nationality.
  final String? nationality;

  /// Birthday.
  final int? birthday;

  /// Birthplace.
  final Birthplace? birthplace;

  /// Active status.
  final bool? isActive;

  /// Converts to JSON.
  Map<String, Object?> toJson() => {
        if (firstName != null) 'FirstName': firstName,
        if (lastName != null) 'LastName': lastName,
        if (address != null) 'Address': address!.toJson(),
        if (nationality != null) 'Nationality': nationality,
        if (birthday != null) 'Birthday': birthday,
        if (birthplace != null) 'Birthplace': birthplace!.toJson(),
        if (isActive != null) 'IsActive': isActive,
      };
}
