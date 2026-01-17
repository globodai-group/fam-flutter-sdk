/// Portal module for the FAM SDK.
///
/// Provides methods for customer portal session management (FAM custom feature).
library;

import 'package:fam_sdk/src/client.dart';
import 'package:fam_sdk/src/modules/base.dart';
import 'package:fam_sdk/src/types/types.dart';

/// Module for portal session operations.
///
/// This is a FAM-specific feature for managing customer portal sessions.
///
/// ```dart
/// // Create a portal session
/// final session = await fam.portal.createSession(
///   CreatePortalSessionRequest(
///     mangopayUserId: 'mp_user_123',
///     returnUrl: 'https://myapp.com/return',
///     expiresInMinutes: 30,
///   ),
/// );
///
/// // Redirect user to session.portalUrl
/// // or use the session token for API calls
///
/// // Validate a session
/// final validation = await fam.portal.validateSession(
///   ValidatePortalSessionRequest(sessionToken: session.sessionToken),
/// );
/// ```
class PortalModule extends BaseModule {
  /// Creates a portal module.
  const PortalModule(HttpClient client) : super(client, '/api/v1/portal');

  /// Creates a new portal session.
  Future<CreatePortalSessionResponse> createSession(
    CreatePortalSessionRequest data,
  ) =>
      post(
        '/sessions',
        body: data.toJson(),
        fromJson: (json) =>
            CreatePortalSessionResponse.fromJson(json! as Map<String, Object?>),
      );

  /// Validates a portal session.
  Future<ValidatePortalSessionResponse> validateSession(
    ValidatePortalSessionRequest data,
  ) =>
      post(
        '/sessions/validate',
        body: data.toJson(),
        fromJson: (json) => ValidatePortalSessionResponse.fromJson(
            json! as Map<String, Object?>),
      );

  /// Gets the user for a portal session.
  Future<GetPortalUserResponse> getUser(String sessionToken) => get(
        '/user',
        options: RequestOptions(
          headers: {'X-Portal-Session': sessionToken},
        ),
        fromJson: (json) =>
            GetPortalUserResponse.fromJson(json! as Map<String, Object?>),
      );

  /// Refreshes a portal session.
  Future<RefreshPortalSessionResponse> refreshSession(String sessionToken) =>
      post(
        '/sessions/refresh',
        options: RequestOptions(
          headers: {'X-Portal-Session': sessionToken},
        ),
        fromJson: (json) => RefreshPortalSessionResponse.fromJson(
            json! as Map<String, Object?>),
      );

  /// Logs out from a portal session.
  Future<PortalLogoutResponse> logout(String sessionToken) => post(
        '/logout',
        options: RequestOptions(
          headers: {'X-Portal-Session': sessionToken},
        ),
        fromJson: (json) =>
            PortalLogoutResponse.fromJson(json! as Map<String, Object?>),
      );
}
