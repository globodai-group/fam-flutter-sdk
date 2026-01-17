/// KYC types for the FAM SDK.
///
/// Provides types for KYC document verification.
library;

/// KYC document type.
enum KycDocumentType {
  /// Identity document (passport, ID card).
  // ignore: constant_identifier_names
  IDENTITY_PROOF,

  /// Company registration document.
  // ignore: constant_identifier_names
  REGISTRATION_PROOF,

  /// Articles of association.
  // ignore: constant_identifier_names
  ARTICLES_OF_ASSOCIATION,

  /// Shareholder declaration.
  // ignore: constant_identifier_names
  SHAREHOLDER_DECLARATION,

  /// Proof of address.
  // ignore: constant_identifier_names
  ADDRESS_PROOF,
}

/// KYC document status.
enum KycDocumentStatus {
  /// Document created, awaiting pages.
  CREATED,

  /// Document submitted for validation.
  // ignore: constant_identifier_names
  VALIDATION_ASKED,

  /// Document validated.
  VALIDATED,

  /// Document refused.
  REFUSED,

  /// Document has expired.
  // ignore: constant_identifier_names
  OUT_OF_DATE,
}

/// Reason type for refused KYC document.
enum KycRefusedReasonType {
  /// Document is unreadable.
  // ignore: constant_identifier_names
  DOCUMENT_UNREADABLE,

  /// Document type not accepted.
  // ignore: constant_identifier_names
  DOCUMENT_NOT_ACCEPTED,

  /// Document has expired.
  // ignore: constant_identifier_names
  DOCUMENT_HAS_EXPIRED,

  /// Document is incomplete.
  // ignore: constant_identifier_names
  DOCUMENT_INCOMPLETE,

  /// Document is missing.
  // ignore: constant_identifier_names
  DOCUMENT_MISSING,

  /// Document does not match user data.
  // ignore: constant_identifier_names
  DOCUMENT_DO_NOT_MATCH_USER_DATA,

  /// Document does not match account data.
  // ignore: constant_identifier_names
  DOCUMENT_DO_NOT_MATCH_ACCOUNT_DATA,

  /// Document is falsified.
  // ignore: constant_identifier_names
  DOCUMENT_FALSIFIED,

  /// Underage person.
  // ignore: constant_identifier_names
  UNDERAGE_PERSON,

  /// Specific case requiring manual review.
  // ignore: constant_identifier_names
  SPECIFIC_CASE,
}

/// A KYC verification document.
///
/// Used for identity verification and compliance.
///
/// ```dart
/// final kycModule = fam.kyc('user_123');
///
/// // Create a document
/// final doc = await kycModule.create(
///   CreateKycDocumentRequest(type: KycDocumentType.IDENTITY_PROOF),
/// );
///
/// // Add pages (base64 encoded images)
/// await kycModule.createPage(doc.id, base64Image);
///
/// // Submit for validation
/// await kycModule.submit(doc.id);
/// ```
class KycDocument {
  /// Creates a KYC document.
  const KycDocument({
    required this.id,
    required this.userId,
    required this.type,
    required this.status,
    this.refusedReasonType,
    this.refusedReasonMessage,
    this.processedDate,
    this.flags,
    this.tag,
    this.creationDate,
  });

  /// Creates a KycDocument from JSON.
  factory KycDocument.fromJson(Map<String, Object?> json) => KycDocument(
        id: json['Id'] as String,
        userId: json['UserId'] as String,
        type: KycDocumentType.values.byName(json['Type'] as String),
        status: KycDocumentStatus.values.byName(json['Status'] as String),
        refusedReasonType: json['RefusedReasonType'] != null
            ? KycRefusedReasonType.values
                .byName(json['RefusedReasonType'] as String)
            : null,
        refusedReasonMessage: json['RefusedReasonMessage'] as String?,
        processedDate: json['ProcessedDate'] as int?,
        flags: (json['Flags'] as List<Object?>?)?.cast<String>(),
        tag: json['Tag'] as String?,
        creationDate: json['CreationDate'] as int?,
      );

  /// Document ID.
  final String id;

  /// Owner user ID.
  final String userId;

  /// Document type.
  final KycDocumentType type;

  /// Document status.
  final KycDocumentStatus status;

  /// Reason for refusal.
  final KycRefusedReasonType? refusedReasonType;

  /// Refusal message.
  final String? refusedReasonMessage;

  /// Processing date timestamp.
  final int? processedDate;

  /// Document flags.
  final List<String>? flags;

  /// Custom tag.
  final String? tag;

  /// Creation timestamp.
  final int? creationDate;

  /// Whether the document is validated.
  bool get isValidated => status == KycDocumentStatus.VALIDATED;

  /// Whether the document is pending review.
  bool get isPending => status == KycDocumentStatus.VALIDATION_ASKED;

  /// Whether the document was refused.
  bool get isRefused => status == KycDocumentStatus.REFUSED;

  /// Converts to JSON.
  Map<String, Object?> toJson() => {
        'Id': id,
        'UserId': userId,
        'Type': type.name,
        'Status': status.name,
        if (refusedReasonType != null)
          'RefusedReasonType': refusedReasonType!.name,
        if (refusedReasonMessage != null)
          'RefusedReasonMessage': refusedReasonMessage,
        if (processedDate != null) 'ProcessedDate': processedDate,
        if (flags != null) 'Flags': flags,
        if (tag != null) 'Tag': tag,
        if (creationDate != null) 'CreationDate': creationDate,
      };
}

/// Request to create a KYC document.
class CreateKycDocumentRequest {
  /// Creates a KYC document request.
  const CreateKycDocumentRequest({
    required this.type,
    this.tag,
  });

  /// Document type.
  final KycDocumentType type;

  /// Custom tag.
  final String? tag;

  /// Converts to JSON.
  Map<String, Object?> toJson() => {
        'Type': type.name,
        if (tag != null) 'Tag': tag,
      };
}
