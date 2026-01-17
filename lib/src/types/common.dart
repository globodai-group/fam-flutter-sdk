/// Common types used across the FAM SDK.
///
/// Provides fundamental types for money, addresses, pagination,
/// and transaction processing.
library;

/// Supported currencies for FAM transactions.
///
/// Based on ISO 4217 currency codes.
enum Currency {
  /// Euro
  EUR,

  /// US Dollar
  USD,

  /// British Pound
  GBP,

  /// Swiss Franc
  CHF,

  /// Canadian Dollar
  CAD,

  /// Australian Dollar
  AUD,

  /// Japanese Yen
  JPY,

  /// Polish Zloty
  PLN,

  /// Swedish Krona
  SEK,

  /// Norwegian Krone
  NOK,

  /// Danish Krone
  DKK,
}

/// Represents a monetary amount with currency.
///
/// Amounts are stored in the smallest currency unit (e.g., cents for EUR/USD).
///
/// ```dart
/// final price = Money(amount: 1000, currency: Currency.EUR);
/// print(price); // "10.00 EUR"
/// ```
class Money {
  /// Creates a new Money instance.
  const Money({
    required this.amount,
    required this.currency,
  });

  /// Creates a Money instance from a JSON map.
  factory Money.fromJson(Map<String, Object?> json) => Money(
        amount: json['Amount'] as int,
        currency: Currency.values.byName(json['Currency'] as String),
      );

  /// Amount in smallest currency unit (e.g., cents).
  final int amount;

  /// Currency of the amount.
  final Currency currency;

  /// Converts to JSON map.
  Map<String, Object?> toJson() => {
        'Amount': amount,
        'Currency': currency.name,
      };

  /// Formats the amount for display.
  ///
  /// Returns a string like "10.00 EUR" or "1,234.56 USD".
  String format() {
    final decimal = amount / 100;
    return '${decimal.toStringAsFixed(2)} ${currency.name}';
  }

  @override
  String toString() => format();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Money && amount == other.amount && currency == other.currency;

  @override
  int get hashCode => Object.hash(amount, currency);
}

/// Physical or postal address.
///
/// Used for user addresses, bank account owner addresses,
/// and delivery addresses.
class Address {
  /// Creates a new Address instance.
  const Address({
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.region,
    this.postalCode,
    this.country,
  });

  /// Creates an Address from a JSON map.
  factory Address.fromJson(Map<String, Object?> json) => Address(
        addressLine1: json['AddressLine1'] as String?,
        addressLine2: json['AddressLine2'] as String?,
        city: json['City'] as String?,
        region: json['Region'] as String?,
        postalCode: json['PostalCode'] as String?,
        country: json['Country'] as String?,
      );

  /// Primary address line (street, number).
  final String? addressLine1;

  /// Secondary address line (apartment, suite).
  final String? addressLine2;

  /// City name.
  final String? city;

  /// State, province, or region.
  final String? region;

  /// Postal or ZIP code.
  final String? postalCode;

  /// Two-letter ISO 3166-1 alpha-2 country code.
  final String? country;

  /// Converts to JSON map.
  Map<String, Object?> toJson() => {
        if (addressLine1 != null) 'AddressLine1': addressLine1,
        if (addressLine2 != null) 'AddressLine2': addressLine2,
        if (city != null) 'City': city,
        if (region != null) 'Region': region,
        if (postalCode != null) 'PostalCode': postalCode,
        if (country != null) 'Country': country,
      };

  @override
  String toString() {
    final parts = <String>[
      if (addressLine1 != null) addressLine1!,
      if (addressLine2 != null) addressLine2!,
      if (city != null) city!,
      if (region != null) region!,
      if (postalCode != null) postalCode!,
      if (country != null) country!,
    ];
    return parts.join(', ');
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Address &&
          addressLine1 == other.addressLine1 &&
          addressLine2 == other.addressLine2 &&
          city == other.city &&
          region == other.region &&
          postalCode == other.postalCode &&
          country == other.country;

  @override
  int get hashCode => Object.hash(
        addressLine1,
        addressLine2,
        city,
        region,
        postalCode,
        country,
      );
}

/// Transaction status for payments, transfers, and payouts.
enum TransactionStatus {
  /// Transaction has been created but not yet processed.
  CREATED,

  /// Transaction completed successfully.
  SUCCEEDED,

  /// Transaction failed.
  FAILED,
}

/// Nature of a transaction.
enum TransactionNature {
  /// Standard transaction.
  REGULAR,

  /// Refund of a previous transaction.
  REFUND,

  /// Chargeback/dispute.
  REPUDIATION,

  /// Settlement transaction.
  SETTLEMENT,
}

/// Execution type for payments.
enum ExecutionType {
  /// Web-based payment flow.
  WEB,

  /// Direct API payment.
  DIRECT,

