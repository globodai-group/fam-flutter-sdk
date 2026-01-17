/// KYC module for the FAM SDK.
///
/// Provides methods for KYC document management.
library;

import 'package:fam_sdk/src/client.dart';
import 'package:fam_sdk/src/modules/base.dart';
import 'package:fam_sdk/src/types/types.dart';

/// Module for KYC document operations (user-scoped).
///
/// ```dart
/// // Get the KYC module for a user
/// final kyc = fam.kyc('user_123');
///
/// // Create a document
/// final doc = await kyc.create(
///   CreateKycDocumentRequest(type: KycDocumentType.IDENTITY_PROOF),
/// );
///
/// // Add pages (base64 encoded images)
/// await kyc.createPage(doc.id, base64EncodedImage);
///
/// // Submit for validation
/// final submitted = await kyc.submit(doc.id);
/// ```
class KycModule extends UserScopedModule {
  /// Creates a KYC module for a specific user.
  KycModule(HttpClient client, String userId)
      : super(client, '/api/v1/mangopay/users/$userId/kyc/documents', userId);

  /// Creates a new KYC document.
  Future<KycDocument> create(CreateKycDocumentRequest data) => post(
        '',
        body: data.toJson(),
        fromJson: (json) => KycDocument.fromJson(json! as Map<String, Object?>),
      );

  /// Gets a KYC document by ID.
  Future<KycDocument> getDocument(String documentId) => get(
        '/$documentId',
        fromJson: (json) => KycDocument.fromJson(json! as Map<String, Object?>),
      );

  /// Lists all KYC documents for the user.
  Future<PaginatedResponse<KycDocument>> list({PaginationParams? params}) =>
      get(
        '',
        options: RequestOptions(params: params?.toQueryParams()),
        fromJson: (json) => PaginatedResponse.fromJson(
          json! as Map<String, Object?>,
          KycDocument.fromJson,
        ),
      );

  /// Creates a page (uploads a document image) for a KYC document.
  ///
  /// The [fileBase64] should be the base64-encoded content of the image.
  Future<void> createPage(String documentId, String fileBase64) => post<void>(
        '/$documentId/pages',
        body: {'File': fileBase64},
      );

  /// Submits a KYC document for validation.
  ///
  /// Once submitted, pages cannot be added anymore.
  Future<KycDocument> submit(String documentId) => put(
        '/$documentId',
        body: {'Status': 'VALIDATION_ASKED'},
        fromJson: (json) => KycDocument.fromJson(json! as Map<String, Object?>),
      );
}
