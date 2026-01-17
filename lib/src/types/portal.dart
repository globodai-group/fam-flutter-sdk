/// Portal types for the FAM SDK.
///
/// Provides types for customer portal session management (FAM custom feature).
library;

/// Portal user information.
class PortalUser {
  /// Creates a portal user.
  const PortalUser({
    required this.mangopayId,
    this.email,
    this.firstName,
    this.lastName,
    this.personType,
  });

  /// Creates from JSON.
  factory PortalUser.fromJson(Map<String, Object?> json) => PortalUser(
        mangopayId: json['mangopayId'] as String,
        email: json['email'] as String?,
        firstName: json['firstName'] as String?,
        lastName: json['lastName'] as String?,
        personType: json['personType'] as String?,
      );

  /// Mangopay user ID.
  final String mangopayId;

  /// User email.
  final String? email;

  /// First name.
  final String? firstName;

  /// Last name.
  final String? lastName;

  /// Person type (NATURAL or LEGAL).
  final String? personType;

  /// Full name if available.
  String? get fullName {
    if (firstName != null && lastName != null) {
      return '$firstName $lastName';
    }
    return firstName ?? lastName;
  }

  /// Converts to JSON.
  Map<String, Object?> toJson() => {
        'mangopayId': mangopayId,
        if (email != null) 'email': email,
        if (firstName != null) 'firstName': firstName,
        if (lastName != null) 'lastName': lastName,
        if (personType != null) 'personType': personType,
      };
}

/// Portal website configuration.
class PortalWebsiteConfig {
  /// Creates a website config.
  const PortalWebsiteConfig({
    required this.id,
    this.name,
    this.domain,
    this.logoUrl,
    this.primaryColor,
    this.secondaryColor,
    this.accentColor,
  });

  /// Creates from JSON.
  factory PortalWebsiteConfig.fromJson(Map<String, Object?> json) =>
      PortalWebsiteConfig(
        id: json['id'] as String,
        name: json['name'] as String?,
        domain: json['domain'] as String?,
        logoUrl: json['logoUrl'] as String?,
        primaryColor: json['primaryColor'] as String?,
        secondaryColor: json['secondaryColor'] as String?,
        accentColor: json['accentColor'] as String?,
      );

  /// Website ID.
  final String id;

  /// Website name.
  final String? name;

  /// Website domain.
  final String? domain;

  /// Logo URL.
  final String? logoUrl;

  /// Primary brand color (hex).
  final String? primaryColor;

  /// Secondary brand color (hex).
  final String? secondaryColor;

  /// Accent brand color (hex).
  final String? accentColor;

  /// Converts to JSON.
  Map<String, Object?> toJson() => {
        'id': id,
        if (name != null) 'name': name,
        if (domain != null) 'domain': domain,
        if (logoUrl != null) 'logoUrl': logoUrl,
        if (primaryColor != null) 'primaryColor': primaryColor,
        if (secondaryColor != null) 'secondaryColor': secondaryColor,
        if (accentColor != null) 'accentColor': accentColor,
      };
}

/// Checkout configuration for portal.
class CheckoutConfig {
  /// Creates a checkout config.
  const CheckoutConfig({
    required this.productType,
    required this.productLabel,
    required this.amount,
    required this.isRecurring,
    this.productDescription,
    this.currency,
    this.frequency,
    this.hasDiscount,
    this.discountLabel,
    this.originalAmount,
    this.metadata,
  });

  /// Creates from JSON.
  factory CheckoutConfig.fromJson(Map<String, Object?> json) => CheckoutConfig(
        productType: json['productType'] as String,
        productLabel: json['productLabel'] as String,
        amount: json['amount'] as int,
        isRecurring: json['isRecurring'] as bool,
        productDescription: json['productDescription'] as String?,
        currency: json['currency'] as String?,
        frequency: json['frequency'] as String?,
        hasDiscount: json['hasDiscount'] as bool?,
        discountLabel: json['discountLabel'] as String?,
        originalAmount: json['originalAmount'] as int?,
        metadata: json['metadata'] as Map<String, Object?>?,
      );

  /// Product type identifier.
  final String productType;

  /// Product display label.
  final String productLabel;

  /// Product description.
  final String? productDescription;

  /// Amount in smallest currency unit.
  final int amount;

  /// Currency code (defaults to EUR).
  final String? currency;

  /// Whether this is a recurring payment.
  final bool isRecurring;

  /// Payment frequency for recurring (MONTHLY, YEARLY).
  final String? frequency;

  /// Whether a discount is applied.
  final bool? hasDiscount;

  /// Discount label.
  final String? discountLabel;

  /// Original amount before discount.
  final int? originalAmount;

  /// Custom metadata.
  final Map<String, Object?>? metadata;

  /// Converts to JSON.
  Map<String, Object?> toJson() => {
        'productType': productType,
        'productLabel': productLabel,
        'amount': amount,
        'isRecurring': isRecurring,
        if (productDescription != null)
          'productDescription': productDescription,
        if (currency != null) 'currency': currency,
        if (frequency != null) 'frequency': frequency,
        if (hasDiscount != null) 'hasDiscount': hasDiscount,
        if (discountLabel != null) 'discountLabel': discountLabel,
        if (originalAmount != null) 'originalAmount': originalAmount,
        if (metadata != null) 'metadata': metadata,
      };
}

/// Request to create a portal session.
class CreatePortalSessionRequest {
  /// Creates a session request.
  const CreatePortalSessionRequest({
    required this.mangopayUserId,
    this.returnUrl,
    this.expiresInMinutes,
    this.checkoutConfig,
  });

