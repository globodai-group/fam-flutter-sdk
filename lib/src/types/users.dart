/// User types for the FAM SDK.
///
/// Provides types for natural (individual) and legal (company) users.
library;

import 'common.dart';

/// Type of person (individual or company).
enum PersonType {
  /// Individual/natural person.
  NATURAL,

  /// Legal entity/company.
  LEGAL,
}

/// KYC verification level.
enum KYCLevel {
  /// Light verification.
  LIGHT,

  /// Regular/full verification.
  REGULAR,
}

/// Type of legal entity.
enum LegalPersonType {
  /// Business entity.
  BUSINESS,

  /// Non-profit organization.
  ORGANIZATION,

  /// Sole trader/proprietor.
  SOLETRADER,

  /// Partnership.
  PARTNERSHIP,
}

/// User capacity declaration for risk assessment.
enum Capacity {
  /// Unknown capacity.
  UNKNOWN,

  /// Regular customer.
  NORMAL,

  /// Declarative capacity.
  DECLARATIVE,
}

/// Base user properties shared by all user types.
abstract class User {
  /// Creates a base user.
  const User({
    required this.id,
    required this.personType,
    this.email,
    this.kycLevel,
    this.tag,
    this.creationDate,
  });

  /// Unique user identifier.
  final String id;

  /// Type of person (NATURAL or LEGAL).
  final PersonType personType;

  /// User email address.
  final String? email;

  /// Current KYC verification level.
  final KYCLevel? kycLevel;

  /// Custom tag/reference.
  final String? tag;

  /// Unix timestamp of creation.
  final int? creationDate;
}

/// Natural (individual) user.
///
/// Represents a physical person with personal information.
///
/// ```dart
/// final user = await fam.users.createNatural(
///   CreateNaturalUserRequest(
///     email: 'john@example.com',
///     firstName: 'John',
///     lastName: 'Doe',
///     birthday: 315532800, // Unix timestamp
///     nationality: 'FR',
///     countryOfResidence: 'FR',
///   ),
/// );
/// ```
class NaturalUser extends User {
  /// Creates a natural user.
  const NaturalUser({
    required super.id,
    required this.firstName,
    required this.lastName,
    super.email,
    super.kycLevel,
    super.tag,
    super.creationDate,
    this.birthday,
    this.nationality,
    this.countryOfResidence,
    this.address,
    this.occupation,
    this.incomeRange,
    this.proofOfIdentity,
    this.proofOfAddress,
    this.capacity,
  }) : super(personType: PersonType.NATURAL);

  /// Creates a NaturalUser from JSON.
  factory NaturalUser.fromJson(Map<String, Object?> json) => NaturalUser(
        id: json['Id'] as String,
        firstName: json['FirstName'] as String,
        lastName: json['LastName'] as String,
        email: json['Email'] as String?,
        kycLevel: json['KYCLevel'] != null
            ? KYCLevel.values.byName(json['KYCLevel'] as String)
            : null,
        tag: json['Tag'] as String?,
        creationDate: json['CreationDate'] as int?,
        birthday: json['Birthday'] as int?,
        nationality: json['Nationality'] as String?,
        countryOfResidence: json['CountryOfResidence'] as String?,
        address: json['Address'] != null
            ? Address.fromJson(json['Address'] as Map<String, Object?>)
            : null,
        occupation: json['Occupation'] as String?,
        incomeRange: json['IncomeRange'] as int?,
        proofOfIdentity: json['ProofOfIdentity'] as String?,
        proofOfAddress: json['ProofOfAddress'] as String?,
        capacity: json['Capacity'] != null
            ? Capacity.values.byName(json['Capacity'] as String)
            : null,
      );

  /// First name.
  final String firstName;

  /// Last name.
  final String lastName;

  /// Birthday as Unix timestamp.
  final int? birthday;

  /// Two-letter nationality code (ISO 3166-1 alpha-2).
  final String? nationality;

  /// Two-letter country of residence code.
  final String? countryOfResidence;

  /// Physical address.
  final Address? address;

  /// Occupation/profession.
  final String? occupation;

  /// Income range (1-6 scale).
  final int? incomeRange;

  /// ID of proof of identity KYC document.
  final String? proofOfIdentity;

  /// ID of proof of address KYC document.
  final String? proofOfAddress;

  /// User capacity declaration.
  final Capacity? capacity;

