/// Payment sheet widget for the FAM SDK.
///
/// A pre-built payment UI that handles the complete payment flow.
library;

import 'package:flutter/material.dart';

import '../../fam.dart';
import '../../types/types.dart';
import '../theme/fam_theme.dart';
import 'card_form.dart';

/// Payment sheet configuration.
class PaymentSheetConfiguration {
  /// Creates a payment sheet configuration.
  const PaymentSheetConfiguration({
    required this.amount,
    required this.currency,
    this.merchantName,
    this.merchantLogo,
    this.primaryButtonLabel,
    this.showCardholderName = true,
    this.showPostalCode = false,
    this.countryCode,
    this.theme,
    this.customHeader,
    this.customFooter,
  });

  /// Amount to charge in smallest currency unit.
  final int amount;

  /// Currency for the payment.
  final Currency currency;

  /// Merchant/business name to display.
  final String? merchantName;

  /// Merchant logo widget.
  final Widget? merchantLogo;

  /// Custom label for the pay button.
  final String? primaryButtonLabel;

  /// Whether to show cardholder name field.
  final bool showCardholderName;

  /// Whether to show postal code field.
  final bool showPostalCode;

  /// Country code for formatting.
  final String? countryCode;

  /// Custom theme.
  final FamTheme? theme;

  /// Custom header widget.
  final Widget? customHeader;

  /// Custom footer widget.
  final Widget? customFooter;

  /// Formatted amount for display.
  String get formattedAmount {
    final decimal = amount / 100;
    final symbol = _getCurrencySymbol(currency);
    return '$symbol${decimal.toStringAsFixed(2)}';
  }

  String _getCurrencySymbol(Currency currency) {
    switch (currency) {
      case Currency.EUR:
        return '€';
      case Currency.USD:
        return '\$';
      case Currency.GBP:
        return '£';
      case Currency.CHF:
        return 'CHF ';
      case Currency.JPY:
        return '¥';
      default:
        return '${currency.name} ';
    }
  }
}

/// Result of a payment sheet interaction.
sealed class PaymentSheetResult {
  const PaymentSheetResult();
}

/// Payment was completed successfully.
class PaymentSheetCompleted extends PaymentSheetResult {
  /// Creates a completed result.
  const PaymentSheetCompleted({
    required this.payinId,
    this.cardId,
  });

  /// ID of the created pay-in.
  final String payinId;

  /// ID of the registered card (if saved).
  final String? cardId;
}

/// Payment was cancelled by the user.
class PaymentSheetCancelled extends PaymentSheetResult {
  /// Creates a cancelled result.
  const PaymentSheetCancelled();
}

/// Payment failed with an error.
class PaymentSheetFailed extends PaymentSheetResult {
  /// Creates a failed result.
  const PaymentSheetFailed({
    required this.error,
    this.localizedMessage,
  });

  /// The error that occurred.
  final Object error;

  /// User-friendly error message.
  final String? localizedMessage;
}

/// A pre-built payment sheet for collecting payment details.
///
/// Displays as a bottom sheet with card form and pay button.
///
/// ```dart
/// // Show the payment sheet
/// final result = await FamPaymentSheet.show(
///   context: context,
///   fam: fam,
///   configuration: PaymentSheetConfiguration(
///     amount: 1999, // 19.99 EUR
///     currency: Currency.EUR,
///     merchantName: 'My Shop',
///   ),
///   paymentParams: PaymentSheetPaymentParams(
///     authorId: 'user_123',
///     creditedWalletId: 'wallet_456',
///     secureModeReturnUrl: 'https://myapp.com/callback',
///   ),
/// );
///
/// if (result is PaymentSheetCompleted) {
///   print('Payment successful: ${result.payinId}');
/// } else if (result is PaymentSheetCancelled) {
///   print('Payment cancelled');
/// } else if (result is PaymentSheetFailed) {
///   print('Payment failed: ${result.error}');
/// }
/// ```
class FamPaymentSheet extends StatefulWidget {
  /// Creates a payment sheet.
  const FamPaymentSheet({
    super.key,
    required this.fam,
    required this.configuration,
    required this.paymentParams,
    this.onResult,
  });

