/// FAM SDK Error Hierarchy
///
/// Provides typed exceptions for all error scenarios:
/// - [FamException]: Base exception for all SDK errors
/// - [ApiException]: HTTP errors with status codes
/// - [NetworkException]: Connection and timeout errors
/// - [WebhookSignatureException]: Webhook verification failures
library;

/// Base exception for all FAM SDK errors.
///
/// All exceptions thrown by the SDK extend this class,
/// allowing for easy catch-all error handling.
///
/// ```dart
/// try {
///   await fam.users.getUser('user_123');
/// } on FamException catch (e) {
///   print('FAM Error: ${e.message}');
/// }
/// ```
sealed class FamException implements Exception {
  /// Creates a new FAM exception.
  const FamException(this.message);

  /// Human-readable error message.
  final String message;

  @override
  String toString() => 'FamException: $message';
}

/// Exception thrown for HTTP API errors.
///
/// Contains the HTTP status code and optional error details
/// from the API response.
///
/// ```dart
/// try {
///   await fam.users.getUser('invalid_id');
/// } on ApiException catch (e) {
///   print('API Error ${e.statusCode}: ${e.message}');
///   if (e.code != null) print('Error code: ${e.code}');
/// }
/// ```
class ApiException extends FamException {
  /// Creates a new API exception.
  const ApiException(
    super.message, {
    required this.statusCode,
    this.code,
    this.details,
  });

  /// HTTP status code (e.g., 400, 401, 404, 500).
  final int statusCode;

  /// API-specific error code, if provided.
  final String? code;

  /// Additional error details from the response.
  final Object? details;

  @override
  String toString() {
    final buffer = StringBuffer('ApiException[$statusCode]: $message');
    if (code != null) buffer.write(' (code: $code)');
    return buffer.toString();
  }
}

/// Exception thrown for 401 Unauthorized responses.
///
/// Indicates that the request lacks valid authentication credentials.
///
/// ```dart
/// try {
///   await fam.users.getUser('user_123');
/// } on AuthenticationException catch (e) {
///   print('Invalid or expired token');
///   // Redirect to login or refresh token
/// }
/// ```
class AuthenticationException extends ApiException {
  /// Creates a new authentication exception.
  const AuthenticationException(
    super.message, {
    super.code,
    super.details,
  }) : super(statusCode: 401);

  @override
  String toString() => 'AuthenticationException: $message';
}

/// Exception thrown for 403 Forbidden responses.
///
/// Indicates that the authenticated user lacks permission
/// to access the requested resource.
///
/// ```dart
/// try {
///   await fam.wallets.getWallet('wallet_123');
/// } on AuthorizationException catch (e) {
///   print('Access denied: ${e.message}');
/// }
/// ```
class AuthorizationException extends ApiException {
  /// Creates a new authorization exception.
  const AuthorizationException(
    super.message, {
    super.code,
    super.details,
  }) : super(statusCode: 403);

  @override
  String toString() => 'AuthorizationException: $message';
}

/// Exception thrown for 404 Not Found responses.
///
/// Indicates that the requested resource does not exist.
///
/// ```dart
/// try {
///   await fam.users.getUser('nonexistent');
/// } on NotFoundException catch (e) {
///   print('Resource not found');
/// }
/// ```
class NotFoundException extends ApiException {
  /// Creates a new not found exception.
  const NotFoundException(
    super.message, {
    super.code,
    super.details,
  }) : super(statusCode: 404);

  @override
  String toString() => 'NotFoundException: $message';
}

/// Exception thrown for 400 Bad Request or 422 Unprocessable Entity responses.
///
/// Contains field-level validation errors when available.
///
/// ```dart
/// try {
///   await fam.users.createNatural(data);
/// } on ValidationException catch (e) {
///   print('Validation failed: ${e.message}');
///   for (final entry in e.errors.entries) {
///     print('  ${entry.key}: ${entry.value.join(', ')}');
///   }
/// }
/// ```
class ValidationException extends ApiException {
  /// Creates a new validation exception.
  const ValidationException(
    super.message, {
    required super.statusCode,
    super.code,
    super.details,
    this.errors = const {},
  });

  /// Field-level validation errors.
  ///
  /// Keys are field names, values are lists of error messages.
  final Map<String, List<String>> errors;