  /// Converts to JSON map.
  Map<String, Object?> toJson() => {
        'Id': id,
        'PersonType': personType.name,
        'FirstName': firstName,
        'LastName': lastName,
        if (email != null) 'Email': email,
        if (kycLevel != null) 'KYCLevel': kycLevel!.name,
        if (tag != null) 'Tag': tag,
        if (creationDate != null) 'CreationDate': creationDate,
        if (birthday != null) 'Birthday': birthday,
        if (nationality != null) 'Nationality': nationality,
        if (countryOfResidence != null)
          'CountryOfResidence': countryOfResidence,
        if (address != null) 'Address': address!.toJson(),
        if (occupation != null) 'Occupation': occupation,
        if (incomeRange != null) 'IncomeRange': incomeRange,
        if (proofOfIdentity != null) 'ProofOfIdentity': proofOfIdentity,
        if (proofOfAddress != null) 'ProofOfAddress': proofOfAddress,
        if (capacity != null) 'Capacity': capacity!.name,
      };

  /// Full name (first + last).
  String get fullName => '$firstName $lastName';
}

/// Legal representative information for a legal user.
class LegalRepresentative {
  /// Creates a legal representative.
  const LegalRepresentative({
    required this.firstName,
    required this.lastName,
    this.email,
    this.birthday,
    this.nationality,
    this.countryOfResidence,
    this.address,
  });

  /// Creates from JSON.
  factory LegalRepresentative.fromJson(Map<String, Object?> json) =>
      LegalRepresentative(
        firstName: json['LegalRepresentativeFirstName'] as String,
        lastName: json['LegalRepresentativeLastName'] as String,
        email: json['LegalRepresentativeEmail'] as String?,
        birthday: json['LegalRepresentativeBirthday'] as int?,
        nationality: json['LegalRepresentativeNationality'] as String?,
        countryOfResidence:
            json['LegalRepresentativeCountryOfResidence'] as String?,
        address: json['LegalRepresentativeAddress'] != null
            ? Address.fromJson(
                json['LegalRepresentativeAddress'] as Map<String, Object?>,
              )
            : null,
      );

  /// First name of the legal representative.
  final String firstName;

  /// Last name of the legal representative.
  final String lastName;

  /// Email of the legal representative.
  final String? email;

  /// Birthday as Unix timestamp.
  final int? birthday;

  /// Nationality (ISO 3166-1 alpha-2).
  final String? nationality;

  /// Country of residence (ISO 3166-1 alpha-2).
  final String? countryOfResidence;

  /// Physical address.
  final Address? address;

  /// Converts to JSON with proper field names.
  Map<String, Object?> toJson() => {
        'LegalRepresentativeFirstName': firstName,
        'LegalRepresentativeLastName': lastName,
        if (email != null) 'LegalRepresentativeEmail': email,
        if (birthday != null) 'LegalRepresentativeBirthday': birthday,
        if (nationality != null) 'LegalRepresentativeNationality': nationality,
        if (countryOfResidence != null)
          'LegalRepresentativeCountryOfResidence': countryOfResidence,
        if (address != null) 'LegalRepresentativeAddress': address!.toJson(),
      };

  /// Full name of the legal representative.
  String get fullName => '$firstName $lastName';
}

/// Legal (company) user.
///
/// Represents a business entity with legal representative.
///
/// ```dart
/// final company = await fam.users.createLegal(
///   CreateLegalUserRequest(
///     name: 'ACME Inc.',
///     legalPersonType: LegalPersonType.BUSINESS,
///     legalRepresentativeFirstName: 'John',
///     legalRepresentativeLastName: 'Doe',
///     legalRepresentativeBirthday: 315532800,
///     legalRepresentativeNationality: 'FR',
///     legalRepresentativeCountryOfResidence: 'FR',
///     email: 'contact@acme.com',
///   ),
/// );
/// ```
class LegalUser extends User {
  /// Creates a legal user.
  const LegalUser({
    required super.id,
    required this.name,
    required this.legalPersonType,
    required this.legalRepresentativeFirstName,
    required this.legalRepresentativeLastName,
    super.email,
    super.kycLevel,
    super.tag,
    super.creationDate,
    this.legalRepresentativeEmail,
    this.legalRepresentativeBirthday,
    this.legalRepresentativeNationality,
    this.legalRepresentativeCountryOfResidence,
    this.legalRepresentativeAddress,
    this.headQuartersAddress,
    this.companyNumber,
    this.proofOfRegistration,
    this.shareHolderDeclaration,
    this.statute,
  }) : super(personType: PersonType.LEGAL);

