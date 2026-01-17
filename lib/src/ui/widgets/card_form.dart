/// Card form widget for the FAM SDK.
///
/// A multi-field card form with separate inputs for each field.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/fam_theme.dart';
import 'card_field.dart';

/// Card form details.
class CardFormDetails {
  /// Creates card form details.
  const CardFormDetails({
    required this.complete,
    this.cardNumber,
    this.expiryMonth,
    this.expiryYear,
    this.cvc,
    this.cardholderName,
    this.postalCode,
    this.country,
    this.brand,
  });

  /// Whether all fields are complete and valid.
  final bool complete;

  /// Full card number.
  final String? cardNumber;

  /// Expiry month.
  final int? expiryMonth;

  /// Expiry year.
  final int? expiryYear;

  /// CVC code.
  final String? cvc;

  /// Cardholder name.
  final String? cardholderName;

  /// Postal code.
  final String? postalCode;

  /// Country code.
  final String? country;

  /// Card brand.
  final CardBrand? brand;
}

/// Card form style options.
enum CardFormStyle {
  /// Standard vertical form.
  standard,

  /// Compact horizontal layout.
  compact,

  /// Borderless minimal style.
  borderless,
}

/// A multi-field card input form.
///
/// Provides separate inputs for card number, expiry, CVC,
/// and optionally cardholder name and billing address.
///
/// ```dart
/// FamCardForm(
///   style: CardFormStyle.standard,
///   enableCardholderName: true,
///   enablePostalCode: true,
///   onCardChanged: (details) {
///     if (details.complete) {
///       // Enable submit button
///     }
///   },
/// )
/// ```
class FamCardForm extends StatefulWidget {
  /// Creates a card form.
  const FamCardForm({
    super.key,
    this.style = CardFormStyle.standard,
    this.onCardChanged,
    this.onFocusChanged,
    this.enableCardholderName = false,
    this.enablePostalCode = false,
    this.countryCode,
    this.autofocus = false,
    this.enabled = true,
    this.theme,
    this.cardNumberLabel = 'Card number',
    this.expiryLabel = 'Expiry date',
    this.cvcLabel = 'CVC',
    this.cardholderNameLabel = 'Name on card',
    this.postalCodeLabel = 'ZIP / Postal code',
  });

  /// Form style.
  final CardFormStyle style;

  /// Called when card details change.
  final ValueChanged<CardFormDetails>? onCardChanged;

  /// Called when focus changes.
  final ValueChanged<bool>? onFocusChanged;

  /// Whether to show cardholder name field.
  final bool enableCardholderName;

  /// Whether to show postal code field.
  final bool enablePostalCode;

  /// Country code for formatting.
  final String? countryCode;

  /// Whether to autofocus.
  final bool autofocus;

  /// Whether the form is enabled.
  final bool enabled;

  /// Custom theme.
  final FamTheme? theme;

  /// Card number field label.
  final String cardNumberLabel;

  /// Expiry field label.
  final String expiryLabel;

  /// CVC field label.
  final String cvcLabel;

  /// Cardholder name field label.
  final String cardholderNameLabel;

  /// Postal code field label.
  final String postalCodeLabel;

  @override
  State<FamCardForm> createState() => _FamCardFormState();
}

class _FamCardFormState extends State<FamCardForm> {
  final _nameController = TextEditingController();
  final _numberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvcController = TextEditingController();
  final _postalController = TextEditingController();

  final _nameFocus = FocusNode();
  final _numberFocus = FocusNode();
  final _expiryFocus = FocusNode();
  final _cvcFocus = FocusNode();
  final _postalFocus = FocusNode();

  CardBrand _brand = CardBrand.unknown;
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();

    _nameController.addListener(_onChanged);
    _numberController.addListener(_onNumberChanged);
    _expiryController.addListener(_onChanged);
    _cvcController.addListener(_onChanged);
    _postalController.addListener(_onChanged);

