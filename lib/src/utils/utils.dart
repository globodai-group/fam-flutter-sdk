/// Utility functions for the FAM SDK.
///
/// Provides helper functions for common operations.
library;

import 'dart:io' show Platform;

/// Checks if running in a browser environment.
///
/// Returns false in Dart/Flutter native environments.
bool isBrowser() {
  try {
    // Platform is not available in browser
    Platform.operatingSystem;
    return false;
  } on UnsupportedError {
    return true;
  }
}

/// Checks if running in a native (non-browser) environment.
bool isNative() => !isBrowser();

/// Delays execution for the specified duration.
///
/// ```dart
/// await sleep(Duration(seconds: 1));
/// ```
Future<void> sleep(Duration duration) => Future.delayed(duration);

/// Retries an async operation with exponential backoff.
///
/// ```dart
/// final result = await retry(
///   () => fetchData(),
///   maxRetries: 3,
///   baseDelay: Duration(seconds: 1),
/// );
/// ```
Future<T> retry<T>(
  Future<T> Function() fn, {
  int maxRetries = 3,
  Duration baseDelay = const Duration(seconds: 1),
  Duration maxDelay = const Duration(seconds: 30),
  bool Function(Object error)? shouldRetry,
}) async {
  var attempt = 0;
  var delay = baseDelay;

  while (true) {
    try {
      return await fn();
    } on Object catch (error) {
      attempt++;

      if (attempt >= maxRetries) {
        rethrow;
      }

      if (shouldRetry != null && !shouldRetry(error)) {
        rethrow;
      }

      await sleep(delay);

      // Exponential backoff with jitter
      delay = Duration(
        milliseconds:
            (delay.inMilliseconds * 2).clamp(0, maxDelay.inMilliseconds),
      );
    }
  }
}

/// Builds a URL with query parameters.
///
/// ```dart
/// final url = buildUrl(
///   'https://api.example.com',
///   '/users',
///   params: {'page': '1', 'limit': '10'},
/// );
/// // => https://api.example.com/users?page=1&limit=10
/// ```
String buildUrl(
  String baseUrl,
  String path, {
  Map<String, String>? params,
}) {
  final uri = Uri.parse(baseUrl).resolve(path);

  if (params == null || params.isEmpty) {
    return uri.toString();
  }

  // Filter out null/empty values
  final filteredParams = Map.fromEntries(
    params.entries.where((e) => e.value.isNotEmpty),
  );

  if (filteredParams.isEmpty) {
    return uri.toString();
  }

  return uri.replace(queryParameters: filteredParams).toString();
}

/// Deep merges two maps.
///
/// Values from [source] override values from [target].
Map<String, Object?> deepMerge(
  Map<String, Object?> target,
  Map<String, Object?> source,
) {
  final result = Map<String, Object?>.from(target);

  for (final entry in source.entries) {
    final key = entry.key;
    final sourceValue = entry.value;
    final targetValue = result[key];

    if (sourceValue is Map<String, Object?> &&
        targetValue is Map<String, Object?>) {
      result[key] = deepMerge(targetValue, sourceValue);
    } else {
      result[key] = sourceValue;
    }
  }

  return result;
}

/// Formats an amount in cents to a display string.
///
/// ```dart
/// formatAmount(1234, 'EUR'); // => "12.34 EUR"
/// formatAmount(1000, 'JPY'); // => "1000 JPY" (no decimals for JPY)
/// ```
String formatAmount(int amountInCents, [String currency = 'EUR']) {
  // Currencies without decimal places
  const noDecimalCurrencies = {'JPY', 'KRW', 'VND'};

  if (noDecimalCurrencies.contains(currency.toUpperCase())) {
    return '$amountInCents $currency';
  }

  final decimal = amountInCents / 100;
  return '${decimal.toStringAsFixed(2)} $currency';
}

/// Parses an amount from a decimal to cents.
///
/// ```dart
/// parseAmount(12.34); // => 1234
/// parseAmount(10); // => 1000
/// ```
int parseAmount(num amount) => (amount * 100).round();

/// Timing-safe string comparison.
///
/// Used for comparing signatures to prevent timing attacks.
bool timingSafeEquals(String a, String b) {
  if (a.length != b.length) {
    return false;
  }

  var result = 0;
  for (var i = 0; i < a.length; i++) {
    result |= a.codeUnitAt(i) ^ b.codeUnitAt(i);
  }

  return result == 0;
}

/// Validates that a string looks like a valid ID.
bool isValidId(String? id) {
  if (id == null || id.isEmpty) {
    return false;
  }
  // Most IDs are alphanumeric with possible underscores/hyphens
  return RegExp(r'^[a-zA-Z0-9_-]+$').hasMatch(id);
}

/// Extension on DateTime for Unix timestamp conversion.
extension DateTimeExtension on DateTime {
  /// Converts to Unix timestamp (seconds since epoch).
  int toUnixTimestamp() => millisecondsSinceEpoch ~/ 1000;

  /// Creates DateTime from Unix timestamp.
  static DateTime fromUnixTimestamp(int timestamp) =>
      DateTime.fromMillisecondsSinceEpoch(timestamp * 1000, isUtc: true);
}

/// Extension on int for Unix timestamp conversion.
extension IntTimestampExtension on int {
  /// Converts Unix timestamp to DateTime.
  DateTime toDateTime() =>
      DateTime.fromMillisecondsSinceEpoch(this * 1000, isUtc: true);
}
