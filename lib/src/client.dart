/// HTTP client for the FAM SDK.
///
/// Provides a type-safe HTTP client with automatic retries,
/// error handling, and authentication.
library;

import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;

import 'package:fam_sdk/src/errors/errors.dart';
import 'package:fam_sdk/src/utils/utils.dart';

/// Configuration options for the FAM client.
class FamOptions {
  /// Creates FAM client options.
  const FamOptions({
    required this.baseUrl,
    this.token,
    this.timeout = const Duration(seconds: 30),
    this.retries = 3,
    this.headers = const {},
  });

  /// Base URL for API requests.
  final String baseUrl;

  /// Authentication token.
  final String? token;

  /// Request timeout duration.
  final Duration timeout;

  /// Number of retries for failed requests.
  final int retries;

  /// Additional headers to include in all requests.
  final Map<String, String> headers;

  /// Creates a copy with updated values.
  FamOptions copyWith({
    String? baseUrl,
    String? token,
    Duration? timeout,
    int? retries,
    Map<String, String>? headers,
  }) =>
      FamOptions(
        baseUrl: baseUrl ?? this.baseUrl,
        token: token ?? this.token,
        timeout: timeout ?? this.timeout,
        retries: retries ?? this.retries,
        headers: headers ?? this.headers,
      );
}

/// Request-specific options.
class RequestOptions {
  /// Creates request options.
  const RequestOptions({
    this.params,
    this.headers,
    this.timeout,
    this.skipRetry = false,
  });

  /// Query parameters.
  final Map<String, String>? params;

  /// Additional headers for this request.
  final Map<String, String>? headers;

  /// Override timeout for this request.
  final Duration? timeout;

  /// Skip retry logic for this request.
  final bool skipRetry;
}

/// HTTP client with automatic retries and error handling.
class HttpClient {
  /// Creates an HTTP client.
  HttpClient(this._options) : _client = _NativeHttpClient();

  FamOptions _options;
  final _NativeHttpClient _client;

  /// Updates the authentication token.
  void setToken(String token) {
    _options = _options.copyWith(token: token);
  }

  /// Clears the authentication token.
  void clearToken() {
    _options = FamOptions(
      baseUrl: _options.baseUrl,
      timeout: _options.timeout,
      retries: _options.retries,
      headers: _options.headers,
    );
  }

  /// Performs a GET request.
  Future<T> get<T>(
    String path, {
    RequestOptions? options,
    T Function(Object?)? fromJson,
  }) =>
      _request('GET', path, options: options, fromJson: fromJson);

  /// Performs a POST request.
  Future<T> post<T>(
    String path, {
    Object? body,
    RequestOptions? options,
    T Function(Object?)? fromJson,
  }) =>
      _request('POST', path, body: body, options: options, fromJson: fromJson);

  /// Performs a PUT request.
  Future<T> put<T>(
    String path, {
    Object? body,
    RequestOptions? options,
    T Function(Object?)? fromJson,
  }) =>
      _request('PUT', path, body: body, options: options, fromJson: fromJson);

  /// Performs a PATCH request.
  Future<T> patch<T>(
    String path, {
    Object? body,
    RequestOptions? options,
    T Function(Object?)? fromJson,
  }) =>
      _request('PATCH', path, body: body, options: options, fromJson: fromJson);

  /// Performs a DELETE request.
  Future<T> delete<T>(
    String path, {
    RequestOptions? options,
    T Function(Object?)? fromJson,
  }) =>
      _request('DELETE', path, options: options, fromJson: fromJson);

  Future<T> _request<T>(
    String method,
    String path, {
    Object? body,
    RequestOptions? options,
    T Function(Object?)? fromJson,
  }) async {
    final url = buildUrl(
      _options.baseUrl,
      path,
      params: options?.params,
    );

    final timeout = options?.timeout ?? _options.timeout;
    final maxRetries = (options?.skipRetry ?? false) ? 1 : _options.retries;

    return retry(
      () => _executeRequest<T>(
        method: method,
        url: url,
        body: body,
        timeout: timeout,
        extraHeaders: options?.headers,
        fromJson: fromJson,
      ),
      maxRetries: maxRetries,
      shouldRetry: _shouldRetry,
    );
  }