    for (final focus in [
      _nameFocus,
      _numberFocus,
      _expiryFocus,
      _cvcFocus,
      _postalFocus,
    ]) {
      focus.addListener(_onFocusChanged);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _numberController.dispose();
    _expiryController.dispose();
    _cvcController.dispose();
    _postalController.dispose();
    _nameFocus.dispose();
    _numberFocus.dispose();
    _expiryFocus.dispose();
    _cvcFocus.dispose();
    _postalFocus.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    final hasFocus = _nameFocus.hasFocus ||
        _numberFocus.hasFocus ||
        _expiryFocus.hasFocus ||
        _cvcFocus.hasFocus ||
        _postalFocus.hasFocus;

    if (hasFocus != _hasFocus) {
      setState(() => _hasFocus = hasFocus);
      widget.onFocusChanged?.call(hasFocus);
    }
  }

  void _onNumberChanged() {
    final number = _numberController.text.replaceAll(' ', '');
    final brand = _detectBrand(number);

    if (brand != _brand) {
      setState(() => _brand = brand);
    }

    _onChanged();
  }

  void _onChanged() {
    final details = _getFormDetails();
    widget.onCardChanged?.call(details);
  }

  CardFormDetails _getFormDetails() {
    final number = _numberController.text.replaceAll(' ', '');
    final expiry = _expiryController.text;
    final cvc = _cvcController.text;
    final name = _nameController.text;
    final postal = _postalController.text;

    int? expiryMonth;
    int? expiryYear;

    if (expiry.contains('/')) {
      final parts = expiry.split('/');
      if (parts.length == 2) {
        expiryMonth = int.tryParse(parts[0]);
        final yearPart = parts[1];
        if (yearPart.length == 2) {
          expiryYear = 2000 + (int.tryParse(yearPart) ?? 0);
        }
      }
    }

    final isNumberValid = _validateNumber(number);
    final isExpiryValid = _validateExpiry(expiryMonth, expiryYear);
    final isCvcValid = _validateCvc(cvc);
    final isNameValid = !widget.enableCardholderName || name.trim().isNotEmpty;
    final isPostalValid = !widget.enablePostalCode || postal.trim().isNotEmpty;

    final complete = isNumberValid &&
        isExpiryValid &&
        isCvcValid &&
        isNameValid &&
        isPostalValid;

    return CardFormDetails(
      complete: complete,
      cardNumber: number,
      expiryMonth: expiryMonth,
      expiryYear: expiryYear,
      cvc: cvc,
      cardholderName: name.isNotEmpty ? name : null,
      postalCode: postal.isNotEmpty ? postal : null,
      brand: _brand,
    );
  }

  bool _validateNumber(String number) {
    if (number.length < 13 || number.length > 19) return false;
    return _luhnCheck(number);
  }

  bool _validateExpiry(int? month, int? year) {
    if (month == null || year == null) return false;
    if (month < 1 || month > 12) return false;
    final now = DateTime.now();
    final expiry = DateTime(year, month + 1);
    return expiry.isAfter(now);
  }

  bool _validateCvc(String cvc) {
    final minLength = _brand == CardBrand.amex ? 4 : 3;
    return cvc.length >= minLength;
  }

  bool _luhnCheck(String number) {
    var sum = 0;
    var alternate = false;
    for (var i = number.length - 1; i >= 0; i--) {
      var digit = int.parse(number[i]);
      if (alternate) {
        digit *= 2;
        if (digit > 9) digit -= 9;
      }
      sum += digit;
      alternate = !alternate;
    }
    return sum % 10 == 0;
  }

