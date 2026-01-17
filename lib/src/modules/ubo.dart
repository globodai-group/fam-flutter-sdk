/// UBO module for the FAM SDK.
///
/// Provides methods for Ultimate Beneficial Owner declarations.
library;

import 'package:fam_sdk/src/client.dart';
import 'package:fam_sdk/src/modules/base.dart';
import 'package:fam_sdk/src/types/types.dart';

/// Module for UBO declaration operations (user-scoped).
///
/// UBO declarations are required for legal entities to declare
/// persons who own or control more than 25% of the company.
///
/// ```dart
/// // Get the UBO module for a legal user
/// final ubo = fam.ubo('legal_user_123');
///
/// // Create a declaration
/// final declaration = await ubo.createDeclaration();
///
/// // Add a UBO
/// await ubo.createUbo(
///   declaration.id,
///   CreateUboRequest(
///     firstName: 'John',
///     lastName: 'Doe',
///     address: Address(addressLine1: '123 Main St', ...),
///     nationality: 'FR',
///     birthday: 315532800,
///     birthplace: Birthplace(city: 'Paris', country: 'FR'),
///   ),
/// );
///
/// // Submit for validation
/// await ubo.submit(declaration.id);
/// ```
class UboModule extends UserScopedModule {
  /// Creates a UBO module for a specific user.
  UboModule(HttpClient client, String userId)
      : super(client, '/api/v1/mangopay/users/$userId/kyc/ubodeclarations',
            userId);

  /// Creates a new UBO declaration.
  Future<UboDeclaration> createDeclaration() => post(
        '',
        fromJson: (json) =>
            UboDeclaration.fromJson(json! as Map<String, Object?>),
      );

  /// Gets a UBO declaration by ID.
  Future<UboDeclaration> getDeclaration(String declarationId) => get(
        '/$declarationId',
        fromJson: (json) =>
            UboDeclaration.fromJson(json! as Map<String, Object?>),
      );

  /// Creates a UBO in a declaration.
  Future<Ubo> createUbo(String declarationId, CreateUboRequest data) => post(
        '/$declarationId/ubos',
        body: data.toJson(),
        fromJson: (json) => Ubo.fromJson(json! as Map<String, Object?>),
      );

  /// Updates a UBO in a declaration.
  Future<Ubo> updateUbo(
    String declarationId,
    String uboId,
    UpdateUboRequest data,
  ) =>
      put(
        '/$declarationId/ubos/$uboId',
        body: data.toJson(),
        fromJson: (json) => Ubo.fromJson(json! as Map<String, Object?>),
      );

  /// Submits a UBO declaration for validation.
  Future<UboDeclaration> submit(String declarationId) => put(
        '/$declarationId',
        body: {'Status': 'VALIDATION_ASKED'},
        fromJson: (json) =>
            UboDeclaration.fromJson(json! as Map<String, Object?>),
      );
}