  /// External instruction (e.g., bank wire).
  // ignore: constant_identifier_names
  EXTERNAL_INSTRUCTION,
}

/// 3D Secure mode for card payments.
enum SecureMode {
  /// Use 3DS if required by card.
  DEFAULT,

  /// Force 3DS authentication.
  FORCE,

  /// No choice (for specific cards).
  // ignore: constant_identifier_names
  NO_CHOICE,
}

/// Parameters for paginated API requests.
///
/// ```dart
/// final params = PaginationParams(page: 2, perPage: 25);
/// final wallets = await fam.users.getWallets('user_123', params: params);
/// ```
class PaginationParams {
  /// Creates new pagination parameters.
  const PaginationParams({
    this.page,
    this.perPage,
    this.sort,
    this.order,
  });

  /// Page number (1-indexed).
  final int? page;

  /// Items per page.
  final int? perPage;

  /// Field to sort by.
  final String? sort;

  /// Sort order.
  final SortOrder? order;

  /// Converts to query parameters map.
  Map<String, String> toQueryParams() => {
        if (page != null) 'page': page.toString(),
        if (perPage != null) 'per_page': perPage.toString(),
        if (sort != null) 'sort': sort!,
        if (order != null) 'order': order!.name,
      };
}

/// Sort order for paginated results.
enum SortOrder {
  /// Ascending order.
  asc,

  /// Descending order.
  desc,
}

/// Paginated response wrapper.
///
/// Contains the data items and pagination metadata.
///
/// ```dart
/// final response = await fam.users.getWallets('user_123');
/// print('Page ${response.currentPage} of ${response.lastPage}');
/// for (final wallet in response.data) {
///   print(wallet.id);
/// }
/// ```
class PaginatedResponse<T> {
  /// Creates a new paginated response.
  const PaginatedResponse({
    required this.data,
    required this.total,
    required this.perPage,
    required this.currentPage,
    required this.lastPage,
    required this.from,
    required this.to,
  });

  /// Creates a paginated response from JSON.
  ///
  /// The [itemFromJson] function converts each item in the data array.
  factory PaginatedResponse.fromJson(
    Map<String, Object?> json,
    T Function(Map<String, Object?>) itemFromJson,
  ) {
    final meta = json['meta'] as Map<String, Object?>? ?? json;
    final dataList = json['data'] as List<Object?>? ?? [];

    return PaginatedResponse(
      data: dataList
          .cast<Map<String, Object?>>()
          .map(itemFromJson)
          .toList(growable: false),
      total: meta['total'] as int? ?? 0,
      perPage: meta['per_page'] as int? ?? 10,
      currentPage: meta['current_page'] as int? ?? 1,
      lastPage: meta['last_page'] as int? ?? 1,
      from: meta['from'] as int? ?? 0,
      to: meta['to'] as int? ?? 0,
    );
  }

  /// The data items for this page.
  final List<T> data;

  /// Total number of items across all pages.
  final int total;

  /// Number of items per page.
  final int perPage;

  /// Current page number.
  final int currentPage;

  /// Total number of pages.
  final int lastPage;

  /// Index of first item on this page.
  final int from;

  /// Index of last item on this page.
  final int to;

  /// Whether there is a next page.
  bool get hasNextPage => currentPage < lastPage;

  /// Whether there is a previous page.
  bool get hasPreviousPage => currentPage > 1;
}

/// Browser information for 3D Secure authentication.
///
/// Required for card payments that may require 3DS.
class BrowserInfo {
  /// Creates new browser info.
  const BrowserInfo({
    required this.acceptHeader,
    required this.javaEnabled,
    required this.language,
    required this.colorDepth,
    required this.screenHeight,
    required this.screenWidth,
    required this.timeZoneOffset,
    required this.userAgent,
    this.javascriptEnabled = true,
  });

  /// HTTP Accept header value.
  final String acceptHeader;

  /// Whether Java is enabled.
  final bool javaEnabled;

  /// Browser language (e.g., "en-US").
  final String language;

  /// Screen color depth in bits.
  final int colorDepth;

  /// Screen height in pixels.
  final int screenHeight;

  /// Screen width in pixels.
  final int screenWidth;

  /// Timezone offset in minutes from UTC.
  final int timeZoneOffset;

  /// Browser User-Agent string.
  final String userAgent;

  /// Whether JavaScript is enabled.
  final bool javascriptEnabled;

  /// Converts to JSON map.
  Map<String, Object?> toJson() => {
        'AcceptHeader': acceptHeader,
        'JavaEnabled': javaEnabled,
        'Language': language,
        'ColorDepth': colorDepth,
        'ScreenHeight': screenHeight,
        'ScreenWidth': screenWidth,
        'TimeZoneOffset': timeZoneOffset,
        'UserAgent': userAgent,
        'JavascriptEnabled': javascriptEnabled,
      };
}