  /// Creates a LegalUser from JSON.
  factory LegalUser.fromJson(Map<String, Object?> json) => LegalUser(
        id: json['Id'] as String,
        name: json['Name'] as String,
        legalPersonType:
            LegalPersonType.values.byName(json['LegalPersonType'] as String),
        legalRepresentativeFirstName:
            json['LegalRepresentativeFirstName'] as String,
        legalRepresentativeLastName:
            json['LegalRepresentativeLastName'] as String,
        email: json['Email'] as String?,
        kycLevel: json['KYCLevel'] != null
            ? KYCLevel.values.byName(json['KYCLevel'] as String)
            : null,
        tag: json['Tag'] as String?,
        creationDate: json['CreationDate'] as int?,
        legalRepresentativeEmail: json['LegalRepresentativeEmail'] as String?,
        legalRepresentativeBirthday:
            json['LegalRepresentativeBirthday'] as int?,
        legalRepresentativeNationality:
            json['LegalRepresentativeNationality'] as String?,
        legalRepresentativeCountryOfResidence:
            json['LegalRepresentativeCountryOfResidence'] as String?,
        legalRepresentativeAddress:
            json['LegalRepresentativeAddress'] != null
                ? Address.fromJson(
                    json['LegalRepresentativeAddress'] as Map<String, Object?>,
                  )
                : null,
        headQuartersAddress: json['HeadquartersAddress'] != null
            ? Address.fromJson(
                json['HeadquartersAddress'] as Map<String, Object?>,
              )
            : null,
        companyNumber: json['CompanyNumber'] as String?,
        proofOfRegistration: json['ProofOfRegistration'] as String?,
        shareHolderDeclaration: json['ShareholderDeclaration'] as String?,
        statute: json['Statute'] as String?,
      );

  /// Company/organization name.
  final String name;

  /// Type of legal entity.
  final LegalPersonType legalPersonType;

  /// Legal representative's first name.
  final String legalRepresentativeFirstName;

  /// Legal representative's last name.
  final String legalRepresentativeLastName;

  /// Legal representative's email.
  final String? legalRepresentativeEmail;

  /// Legal representative's birthday as Unix timestamp.
  final int? legalRepresentativeBirthday;

  /// Legal representative's nationality.
  final String? legalRepresentativeNationality;

  /// Legal representative's country of residence.
  final String? legalRepresentativeCountryOfResidence;

  /// Legal representative's address.
  final Address? legalRepresentativeAddress;

  /// Company headquarters address.
  final Address? headQuartersAddress;

  /// Company registration number.
  final String? companyNumber;

  /// ID of proof of registration KYC document.
  final String? proofOfRegistration;

  /// ID of shareholder declaration document.
  final String? shareHolderDeclaration;

  /// ID of statute/articles of association document.
  final String? statute;

  /// Converts to JSON map.
  Map<String, Object?> toJson() => {
        'Id': id,
        'PersonType': personType.name,
        'Name': name,
        'LegalPersonType': legalPersonType.name,
        'LegalRepresentativeFirstName': legalRepresentativeFirstName,
        'LegalRepresentativeLastName': legalRepresentativeLastName,
        if (email != null) 'Email': email,
        if (kycLevel != null) 'KYCLevel': kycLevel!.name,
        if (tag != null) 'Tag': tag,
        if (creationDate != null) 'CreationDate': creationDate,
        if (legalRepresentativeEmail != null)
          'LegalRepresentativeEmail': legalRepresentativeEmail,
        if (legalRepresentativeBirthday != null)
          'LegalRepresentativeBirthday': legalRepresentativeBirthday,
        if (legalRepresentativeNationality != null)
          'LegalRepresentativeNationality': legalRepresentativeNationality,
        if (legalRepresentativeCountryOfResidence != null)
          'LegalRepresentativeCountryOfResidence':
              legalRepresentativeCountryOfResidence,
        if (legalRepresentativeAddress != null)
          'LegalRepresentativeAddress': legalRepresentativeAddress!.toJson(),
        if (headQuartersAddress != null)
          'HeadquartersAddress': headQuartersAddress!.toJson(),
        if (companyNumber != null) 'CompanyNumber': companyNumber,
        if (proofOfRegistration != null)
          'ProofOfRegistration': proofOfRegistration,
        if (shareHolderDeclaration != null)
          'ShareholderDeclaration': shareHolderDeclaration,
        if (statute != null) 'Statute': statute,
      };

  /// Full name of the legal representative.
  String get legalRepresentativeFullName =>
      '$legalRepresentativeFirstName $legalRepresentativeLastName';
}