  /// Mangopay user ID.
  final String mangopayUserId;

  /// Return URL after portal actions.
  final String? returnUrl;

  /// Session expiration in minutes.
  final int? expiresInMinutes;

  /// Checkout configuration.
  final CheckoutConfig? checkoutConfig;

  /// Converts to JSON.
  Map<String, Object?> toJson() => {
        'mangopayUserId': mangopayUserId,
        if (returnUrl != null) 'returnUrl': returnUrl,
        if (expiresInMinutes != null) 'expiresInMinutes': expiresInMinutes,
        if (checkoutConfig != null) 'checkoutConfig': checkoutConfig!.toJson(),
      };
}

/// Response from creating a portal session.
class CreatePortalSessionResponse {
  /// Creates a session response.
  const CreatePortalSessionResponse({
    required this.sessionToken,
    required this.portalUrl,
    required this.expiresAt,
  });

  /// Creates from JSON.
  factory CreatePortalSessionResponse.fromJson(Map<String, Object?> json) =>
      CreatePortalSessionResponse(
        sessionToken: json['sessionToken'] as String,
        portalUrl: json['portalUrl'] as String,
        expiresAt: json['expiresAt'] as String,
      );

  /// Session token for API calls.
  final String sessionToken;

  /// Portal URL to redirect user to.
  final String portalUrl;

  /// Session expiration (ISO 8601).
  final String expiresAt;

  /// Converts to JSON.
  Map<String, Object?> toJson() => {
        'sessionToken': sessionToken,
        'portalUrl': portalUrl,
        'expiresAt': expiresAt,
      };
}

/// Request to validate a portal session.
class ValidatePortalSessionRequest {
  /// Creates a validation request.
  const ValidatePortalSessionRequest({
    required this.sessionToken,
  });

  /// Session token to validate.
  final String sessionToken;

  /// Converts to JSON.
  Map<String, Object?> toJson() => {
        'sessionToken': sessionToken,
      };
}

/// Response from validating a portal session.
class ValidatePortalSessionResponse {
  /// Creates a validation response.
  const ValidatePortalSessionResponse({
    required this.valid,
    required this.user,
    this.websiteConfig,
    this.checkoutConfig,
  });

  /// Creates from JSON.
  factory ValidatePortalSessionResponse.fromJson(Map<String, Object?> json) =>
      ValidatePortalSessionResponse(
        valid: json['valid'] as bool,
        user: PortalUser.fromJson(json['user'] as Map<String, Object?>),
        websiteConfig: json['websiteConfig'] != null
            ? PortalWebsiteConfig.fromJson(
                json['websiteConfig'] as Map<String, Object?>,
              )
            : null,
        checkoutConfig: json['checkoutConfig'] != null
            ? CheckoutConfig.fromJson(
                json['checkoutConfig'] as Map<String, Object?>,
              )
            : null,
      );

  /// Whether session is valid.
  final bool valid;

  /// Portal user.
  final PortalUser user;

  /// Website configuration.
  final PortalWebsiteConfig? websiteConfig;

  /// Checkout configuration.
  final CheckoutConfig? checkoutConfig;

  /// Converts to JSON.
  Map<String, Object?> toJson() => {
        'valid': valid,
        'user': user.toJson(),
        if (websiteConfig != null) 'websiteConfig': websiteConfig!.toJson(),
        if (checkoutConfig != null) 'checkoutConfig': checkoutConfig!.toJson(),
      };
}

/// Response from getting portal user.
class GetPortalUserResponse {
  /// Creates a user response.
  const GetPortalUserResponse({
    required this.user,
    this.websiteConfig,
  });

  /// Creates from JSON.
  factory GetPortalUserResponse.fromJson(Map<String, Object?> json) =>
      GetPortalUserResponse(
        user: PortalUser.fromJson(json['user'] as Map<String, Object?>),
        websiteConfig: json['websiteConfig'] != null
            ? PortalWebsiteConfig.fromJson(
                json['websiteConfig'] as Map<String, Object?>,
              )
            : null,
      );

  /// Portal user.
  final PortalUser user;

  /// Website configuration.
  final PortalWebsiteConfig? websiteConfig;

  /// Converts to JSON.
  Map<String, Object?> toJson() => {
        'user': user.toJson(),
        if (websiteConfig != null) 'websiteConfig': websiteConfig!.toJson(),
      };
}

/// Response from refreshing a portal session.
class RefreshPortalSessionResponse {
  /// Creates a refresh response.
  const RefreshPortalSessionResponse({
    required this.sessionToken,
    required this.expiresAt,
  });

  /// Creates from JSON.
  factory RefreshPortalSessionResponse.fromJson(Map<String, Object?> json) =>
      RefreshPortalSessionResponse(
        sessionToken: json['sessionToken'] as String,
        expiresAt: json['expiresAt'] as String,
      );

  /// New session token.
  final String sessionToken;

  /// New expiration (ISO 8601).
  final String expiresAt;

  /// Converts to JSON.
  Map<String, Object?> toJson() => {
        'sessionToken': sessionToken,
        'expiresAt': expiresAt,
      };
}

/// Response from logging out of portal.
class PortalLogoutResponse {
  /// Creates a logout response.
  const PortalLogoutResponse({
    required this.success,
  });

  /// Creates from JSON.
  factory PortalLogoutResponse.fromJson(Map<String, Object?> json) =>
      PortalLogoutResponse(
        success: json['success'] as bool,
      );

  /// Whether logout was successful.
  final bool success;

  /// Converts to JSON.
  Map<String, Object?> toJson() => {
        'success': success,
      };
}
