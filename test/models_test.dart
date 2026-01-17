import 'package:fam_sdk/fam_sdk.dart';
import 'package:test/test.dart';

void main() {
  group('NaturalUser', () {
    test('should create from JSON', () {
      final json = {
        'Id': 'user_123',
        'PersonType': 'NATURAL',
        'FirstName': 'John',
        'LastName': 'Doe',
        'Email': 'john@example.com',
        'Birthday': 631152000,
        'Nationality': 'FR',
        'CountryOfResidence': 'FR',
        'KYCLevel': 'REGULAR',
        'CreationDate': 1704067200,
        'Tag': 'test-user',
      };

      final user = NaturalUser.fromJson(json);

      expect(user.id, 'user_123');
      expect(user.firstName, 'John');
      expect(user.lastName, 'Doe');
      expect(user.email, 'john@example.com');
      expect(user.birthday, 631152000);
      expect(user.nationality, 'FR');
      expect(user.countryOfResidence, 'FR');
      expect(user.kycLevel, KYCLevel.REGULAR);
      expect(user.tag, 'test-user');
      expect(user.personType, PersonType.NATURAL);
    });

    test('should compute fullName', () {
      const user = NaturalUser(
        id: 'user_123',
        firstName: 'John',
        lastName: 'Doe',
      );

      expect(user.fullName, 'John Doe');
    });

    test('should serialize to JSON', () {
      const user = NaturalUser(
        id: 'user_123',
        firstName: 'John',
        lastName: 'Doe',
        email: 'john@example.com',
        nationality: 'FR',
      );

      final json = user.toJson();

      expect(json['Id'], 'user_123');
      expect(json['FirstName'], 'John');
      expect(json['LastName'], 'Doe');
      expect(json['Email'], 'john@example.com');
      expect(json['Nationality'], 'FR');
      expect(json['PersonType'], 'NATURAL');
    });

    test('should handle null optional fields', () {
      final json = {
        'Id': 'user_456',
        'PersonType': 'NATURAL',
        'FirstName': 'Jane',
        'LastName': 'Smith',
      };

      final user = NaturalUser.fromJson(json);

      expect(user.email, isNull);
      expect(user.birthday, isNull);
      expect(user.address, isNull);
      expect(user.kycLevel, isNull);
    });

    test('should parse address', () {
      final json = {
        'Id': 'user_789',
        'PersonType': 'NATURAL',
        'FirstName': 'Alice',
        'LastName': 'Brown',
        'Address': {
          'AddressLine1': '123 Main St',
          'City': 'Paris',
          'PostalCode': '75001',
          'Country': 'FR',
        },
      };

      final user = NaturalUser.fromJson(json);

      expect(user.address, isNotNull);
      expect(user.address!.addressLine1, '123 Main St');
      expect(user.address!.city, 'Paris');
      expect(user.address!.country, 'FR');
    });
  });

  group('LegalUser', () {
    test('should create from JSON', () {
      final json = {
        'Id': 'company_123',
        'PersonType': 'LEGAL',
        'Name': 'ACME Inc.',
        'LegalPersonType': 'BUSINESS',
        'LegalRepresentativeFirstName': 'John',
        'LegalRepresentativeLastName': 'Doe',
        'Email': 'contact@acme.com',
        'CompanyNumber': '123456789',
        'KYCLevel': 'LIGHT',
      };

      final user = LegalUser.fromJson(json);

      expect(user.id, 'company_123');
      expect(user.name, 'ACME Inc.');
      expect(user.legalPersonType, LegalPersonType.BUSINESS);
      expect(user.legalRepresentativeFirstName, 'John');
      expect(user.legalRepresentativeLastName, 'Doe');
      expect(user.email, 'contact@acme.com');
      expect(user.companyNumber, '123456789');
      expect(user.personType, PersonType.LEGAL);
    });

    test('should compute legalRepresentativeFullName', () {
      const user = LegalUser(
        id: 'company_123',
        name: 'ACME Inc.',
        legalPersonType: LegalPersonType.BUSINESS,
        legalRepresentativeFirstName: 'John',
        legalRepresentativeLastName: 'Doe',
      );

      expect(user.legalRepresentativeFullName, 'John Doe');
    });

    test('should serialize to JSON', () {
      const user = LegalUser(
        id: 'company_123',
        name: 'ACME Inc.',
        legalPersonType: LegalPersonType.ORGANIZATION,
        legalRepresentativeFirstName: 'Jane',
        legalRepresentativeLastName: 'Smith',
        email: 'contact@acme.com',
      );

      final json = user.toJson();

      expect(json['Id'], 'company_123');
      expect(json['Name'], 'ACME Inc.');
      expect(json['LegalPersonType'], 'ORGANIZATION');
      expect(json['LegalRepresentativeFirstName'], 'Jane');
      expect(json['LegalRepresentativeLastName'], 'Smith');
      expect(json['PersonType'], 'LEGAL');
    });
  });

  group('CreateNaturalUserRequest', () {
    test('should serialize to JSON', () {
      const request = CreateNaturalUserRequest(
        firstName: 'John',
        lastName: 'Doe',
        birthday: 631152000,
        nationality: 'FR',
        countryOfResidence: 'FR',
        email: 'john@example.com',
        tag: 'test',
      );

      final json = request.toJson();

      expect(json['FirstName'], 'John');
      expect(json['LastName'], 'Doe');
      expect(json['Birthday'], 631152000);
      expect(json['Nationality'], 'FR');
      expect(json['CountryOfResidence'], 'FR');
      expect(json['Email'], 'john@example.com');
      expect(json['Tag'], 'test');
    });

    test('should omit null optional fields', () {
      const request = CreateNaturalUserRequest(
        firstName: 'John',
        lastName: 'Doe',
        birthday: 631152000,
        nationality: 'FR',
        countryOfResidence: 'FR',
      );

      final json = request.toJson();

      expect(json.containsKey('Email'), isFalse);
      expect(json.containsKey('Tag'), isFalse);
      expect(json.containsKey('Address'), isFalse);
    });
  });

  group('CreateLegalUserRequest', () {
    test('should serialize to JSON', () {
      const request = CreateLegalUserRequest(
        name: 'ACME Inc.',
        legalPersonType: LegalPersonType.BUSINESS,
        legalRepresentativeFirstName: 'John',
        legalRepresentativeLastName: 'Doe',
        legalRepresentativeBirthday: 631152000,
        legalRepresentativeNationality: 'FR',
        legalRepresentativeCountryOfResidence: 'FR',
        email: 'contact@acme.com',
      );

      final json = request.toJson();

      expect(json['Name'], 'ACME Inc.');
      expect(json['LegalPersonType'], 'BUSINESS');
      expect(json['LegalRepresentativeFirstName'], 'John');
      expect(json['LegalRepresentativeLastName'], 'Doe');
      expect(json['Email'], 'contact@acme.com');
    });
  });

  group('parseUser', () {
    test('should parse natural user', () {
      final json = {
        'Id': 'user_123',
        'PersonType': 'NATURAL',
        'FirstName': 'John',
        'LastName': 'Doe',
      };

      final user = parseUser(json);

      expect(user, isA<NaturalUser>());
      expect(user.personType, PersonType.NATURAL);
    });

    test('should parse legal user', () {
      final json = {
        'Id': 'company_123',
        'PersonType': 'LEGAL',
        'Name': 'ACME Inc.',
        'LegalPersonType': 'BUSINESS',
        'LegalRepresentativeFirstName': 'John',
        'LegalRepresentativeLastName': 'Doe',
      };

      final user = parseUser(json);

      expect(user, isA<LegalUser>());
      expect(user.personType, PersonType.LEGAL);
    });
  });

  group('Wallet', () {
    test('should create from JSON', () {
      final json = {
        'Id': 'wallet_123',
        'Owners': ['user_123'],
        'Description': 'Main Wallet',
        'Balance': {'Amount': 10000, 'Currency': 'EUR'},
        'Currency': 'EUR',
        'FundsType': 'DEFAULT',
        'CreationDate': 1704067200,
      };

      final wallet = Wallet.fromJson(json);

      expect(wallet.id, 'wallet_123');
      expect(wallet.owners, ['user_123']);
      expect(wallet.description, 'Main Wallet');
      expect(wallet.balance.amount, 10000);
      expect(wallet.balance.currency, Currency.EUR);
      expect(wallet.currency, Currency.EUR);
      expect(wallet.fundsType, FundsType.DEFAULT);
    });

    test('should serialize to JSON', () {
      const wallet = Wallet(
        id: 'wallet_456',
        owners: ['user_456'],
        description: 'Test Wallet',
        balance: Money(amount: 5000, currency: Currency.USD),
        currency: Currency.USD,
        tag: 'test',
      );

      final json = wallet.toJson();

      expect(json['Id'], 'wallet_456');
      expect(json['Owners'], ['user_456']);
      expect(json['Description'], 'Test Wallet');
      expect(json['Currency'], 'USD');
      expect(json['Tag'], 'test');
    });

    test('should default FundsType to DEFAULT', () {
      final json = {
        'Id': 'wallet_789',
        'Owners': ['user_789'],
        'Description': 'Another Wallet',
        'Balance': {'Amount': 0, 'Currency': 'GBP'},
        'Currency': 'GBP',
      };

      final wallet = Wallet.fromJson(json);

      expect(wallet.fundsType, FundsType.DEFAULT);
    });
  });

  group('CreateWalletRequest', () {
    test('should serialize to JSON', () {
      const request = CreateWalletRequest(
        owners: ['user_123', 'user_456'],
        description: 'Shared Wallet',
        currency: Currency.EUR,
        tag: 'shared',
      );

      final json = request.toJson();

      expect(json['Owners'], ['user_123', 'user_456']);
      expect(json['Description'], 'Shared Wallet');
      expect(json['Currency'], 'EUR');
      expect(json['Tag'], 'shared');
    });
  });

  group('WalletTransaction', () {
    test('should create from JSON', () {
      final json = {
        'Id': 'tx_123',
        'Type': 'PAYIN',
        'Nature': 'REGULAR',
        'Status': 'SUCCEEDED',
        'AuthorId': 'user_123',
        'DebitedFunds': {'Amount': 1000, 'Currency': 'EUR'},
        'CreditedFunds': {'Amount': 1000, 'Currency': 'EUR'},
        'Fees': {'Amount': 0, 'Currency': 'EUR'},
        'CreditedWalletId': 'wallet_123',
      };

      final tx = WalletTransaction.fromJson(json);

      expect(tx.id, 'tx_123');
      expect(tx.type, WalletTransactionType.PAYIN);
      expect(tx.nature, TransactionNature.REGULAR);
      expect(tx.status, TransactionStatus.SUCCEEDED);
      expect(tx.authorId, 'user_123');
      expect(tx.debitedFunds.amount, 1000);
      expect(tx.creditedWalletId, 'wallet_123');
    });
  });

  group('LegalPersonType', () {
    test('should have all types', () {
      expect(LegalPersonType.values, contains(LegalPersonType.BUSINESS));
      expect(LegalPersonType.values, contains(LegalPersonType.ORGANIZATION));
      expect(LegalPersonType.values, contains(LegalPersonType.SOLETRADER));
      expect(LegalPersonType.values, contains(LegalPersonType.PARTNERSHIP));
    });
  });

  group('KYCLevel', () {
    test('should have all levels', () {
      expect(KYCLevel.values, contains(KYCLevel.LIGHT));
      expect(KYCLevel.values, contains(KYCLevel.REGULAR));
    });
  });

  group('WalletStatus', () {
    test('should have all statuses', () {
      expect(WalletStatus.values, contains(WalletStatus.CREATED));
      expect(WalletStatus.values, contains(WalletStatus.CLOSED));
    });
  });

  group('FundsType', () {
    test('should have all types', () {
      expect(FundsType.values, contains(FundsType.DEFAULT));
      expect(FundsType.values, contains(FundsType.FEES));
      expect(FundsType.values, contains(FundsType.CREDIT));
    });
  });
}