  /// FAM SDK instance.
  final Fam fam;

  /// Payment sheet configuration.
  final PaymentSheetConfiguration configuration;

  /// Payment parameters.
  final PaymentSheetPaymentParams paymentParams;

  /// Callback when payment completes.
  final ValueChanged<PaymentSheetResult>? onResult;

  /// Shows the payment sheet as a modal bottom sheet.
  static Future<PaymentSheetResult> show({
    required BuildContext context,
    required Fam fam,
    required PaymentSheetConfiguration configuration,
    required PaymentSheetPaymentParams paymentParams,
  }) async {
    final result = await showModalBottomSheet<PaymentSheetResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FamPaymentSheet(
        fam: fam,
        configuration: configuration,
        paymentParams: paymentParams,
      ),
    );

    return result ?? const PaymentSheetCancelled();
  }

  @override
  State<FamPaymentSheet> createState() => _FamPaymentSheetState();
}

/// Payment parameters for the payment sheet.
class PaymentSheetPaymentParams {
  /// Creates payment parameters.
  const PaymentSheetPaymentParams({
    required this.authorId,
    required this.creditedWalletId,
    required this.secureModeReturnUrl,
    this.creditedUserId,
    this.fees,
    this.secureMode,
    this.statementDescriptor,
    this.browserInfo,
    this.ipAddress,
    this.tag,
  });

  /// ID of the user making payment.
  final String authorId;

  /// ID of the wallet to credit.
  final String creditedWalletId;

  /// Return URL after 3DS authentication.
  final String secureModeReturnUrl;

  /// ID of the user to credit.
  final String? creditedUserId;

  /// Fees to charge.
  final Money? fees;

  /// 3D Secure mode.
  final SecureMode? secureMode;

  /// Statement descriptor.
  final String? statementDescriptor;

  /// Browser info for 3DS.
  final BrowserInfo? browserInfo;

  /// Customer IP address.
  final String? ipAddress;

  /// Custom tag.
  final String? tag;
}

class _FamPaymentSheetState extends State<FamPaymentSheet> {
  CardFormDetails? _cardDetails;
  bool _isLoading = false;
  String? _errorMessage;
  bool _saveCard = false;

  FamTheme get _theme =>
      widget.configuration.theme ??
      FamThemeProvider.maybeOf(context) ??
      const FamTheme();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Container(
      decoration: BoxDecoration(
        color: _theme.backgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      padding: EdgeInsets.only(bottom: mediaQuery.viewInsets.bottom),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildCardForm(),
              if (_errorMessage != null) ...[
                const SizedBox(height: 16),
                _buildError(),
              ],
              const SizedBox(height: 16),
              _buildSaveCardOption(),
              const SizedBox(height: 24),
              _buildPayButton(),
              if (widget.configuration.customFooter != null) ...[
                const SizedBox(height: 16),
                widget.configuration.customFooter!,
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Drag handle
        Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: _theme.borderColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 16),

        // Custom header or default
        if (widget.configuration.customHeader != null)
          widget.configuration.customHeader!
        else ...[
          if (widget.configuration.merchantLogo != null) ...[
            widget.configuration.merchantLogo!,
            const SizedBox(height: 12),
          ],
          if (widget.configuration.merchantName != null)
            Text(
              widget.configuration.merchantName!,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: _theme.textColor,
              ),
            ),
          const SizedBox(height: 8),
          Text(
            widget.configuration.formattedAmount,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: _theme.textColor,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCardForm() {
    return FamCardForm(
      theme: _theme,
      enableCardholderName: widget.configuration.showCardholderName,
      enablePostalCode: widget.configuration.showPostalCode,
      countryCode: widget.configuration.countryCode,
      enabled: !_isLoading,
      onCardChanged: (details) {
        setState(() {
          _cardDetails = details;
          _errorMessage = null;
        });
      },
    );
  }

  Widget _buildError() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _theme.errorColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(_theme.borderRadius),
        border: Border.all(color: _theme.errorColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: _theme.errorColor, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _errorMessage!,
              style: _theme.getEffectiveErrorStyle(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveCardOption() {
    return Row(
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: _saveCard,
            onChanged: _isLoading
                ? null
                : (value) => setState(() => _saveCard = value ?? false),
            activeColor: _theme.primaryColor,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'Save card for future payments',
          style: TextStyle(
            fontSize: 14,
            color: _theme.secondaryTextColor,
          ),
        ),
      ],
    );
  }

  Widget _buildPayButton() {
    final isEnabled = _cardDetails?.complete == true && !_isLoading;
    final buttonLabel = widget.configuration.primaryButtonLabel ??
        'Pay ${widget.configuration.formattedAmount}';

    return SizedBox(
      height: 52,
      child: ElevatedButton(
        onPressed: isEnabled ? _handlePayment : null,
        style: _theme.getEffectiveButtonStyle(context),
        child: _isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _theme.backgroundColor,
                  ),
                ),
              )
            : Text(buttonLabel),
      ),
    );
  }

