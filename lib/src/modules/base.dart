/// Base module for the FAM SDK.
///
/// Provides common functionality for all API modules.
library;

import 'package:fam_sdk/src/client.dart';

/// Base class for all API modules.
///
/// Provides HTTP method helpers and path building utilities.
abstract class BaseModule {
  /// Creates a base module.
  const BaseModule(this._client, this._basePath);

  final HttpClient _client;
  final String _basePath;

  /// Builds the full path for an endpoint.
  String _path([String segments = '']) {
    if (segments.isEmpty) {
      return _basePath;
    }
    if (segments.startsWith('/')) {
      return '$_basePath$segments';
    }
    return '$_basePath/$segments';
  }

  /// Performs a GET request.
  Future<T> get<T>(
    String endpoint, {
    RequestOptions? options,
    T Function(Object?)? fromJson,
  }) =>
      _client.get<T>(_path(endpoint), options: options, fromJson: fromJson);

  /// Performs a POST request.
  Future<T> post<T>(
    String endpoint, {
    Object? body,
    RequestOptions? options,
    T Function(Object?)? fromJson,
  }) =>
      _client.post<T>(
        _path(endpoint),
        body: body,
        options: options,
        fromJson: fromJson,
      );

  /// Performs a PUT request.
  Future<T> put<T>(
    String endpoint, {
    Object? body,
    RequestOptions? options,
    T Function(Object?)? fromJson,
  }) =>
      _client.put<T>(
        _path(endpoint),
        body: body,
        options: options,
        fromJson: fromJson,
      );

  /// Performs a PATCH request.
  Future<T> patch<T>(
    String endpoint, {
    Object? body,
    RequestOptions? options,
    T Function(Object?)? fromJson,
  }) =>
      _client.patch<T>(
        _path(endpoint),
        body: body,
        options: options,
        fromJson: fromJson,
      );

  /// Performs a DELETE request.
  Future<T> delete<T>(
    String endpoint, {
    RequestOptions? options,
    T Function(Object?)? fromJson,
  }) =>
      _client.delete<T>(_path(endpoint), options: options, fromJson: fromJson);
}

/// Base class for user-scoped modules.
///
/// Provides user ID in the base path for user-specific endpoints.
abstract class UserScopedModule extends BaseModule {
  /// Creates a user-scoped module.
  const UserScopedModule(HttpClient client, String basePath, this.userId)
      : super(client, basePath);

  /// The user ID for this scoped module.
  final String userId;
}