  @override
  String toString() {
    if (errors.isEmpty) return 'ValidationException: $message';
    final errorStr =
        errors.entries.map((e) => '${e.key}: ${e.value.join(', ')}').join('; ');
    return 'ValidationException: $message ($errorStr)';
  }
}

/// Exception thrown for 429 Too Many Requests responses.
///
/// Indicates rate limiting. Check [retryAfter] for the
/// recommended wait time before retrying.
///
/// ```dart
/// try {
///   await fam.users.getUser('user_123');
/// } on RateLimitException catch (e) {
///   print('Rate limited. Retry after ${e.retryAfter} seconds');
///   await Future.delayed(Duration(seconds: e.retryAfter ?? 60));
/// }
/// ```
class RateLimitException extends ApiException {
  /// Creates a new rate limit exception.
  const RateLimitException(
    super.message, {
    super.code,
    super.details,
    this.retryAfter,
  }) : super(statusCode: 429);

  /// Recommended seconds to wait before retrying.
  final int? retryAfter;

  @override
  String toString() {
    final buffer = StringBuffer('RateLimitException: $message');
    if (retryAfter != null) buffer.write(' (retry after ${retryAfter}s)');
    return buffer.toString();
  }
}

/// Exception thrown for network-level errors.
///
/// Indicates connection failures, DNS resolution errors,
/// or other network issues.
///
/// ```dart
/// try {
///   await fam.users.getUser('user_123');
/// } on NetworkException catch (e) {
///   print('Network error: ${e.message}');
///   if (e.originalError != null) {
///     print('Cause: ${e.originalError}');
///   }
/// }
/// ```
class NetworkException extends FamException {
  /// Creates a new network exception.
  const NetworkException(super.message, {this.originalError});

  /// The underlying error that caused this exception.
  final Object? originalError;

  @override
  String toString() => 'NetworkException: $message';
}

/// Exception thrown when a request times out.
///
/// Extends [NetworkException] for timeout-specific handling.
///
/// ```dart
/// try {
///   await fam.payins.create(data);
/// } on TimeoutException catch (e) {
///   print('Request timed out after ${e.duration?.inSeconds}s');
/// }
/// ```
class TimeoutException extends NetworkException {
  /// Creates a new timeout exception.
  const TimeoutException(super.message, {super.originalError, this.duration});

  /// The timeout duration that was exceeded.
  final Duration? duration;

  @override
  String toString() {
    if (duration != null) {
      return 'TimeoutException: $message (${duration!.inMilliseconds}ms)';
    }
    return 'TimeoutException: $message';
  }
}

/// Exception thrown when webhook signature verification fails.
///
/// Indicates that the webhook payload could not be verified
/// as authentic, possibly due to tampering or incorrect secret.
///
/// ```dart
/// try {
///   final event = webhooks.constructEvent(payload, signature);
/// } on WebhookSignatureException catch (e) {
///   print('Invalid webhook signature');
///   // Return 400 Bad Request to webhook sender
/// }
/// ```
class WebhookSignatureException extends FamException {
  /// Creates a new webhook signature exception.
  const WebhookSignatureException(super.message);

  @override
  String toString() => 'WebhookSignatureException: $message';
}

/// Creates the appropriate exception based on HTTP status code.
///
/// This factory function is used internally by the HTTP client
/// to convert API error responses into typed exceptions.
ApiException createApiException({
  required int statusCode,
  required String message,
  String? code,
  Object? details,
  Map<String, List<String>>? validationErrors,
  int? retryAfter,
}) {
  switch (statusCode) {
    case 400:
    case 422:
      return ValidationException(
        message,
        statusCode: statusCode,
        code: code,
        details: details,
        errors: validationErrors ?? const {},
      );
    case 401:
      return AuthenticationException(message, code: code, details: details);
    case 403:
      return AuthorizationException(message, code: code, details: details);
    case 404:
      return NotFoundException(message, code: code, details: details);
    case 429:
      return RateLimitException(
        message,
        code: code,
        details: details,
        retryAfter: retryAfter,
      );
    default:
      return ApiException(
        message,
        statusCode: statusCode,
        code: code,
        details: details,
      );
  }
}