/// Request to create a natural user.
class CreateNaturalUserRequest {
  /// Creates a request to create a natural user.
  const CreateNaturalUserRequest({
    required this.firstName,
    required this.lastName,
    required this.birthday,
    required this.nationality,
    required this.countryOfResidence,
    this.email,
    this.address,
    this.occupation,
    this.incomeRange,
    this.tag,
    this.termsAndConditionsAccepted,
    this.userCategory,
  });

  /// First name.
  final String firstName;

  /// Last name.
  final String lastName;

  /// Birthday as Unix timestamp.
  final int birthday;

  /// Nationality (ISO 3166-1 alpha-2).
  final String nationality;

  /// Country of residence (ISO 3166-1 alpha-2).
  final String countryOfResidence;

  /// Email address.
  final String? email;

  /// Physical address.
  final Address? address;

  /// Occupation/profession.
  final String? occupation;

  /// Income range (1-6).
  final int? incomeRange;

  /// Custom tag.
  final String? tag;

  /// Whether terms and conditions were accepted.
  final bool? termsAndConditionsAccepted;

  /// User category.
  final String? userCategory;

  /// Converts to JSON map.
  Map<String, Object?> toJson() => {
        'FirstName': firstName,
        'LastName': lastName,
        'Birthday': birthday,
        'Nationality': nationality,
        'CountryOfResidence': countryOfResidence,
        if (email != null) 'Email': email,
        if (address != null) 'Address': address!.toJson(),
        if (occupation != null) 'Occupation': occupation,
        if (incomeRange != null) 'IncomeRange': incomeRange,
        if (tag != null) 'Tag': tag,
        if (termsAndConditionsAccepted != null)
          'TermsAndConditionsAccepted': termsAndConditionsAccepted,
        if (userCategory != null) 'UserCategory': userCategory,
      };
}

/// Request to update a natural user.
class UpdateNaturalUserRequest {
  /// Creates an update request.
  const UpdateNaturalUserRequest({
    this.firstName,
    this.lastName,
    this.email,
    this.birthday,
    this.nationality,
    this.countryOfResidence,
    this.address,
    this.occupation,
    this.incomeRange,
    this.tag,
  });

  /// First name.
  final String? firstName;

  /// Last name.
  final String? lastName;

  /// Email address.
  final String? email;

  /// Birthday as Unix timestamp.
  final int? birthday;

  /// Nationality (ISO 3166-1 alpha-2).
  final String? nationality;

  /// Country of residence (ISO 3166-1 alpha-2).
  final String? countryOfResidence;

  /// Physical address.
  final Address? address;

  /// Occupation.
  final String? occupation;

  /// Income range (1-6).
  final int? incomeRange;

  /// Custom tag.
  final String? tag;

  /// Converts to JSON map.
  Map<String, Object?> toJson() => {
        if (firstName != null) 'FirstName': firstName,
        if (lastName != null) 'LastName': lastName,
        if (email != null) 'Email': email,
        if (birthday != null) 'Birthday': birthday,
        if (nationality != null) 'Nationality': nationality,
        if (countryOfResidence != null)
          'CountryOfResidence': countryOfResidence,
        if (address != null) 'Address': address!.toJson(),
        if (occupation != null) 'Occupation': occupation,
        if (incomeRange != null) 'IncomeRange': incomeRange,
        if (tag != null) 'Tag': tag,
      };
}

/// Request to create a legal user.
class CreateLegalUserRequest {
  /// Creates a request to create a legal user.
  const CreateLegalUserRequest({
    required this.name,
    required this.legalPersonType,
    required this.legalRepresentativeFirstName,
    required this.legalRepresentativeLastName,
    required this.legalRepresentativeBirthday,
    required this.legalRepresentativeNationality,
    required this.legalRepresentativeCountryOfResidence,
    this.email,
    this.legalRepresentativeEmail,
    this.legalRepresentativeAddress,
    this.headQuartersAddress,
    this.companyNumber,
    this.tag,
    this.termsAndConditionsAccepted,
    this.userCategory,
  });

  /// Company name.
  final String name;

  /// Type of legal entity.
  final LegalPersonType legalPersonType;

  /// Legal representative's first name.
  final String legalRepresentativeFirstName;

  /// Legal representative's last name.
  final String legalRepresentativeLastName;

  /// Legal representative's birthday as Unix timestamp.
  final int legalRepresentativeBirthday;

  /// Legal representative's nationality.
  final String legalRepresentativeNationality;

  /// Legal representative's country of residence.
  final String legalRepresentativeCountryOfResidence;

  /// Company email.
  final String? email;

  /// Legal representative's email.
  final String? legalRepresentativeEmail;

  /// Legal representative's address.
  final Address? legalRepresentativeAddress;

  /// Headquarters address.
  final Address? headQuartersAddress;