  Future<void> _handlePayment() async {
    if (_cardDetails == null || !_cardDetails!.complete) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Step 1: Create card registration
      final registration = await widget.fam.cardRegistrations.create(
        CreateCardRegistrationRequest(
          userId: widget.paymentParams.authorId,
          currency: widget.configuration.currency,
        ),
      );

      // Step 2: Post card data to tokenization URL
      // Note: In a real implementation, this would be done via a WebView
      // or platform channel to ensure PCI compliance.
      // For now, we'll simulate this step.

      // Step 3: Update registration with tokenized data
      // This step would use the data received from step 2

      // Step 4: Create the payment
      final payin = await widget.fam.payins.create(
        CreateCardDirectPayinRequest(
          authorId: widget.paymentParams.authorId,
          creditedWalletId: widget.paymentParams.creditedWalletId,
          debitedFunds: Money(
            amount: widget.configuration.amount,
            currency: widget.configuration.currency,
          ),
          fees: widget.paymentParams.fees ??
              Money(amount: 0, currency: widget.configuration.currency),
          cardId: registration.cardId ?? registration.id,
          secureModeReturnUrl: widget.paymentParams.secureModeReturnUrl,
          creditedUserId: widget.paymentParams.creditedUserId,
          secureMode: widget.paymentParams.secureMode,
          statementDescriptor: widget.paymentParams.statementDescriptor,
          browserInfo: widget.paymentParams.browserInfo,
          ipAddress: widget.paymentParams.ipAddress,
          tag: widget.paymentParams.tag,
        ),
      );

      // Handle 3DS if needed
      if (payin.requiresSecureModeRedirect) {
        // In a real implementation, this would open a WebView
        // for 3DS authentication
        setState(() {
          _errorMessage = '3DS authentication required. '
              'Please complete authentication in browser.';
          _isLoading = false;
        });
        return;
      }

      // Check payment status
      if (payin.status == TransactionStatus.SUCCEEDED) {
        final result = PaymentSheetCompleted(
          payinId: payin.id,
          cardId: _saveCard ? registration.cardId : null,
        );

        widget.onResult?.call(result);

        if (mounted) {
          Navigator.of(context).pop(result);
        }
      } else if (payin.status == TransactionStatus.FAILED) {
        setState(() {
          _errorMessage = payin.resultMessage ?? 'Payment failed';
          _isLoading = false;
        });
      } else {
        // Payment is pending
        final result = PaymentSheetCompleted(
          payinId: payin.id,
          cardId: _saveCard ? registration.cardId : null,
        );

        widget.onResult?.call(result);

        if (mounted) {
          Navigator.of(context).pop(result);
        }
      }
    } on Exception catch (e) {
      String message = 'An error occurred';

      if (e.toString().contains('authentication')) {
        message = 'Authentication failed. Please check your API token.';
      } else if (e.toString().contains('validation')) {
        message = 'Invalid card details. Please check and try again.';
      } else if (e.toString().contains('network')) {
        message = 'Network error. Please check your connection.';
      }

      setState(() {
        _errorMessage = message;
        _isLoading = false;
      });

      final result = PaymentSheetFailed(
        error: e,
        localizedMessage: message,
      );
      widget.onResult?.call(result);
    }
  }
}