  CardBrand _detectBrand(String number) {
    if (number.isEmpty) return CardBrand.unknown;
    if (number.startsWith('4')) return CardBrand.visa;
    if (number.startsWith('34') || number.startsWith('37')) {
      return CardBrand.amex;
    }
    if (number.startsWith('5') ||
        (number.length >= 4 &&
            int.parse(number.substring(0, 4)) >= 2221 &&
            int.parse(number.substring(0, 4)) <= 2720)) {
      return CardBrand.mastercard;
    }
    if (number.startsWith('6011') || number.startsWith('65')) {
      return CardBrand.discover;
    }
    return CardBrand.unknown;
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme ?? FamThemeProvider.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Cardholder name
        if (widget.enableCardholderName) ...[
          _buildField(
            context,
            theme: theme,
            label: widget.cardholderNameLabel,
            controller: _nameController,
            focusNode: _nameFocus,
            autofocus: widget.autofocus,
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            hintText: 'John Doe',
          ),
          const SizedBox(height: 16),
        ],

        // Card number
        _buildField(
          context,
          theme: theme,
          label: widget.cardNumberLabel,
          controller: _numberController,
          focusNode: _numberFocus,
          autofocus: !widget.enableCardholderName && widget.autofocus,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            _CardNumberFormatter(),
          ],
          hintText: '4242 4242 4242 4242',
          suffixIcon: _buildBrandIcon(),
        ),
        const SizedBox(height: 16),

        // Expiry and CVC row
        Row(
          children: [
            Expanded(
              child: _buildField(
                context,
                theme: theme,
                label: widget.expiryLabel,
                controller: _expiryController,
                focusNode: _expiryFocus,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  _ExpiryFormatter(),
                ],
                hintText: 'MM/YY',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildField(
                context,
                theme: theme,
                label: widget.cvcLabel,
                controller: _cvcController,
                focusNode: _cvcFocus,
                keyboardType: TextInputType.number,
                obscureText: true,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(
                    _brand == CardBrand.amex ? 4 : 3,
                  ),
                ],
                hintText: _brand == CardBrand.amex ? '1234' : '123',
              ),
            ),
          ],
        ),

        // Postal code
        if (widget.enablePostalCode) ...[
          const SizedBox(height: 16),
          _buildField(
            context,
            theme: theme,
            label: widget.postalCodeLabel,
            controller: _postalController,
            focusNode: _postalFocus,
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.characters,
            hintText: '12345',
          ),
        ],
      ],
    );
  }

  Widget _buildField(
    BuildContext context, {
    required FamTheme theme,
    required String label,
    required TextEditingController controller,
    required FocusNode focusNode,
    bool autofocus = false,
    TextInputType? keyboardType,
    TextCapitalization textCapitalization = TextCapitalization.none,
    List<TextInputFormatter>? inputFormatters,
    String? hintText,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: theme.getEffectiveLabelStyle(context)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          focusNode: focusNode,
          enabled: widget.enabled,
          autofocus: autofocus,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          inputFormatters: inputFormatters,
          obscureText: obscureText,
          decoration: theme.getInputDecoration(
            hintText: hintText,
            suffixIcon: suffixIcon,
          ),
          style: theme.getEffectiveInputStyle(context),
        ),
      ],
    );
  }

  Widget? _buildBrandIcon() {
    if (_brand == CardBrand.unknown) return null;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Icon(
        Icons.credit_card,
        color: _getBrandColor(),
        size: 24,
      ),
    );
  }

  Color _getBrandColor() {
    switch (_brand) {
      case CardBrand.visa:
        return const Color(0xFF1A1F71);
      case CardBrand.mastercard:
        return const Color(0xFFEB001B);
      case CardBrand.amex:
        return const Color(0xFF006FCF);
      default:
        return Colors.grey;
    }
  }
}

class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(' ', '');
    if (text.length > 16) return oldValue;

    final buffer = StringBuffer();
    for (var i = 0; i < text.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(text[i]);
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

class _ExpiryFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll('/', '');
    if (text.length > 4) return oldValue;

    final buffer = StringBuffer();
    for (var i = 0; i < text.length; i++) {
      if (i == 2) buffer.write('/');
      buffer.write(text[i]);
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}