  /// Company registration number.
  final String? companyNumber;

  /// Custom tag.
  final String? tag;

  /// Whether terms and conditions were accepted.
  final bool? termsAndConditionsAccepted;

  /// User category.
  final String? userCategory;

  /// Converts to JSON map.
  Map<String, Object?> toJson() => {
        'Name': name,
        'LegalPersonType': legalPersonType.name,
        'LegalRepresentativeFirstName': legalRepresentativeFirstName,
        'LegalRepresentativeLastName': legalRepresentativeLastName,
        'LegalRepresentativeBirthday': legalRepresentativeBirthday,
        'LegalRepresentativeNationality': legalRepresentativeNationality,
        'LegalRepresentativeCountryOfResidence':
            legalRepresentativeCountryOfResidence,
        if (email != null) 'Email': email,
        if (legalRepresentativeEmail != null)
          'LegalRepresentativeEmail': legalRepresentativeEmail,
        if (legalRepresentativeAddress != null)
          'LegalRepresentativeAddress': legalRepresentativeAddress!.toJson(),
        if (headQuartersAddress != null)
          'HeadquartersAddress': headQuartersAddress!.toJson(),
        if (companyNumber != null) 'CompanyNumber': companyNumber,
        if (tag != null) 'Tag': tag,
        if (termsAndConditionsAccepted != null)
          'TermsAndConditionsAccepted': termsAndConditionsAccepted,
        if (userCategory != null) 'UserCategory': userCategory,
      };
}

/// Request to update a legal user.
class UpdateLegalUserRequest {
  /// Creates an update request.
  const UpdateLegalUserRequest({
    this.name,
    this.legalPersonType,
    this.email,
    this.legalRepresentativeFirstName,
    this.legalRepresentativeLastName,
    this.legalRepresentativeEmail,
    this.legalRepresentativeBirthday,
    this.legalRepresentativeNationality,
    this.legalRepresentativeCountryOfResidence,
    this.legalRepresentativeAddress,
    this.headQuartersAddress,
    this.companyNumber,
    this.tag,
  });

  /// Company name.
  final String? name;

  /// Type of legal entity.
  final LegalPersonType? legalPersonType;

  /// Company email.
  final String? email;

  /// Legal representative's first name.
  final String? legalRepresentativeFirstName;

  /// Legal representative's last name.
  final String? legalRepresentativeLastName;

  /// Legal representative's email.
  final String? legalRepresentativeEmail;

  /// Legal representative's birthday.
  final int? legalRepresentativeBirthday;

  /// Legal representative's nationality.
  final String? legalRepresentativeNationality;

  /// Legal representative's country of residence.
  final String? legalRepresentativeCountryOfResidence;

  /// Legal representative's address.
  final Address? legalRepresentativeAddress;

  /// Headquarters address.
  final Address? headQuartersAddress;

  /// Company registration number.
  final String? companyNumber;

  /// Custom tag.
  final String? tag;

  /// Converts to JSON map.
  Map<String, Object?> toJson() => {
        if (name != null) 'Name': name,
        if (legalPersonType != null) 'LegalPersonType': legalPersonType!.name,
        if (email != null) 'Email': email,
        if (legalRepresentativeFirstName != null)
          'LegalRepresentativeFirstName': legalRepresentativeFirstName,
        if (legalRepresentativeLastName != null)
          'LegalRepresentativeLastName': legalRepresentativeLastName,
        if (legalRepresentativeEmail != null)
          'LegalRepresentativeEmail': legalRepresentativeEmail,
        if (legalRepresentativeBirthday != null)
          'LegalRepresentativeBirthday': legalRepresentativeBirthday,
        if (legalRepresentativeNationality != null)
          'LegalRepresentativeNationality': legalRepresentativeNationality,
        if (legalRepresentativeCountryOfResidence != null)
          'LegalRepresentativeCountryOfResidence':
              legalRepresentativeCountryOfResidence,
        if (legalRepresentativeAddress != null)
          'LegalRepresentativeAddress': legalRepresentativeAddress!.toJson(),
        if (headQuartersAddress != null)
          'HeadquartersAddress': headQuartersAddress!.toJson(),
        if (companyNumber != null) 'CompanyNumber': companyNumber,
        if (tag != null) 'Tag': tag,
      };
}

/// Parses a user from JSON, returning the appropriate type.
User parseUser(Map<String, Object?> json) {
  final personType = json['PersonType'] as String;
  if (personType == PersonType.NATURAL.name) {
    return NaturalUser.fromJson(json);
  }
  return LegalUser.fromJson(json);
}