  Future<T> _executeRequest<T>({
    required String method,
    required String url,
    required Duration timeout,
    Object? body,
    Map<String, String>? extraHeaders,
    T Function(Object?)? fromJson,
  }) async {
    final uri = Uri.parse(url);
    final headers = _buildHeaders(extraHeaders);

    try {
      final response = await _client.request(
        method: method,
        uri: uri,
        headers: headers,
        body: body != null ? jsonEncode(body) : null,
        timeout: timeout,
      );

      return _handleResponse<T>(response, fromJson);
    } on io.SocketException catch (e) {
      throw NetworkException(
        'Connection failed: ${e.message}',
        originalError: e,
      );
    } on TimeoutException catch (e) {
      throw TimeoutException(
        'Request timed out after ${timeout.inSeconds}s',
        originalError: e,
        duration: timeout,
      );
    } on io.HttpException catch (e) {
      throw NetworkException('HTTP error: ${e.message}', originalError: e);
    }
  }

  Map<String, String> _buildHeaders(Map<String, String>? extra) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'User-Agent': 'FAM-Flutter-SDK/1.0.0',
      ..._options.headers,
    };

    if (_options.token != null) {
      headers['Authorization'] = 'Bearer ${_options.token}';
    }

    if (extra != null) {
      headers.addAll(extra);
    }

    return headers;
  }

  T _handleResponse<T>(_HttpResponse response, T Function(Object?)? fromJson) {
    final statusCode = response.statusCode;
    final body = response.body;

    Object? data;
    try {
      if (body.isNotEmpty) {
        data = jsonDecode(body);
      }
    } on FormatException {
      // Body is not JSON
      data = body;
    }

    if (statusCode >= 200 && statusCode < 300) {
      if (fromJson != null) {
        return fromJson(data);
      }
      return data as T;
    }

    _throwApiException(statusCode, data, response.headers);
  }

  Never _throwApiException(
    int statusCode,
    Object? data,
    Map<String, String> headers,
  ) {
    String message;
    String? code;
    Object? details;
    Map<String, List<String>>? validationErrors;
    int? retryAfter;

    if (data is Map<String, Object?>) {
      message = (data['message'] as String?) ??
          (data['error'] as String?) ??
          'Request failed';
      code = data['code'] as String?;
      details = data['details'];

      // Parse validation errors
      if (data['errors'] is Map<String, Object?>) {
        final errorsMap = data['errors']! as Map<String, Object?>;
        validationErrors = errorsMap.map((key, value) {
          if (value is List) {
            return MapEntry(key, value.cast<String>());
          }
          return MapEntry(key, [value.toString()]);
        });
      }
    } else {
      message = data?.toString() ?? 'Request failed with status $statusCode';
    }

    // Parse Retry-After header for rate limiting
    if (statusCode == 429) {
      final retryAfterHeader = headers['retry-after'];
      if (retryAfterHeader != null) {
        retryAfter = int.tryParse(retryAfterHeader);
      }
    }

    throw createApiException(
      statusCode: statusCode,
      message: message,
      code: code,
      details: details,
      validationErrors: validationErrors,
      retryAfter: retryAfter,
    );
  }

  bool _shouldRetry(Object error) {
    // Retry on network errors
    if (error is NetworkException) {
      return true;
    }

    // Retry on rate limit (429) - the retry function will handle backoff
    if (error is RateLimitException) {
      return true;
    }

    // Retry on server errors (5xx)
    if (error is ApiException && error.statusCode >= 500) {
      return true;
    }

    return false;
  }

  /// Closes the HTTP client and releases resources.
  void close() {
    _client.close();
  }
}

/// Simple HTTP client wrapper using dart:io.
class _NativeHttpClient {
  _NativeHttpClient() {
    _client.connectionTimeout = const Duration(seconds: 10);
    _client.idleTimeout = const Duration(seconds: 30);
  }

  final io.HttpClient _client = io.HttpClient();

  /// Performs an HTTP request.
  Future<_HttpResponse> request({
    required String method,
    required Uri uri,
    required Map<String, String> headers,
    required Duration timeout,
    String? body,
  }) async {
    final request = await _client.openUrl(method, uri);

    // Set headers
    headers.forEach((key, value) {
      request.headers.set(key, value);
    });

    // Write body if present
    if (body != null) {
      request.write(body);
    }

    // Execute with timeout
    final response = await request.close().timeout(timeout);

    // Read response body
    final responseBody = await response.transform(utf8.decoder).join();

    // Convert headers to Map
    final responseHeaders = <String, String>{};
    response.headers.forEach((String name, List<String> values) {
      responseHeaders[name] = values.join(', ');
    });

    return _HttpResponse(
      statusCode: response.statusCode,
      body: responseBody,
      headers: responseHeaders,
    );
  }

  /// Closes the client.
  void close() {
    _client.close();
  }
}

/// HTTP response wrapper.
class _HttpResponse {
  /// Creates a response.
  const _HttpResponse({
    required this.statusCode,
    required this.body,
    required this.headers,
  });

  /// HTTP status code.
  final int statusCode;

  /// Response body as string.
  final String body;

  /// Response headers.
  final Map<String, String> headers;
}
