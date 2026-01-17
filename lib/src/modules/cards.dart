/// Cards module for the FAM SDK.
///
/// Provides methods for card registration, management, and preauthorizations.
library;

import 'package:fam_sdk/src/client.dart';
import 'package:fam_sdk/src/modules/base.dart';
import 'package:fam_sdk/src/types/types.dart';

/// Module for card registration operations.
///
/// ```dart
/// // Create a card registration
/// final registration = await fam.cardRegistrations.create(
///   CreateCardRegistrationRequest(
///     userId: 'user_123',
///     currency: Currency.EUR,
///   ),
/// );
///
/// // Client-side: Post card data to registration.cardRegistrationUrl
/// // with accessKey and preregistrationData
///
/// // Update with the received registrationData
/// final updated = await fam.cardRegistrations.update(
///   registration.id,
///   UpdateCardRegistrationRequest(registrationData: receivedData),
/// );
///
/// // The card ID is now available
/// print('Card ID: ${updated.cardId}');
/// ```
class CardRegistrationsModule extends BaseModule {
  /// Creates a card registrations module.
  const CardRegistrationsModule(HttpClient client)
      : super(client, '/api/v1/mangopay/cardRegistrations');

  /// Creates a new card registration.
  Future<CardRegistration> create(CreateCardRegistrationRequest data) => post(
        '',
        body: data.toJson(),
        fromJson: (json) =>
            CardRegistration.fromJson(json! as Map<String, Object?>),
      );

  /// Gets a card registration by ID.
  Future<CardRegistration> getRegistration(String registrationId) => get(
        '/$registrationId',
        fromJson: (json) =>
            CardRegistration.fromJson(json! as Map<String, Object?>),
      );

  /// Updates a card registration with registration data.
  Future<CardRegistration> update(
    String registrationId,
    UpdateCardRegistrationRequest data,
  ) =>
      put(
        '/$registrationId',
        body: data.toJson(),
        fromJson: (json) =>
            CardRegistration.fromJson(json! as Map<String, Object?>),
      );
}

/// Module for card operations.
///
/// ```dart
/// // Get a card
/// final card = await fam.cards.getCard('card_123');
///
/// // Deactivate a card
/// await fam.cards.deactivate('card_123');
/// ```
class CardsModule extends BaseModule {
  /// Creates a cards module.
  const CardsModule(HttpClient client) : super(client, '/api/v1/mangopay/cards');

  /// Gets a card by ID.
  Future<Card> getCard(String cardId) => get(
        '/$cardId',
        fromJson: (json) => Card.fromJson(json! as Map<String, Object?>),
      );

  /// Deactivates a card.
  ///
  /// This action is irreversible.
  Future<Card> deactivate(String cardId) => put(
        '/$cardId',
        body: {'Active': false},
        fromJson: (json) => Card.fromJson(json! as Map<String, Object?>),
      );

  /// Gets preauthorizations for a card.
  Future<PaginatedResponse<Preauthorization>> getPreauthorizations(
    String cardId, {
    PaginationParams? params,
  }) =>
      get(
        '/$cardId/preauthorizations',
        options: RequestOptions(params: params?.toQueryParams()),
        fromJson: (json) => PaginatedResponse.fromJson(
          json! as Map<String, Object?>,
          Preauthorization.fromJson,
        ),
      );
}

/// Module for preauthorization operations.
///
/// ```dart
/// // Create a preauthorization
/// final preauth = await fam.preauthorizations.create(
///   CreatePreauthorizationRequest(
///     authorId: 'user_123',
///     cardId: 'card_456',
///     debitedFunds: Money(amount: 5000, currency: Currency.EUR),
///     secureModeReturnUrl: 'https://example.com/callback',
///   ),
/// );
///
/// // Check if 3DS is needed
/// if (preauth.requiresSecureModeRedirect) {
///   // Redirect to preauth.secureModeRedirectUrl
/// }
/// ```
class PreauthorizationsModule extends BaseModule {
  /// Creates a preauthorizations module.
  const PreauthorizationsModule(HttpClient client)
      : super(client, '/api/v1/mangopay/preauthorizations');

  /// Creates a new preauthorization.
  Future<Preauthorization> create(CreatePreauthorizationRequest data) => post(
        '',
        body: data.toJson(),
        fromJson: (json) =>
            Preauthorization.fromJson(json! as Map<String, Object?>),
      );

  /// Gets a preauthorization by ID.
  Future<Preauthorization> getPreauthorization(String preauthId) => get(
        '/$preauthId',
        fromJson: (json) =>
            Preauthorization.fromJson(json! as Map<String, Object?>),
      );

  /// Cancels a preauthorization.
  Future<Preauthorization> cancel(String preauthId) => put(
        '/$preauthId',
        body: {'PaymentStatus': 'CANCELED'},
        fromJson: (json) =>
            Preauthorization.fromJson(json! as Map<String, Object?>),
      );
}
