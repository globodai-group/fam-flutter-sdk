import 'package:fam_sdk/fam_sdk.dart';
import 'package:test/test.dart';

void main() {
  group('Currency', () {
    test('should have all major currencies', () {
      expect(Currency.values, contains(Currency.EUR));
      expect(Currency.values, contains(Currency.USD));
      expect(Currency.values, contains(Currency.GBP));
      expect(Currency.values, contains(Currency.CHF));
    });
  });

  group('Money', () {
    test('should create with amount and currency', () {
      const money = Money(amount: 1000, currency: Currency.EUR);
      expect(money.amount, 1000);
      expect(money.currency, Currency.EUR);
    });

    test('should serialize to JSON', () {
      const money = Money(amount: 2500, currency: Currency.USD);
      final json = money.toJson();
      expect(json['Amount'], 2500);
      expect(json['Currency'], 'USD');
    });

    test('should deserialize from JSON', () {
      final json = {'Amount': 5000, 'Currency': 'GBP'};
      final money = Money.fromJson(json);
      expect(money.amount, 5000);
      expect(money.currency, Currency.GBP);
    });

    test('should format correctly', () {
      const money = Money(amount: 1234, currency: Currency.EUR);
      expect(money.format(), '12.34 EUR');
    });

    test('should format zero correctly', () {
      const money = Money(amount: 0, currency: Currency.USD);
      expect(money.format(), '0.00 USD');
    });

    test('should implement equality', () {
      const money1 = Money(amount: 100, currency: Currency.EUR);
      const money2 = Money(amount: 100, currency: Currency.EUR);
      const money3 = Money(amount: 100, currency: Currency.USD);
      const money4 = Money(amount: 200, currency: Currency.EUR);

      expect(money1, equals(money2));
      expect(money1, isNot(equals(money3)));
      expect(money1, isNot(equals(money4)));
    });

    test('should have consistent hashCode', () {
      const money1 = Money(amount: 100, currency: Currency.EUR);
      const money2 = Money(amount: 100, currency: Currency.EUR);
      expect(money1.hashCode, equals(money2.hashCode));
    });
  });

  group('Address', () {
    test('should create with all fields', () {
      const address = Address(
        addressLine1: '123 Main St',
        addressLine2: 'Apt 4B',
        city: 'Paris',
        region: 'Ile-de-France',
        postalCode: '75001',
        country: 'FR',
      );

      expect(address.addressLine1, '123 Main St');
      expect(address.addressLine2, 'Apt 4B');
      expect(address.city, 'Paris');
      expect(address.region, 'Ile-de-France');
      expect(address.postalCode, '75001');
      expect(address.country, 'FR');
    });

    test('should allow null fields', () {
      const address = Address(
        addressLine1: '123 Main St',
        city: 'Paris',
        country: 'FR',
      );

      expect(address.addressLine2, isNull);
      expect(address.region, isNull);
      expect(address.postalCode, isNull);
    });

    test('should serialize to JSON', () {
      const address = Address(
        addressLine1: '123 Main St',
        city: 'Paris',
        country: 'FR',
      );

      final json = address.toJson();
      expect(json['AddressLine1'], '123 Main St');
      expect(json['City'], 'Paris');
      expect(json['Country'], 'FR');
      expect(json.containsKey('AddressLine2'), isFalse);
    });

    test('should deserialize from JSON', () {
      final json = {
        'AddressLine1': '456 Oak Ave',
        'City': 'London',
        'PostalCode': 'SW1A 1AA',
        'Country': 'GB',
      };

      final address = Address.fromJson(json);
      expect(address.addressLine1, '456 Oak Ave');
      expect(address.city, 'London');
      expect(address.postalCode, 'SW1A 1AA');
      expect(address.country, 'GB');
    });

    test('should format toString correctly', () {
      const address = Address(
        addressLine1: '123 Main St',
        city: 'Paris',
        postalCode: '75001',
        country: 'FR',
      );

      final str = address.toString();
      expect(str, contains('123 Main St'));
      expect(str, contains('Paris'));
      expect(str, contains('75001'));
      expect(str, contains('FR'));
    });

    test('should implement equality', () {
      const address1 = Address(addressLine1: '123 Main', country: 'FR');
      const address2 = Address(addressLine1: '123 Main', country: 'FR');
      const address3 = Address(addressLine1: '456 Other', country: 'FR');

      expect(address1, equals(address2));
      expect(address1, isNot(equals(address3)));
    });
  });

  group('TransactionStatus', () {
    test('should have all statuses', () {
      expect(TransactionStatus.values, contains(TransactionStatus.CREATED));
      expect(TransactionStatus.values, contains(TransactionStatus.SUCCEEDED));
      expect(TransactionStatus.values, contains(TransactionStatus.FAILED));
    });
  });

  group('TransactionNature', () {
    test('should have all natures', () {
      expect(TransactionNature.values, contains(TransactionNature.REGULAR));
      expect(TransactionNature.values, contains(TransactionNature.REFUND));
      expect(TransactionNature.values, contains(TransactionNature.REPUDIATION));
      expect(TransactionNature.values, contains(TransactionNature.SETTLEMENT));
    });
  });

  group('PaginationParams', () {
    test('should create with all params', () {
      const params = PaginationParams(
        page: 2,
        perPage: 25,
        sort: 'createdAt',
        order: SortOrder.desc,
      );

      expect(params.page, 2);
      expect(params.perPage, 25);
      expect(params.sort, 'createdAt');
      expect(params.order, SortOrder.desc);
    });

    test('should convert to query params', () {
      const params = PaginationParams(
        page: 1,
        perPage: 10,
        sort: 'name',
        order: SortOrder.asc,
      );

      final query = params.toQueryParams();
      expect(query['page'], '1');
      expect(query['per_page'], '10');
      expect(query['sort'], 'name');
      expect(query['order'], 'asc');
    });

    test('should omit null params', () {
      const params = PaginationParams(page: 1);
      final query = params.toQueryParams();

      expect(query.containsKey('page'), isTrue);
      expect(query.containsKey('per_page'), isFalse);
      expect(query.containsKey('sort'), isFalse);
      expect(query.containsKey('order'), isFalse);
    });
  });

  group('PaginatedResponse', () {
    test('should create from JSON', () {
      final json = {
        'data': [
          {'Id': '1', 'Name': 'Item 1'},
          {'Id': '2', 'Name': 'Item 2'},
        ],
        'meta': {
          'total': 50,
          'per_page': 10,
          'current_page': 1,
          'last_page': 5,
          'from': 1,
          'to': 10,
        },
      };

      final response = PaginatedResponse.fromJson(
        json,
        (item) => item['Name'] as String,
      );

      expect(response.data, ['Item 1', 'Item 2']);
      expect(response.total, 50);
      expect(response.perPage, 10);
      expect(response.currentPage, 1);
      expect(response.lastPage, 5);
      expect(response.from, 1);
      expect(response.to, 10);
    });

    test('should compute hasNextPage correctly', () {
      const response1 = PaginatedResponse(
        data: <String>[],
        total: 50,
        perPage: 10,
        currentPage: 1,
        lastPage: 5,
        from: 1,
        to: 10,
      );

      const response2 = PaginatedResponse(
        data: <String>[],
        total: 50,
        perPage: 10,
        currentPage: 5,
        lastPage: 5,
        from: 41,
        to: 50,
      );

      expect(response1.hasNextPage, isTrue);
      expect(response2.hasNextPage, isFalse);
    });

    test('should compute hasPreviousPage correctly', () {
      const response1 = PaginatedResponse(
        data: <String>[],
        total: 50,
        perPage: 10,
        currentPage: 1,
        lastPage: 5,
        from: 1,
        to: 10,
      );

      const response2 = PaginatedResponse(
        data: <String>[],
        total: 50,
        perPage: 10,
        currentPage: 3,
        lastPage: 5,
        from: 21,
        to: 30,
      );

      expect(response1.hasPreviousPage, isFalse);
      expect(response2.hasPreviousPage, isTrue);
    });
  });

  group('BrowserInfo', () {
    test('should create with all fields', () {
      const info = BrowserInfo(
        acceptHeader: 'text/html',
        javaEnabled: false,
        language: 'en-US',
        colorDepth: 24,
        screenHeight: 1080,
        screenWidth: 1920,
        timeZoneOffset: -60,
        userAgent: 'Mozilla/5.0',
        javascriptEnabled: true,
      );

      expect(info.acceptHeader, 'text/html');
      expect(info.javaEnabled, isFalse);
      expect(info.language, 'en-US');
      expect(info.colorDepth, 24);
      expect(info.screenHeight, 1080);
      expect(info.screenWidth, 1920);
      expect(info.timeZoneOffset, -60);
      expect(info.userAgent, 'Mozilla/5.0');
      expect(info.javascriptEnabled, isTrue);
    });

    test('should serialize to JSON', () {
      const info = BrowserInfo(
        acceptHeader: 'text/html',
        javaEnabled: false,
        language: 'fr-FR',
        colorDepth: 32,
        screenHeight: 768,
        screenWidth: 1024,
        timeZoneOffset: 60,
        userAgent: 'TestAgent',
      );

      final json = info.toJson();
      expect(json['AcceptHeader'], 'text/html');
      expect(json['JavaEnabled'], false);
      expect(json['Language'], 'fr-FR');
      expect(json['ColorDepth'], 32);
      expect(json['ScreenHeight'], 768);
      expect(json['ScreenWidth'], 1024);
      expect(json['TimeZoneOffset'], 60);
      expect(json['UserAgent'], 'TestAgent');
      expect(json['JavascriptEnabled'], true);
    });
  });
}
