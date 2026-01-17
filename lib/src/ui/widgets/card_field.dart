/// Card input field widget for the FAM SDK.
///
/// A single-line card input field similar to Stripe's CardField.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/fam_theme.dart';

/// Card details collected by [FamCardField].
class CardFieldInputDetails {
  /// Creates card details.
  const CardFieldInputDetails({
    required this.complete,
    this.number,
    this.expiryMonth,
    this.expiryYear,
    this.cvc,
    this.postalCode,
    this.brand,
  });

  /// Whether all required fields are complete and valid.
  final bool complete;

  /// Masked card number (last 4 digits visible).
  final String? number;

  /// Expiry month (1-12).
  final int? expiryMonth;

  /// Expiry year (4 digits).
  final int? expiryYear;

  /// CVC/CVV code.
  final String? cvc;

  /// Postal/ZIP code (if collected).
  final String? postalCode;

  /// Detected card brand.
  final CardBrand? brand;
}

/// Card brand detection.
enum CardBrand {
  /// Visa
  visa,

  /// Mastercard
  mastercard,

  /// American Express
  amex,

  /// Discover
  discover,

  /// Diners Club
  diners,

  /// JCB
  jcb,

  /// UnionPay
  unionPay,

  /// Unknown brand
  unknown,
}

/// A single-line card input field.
///
/// Collects card number, expiry date, and CVC in a single row.
///
/// ```dart
/// FamCardField(
///   onCardChanged: (details) {
///     if (details.complete) {
///       print('Card is valid: ${details.brand}');
///     }
///   },
/// )
/// ```
class FamCardField extends StatefulWidget {
  /// Creates a card field.
  const FamCardField({
    super.key,
    this.onCardChanged,
    this.onFocusChanged,
    this.enablePostalCode = false,
    this.countryCode,
    this.placeholder,
    this.autofocus = false,
    this.enabled = true,
    this.theme,
  });

  /// Called when card details change.
  final ValueChanged<CardFieldInputDetails>? onCardChanged;

  /// Called when focus changes.
  final ValueChanged<bool>? onFocusChanged;

  /// Whether to show postal code field.
  final bool enablePostalCode;

  /// Country code for postal code formatting.
  final String? countryCode;

  /// Placeholder configuration.
  final CardFieldPlaceholder? placeholder;

  /// Whether to autofocus on mount.
  final bool autofocus;

  /// Whether the field is enabled.
  final bool enabled;

  /// Custom theme.
  final FamTheme? theme;

  @override
  State<FamCardField> createState() => _FamCardFieldState();
}

/// Placeholder text configuration.
class CardFieldPlaceholder {
  /// Creates placeholder configuration.
  const CardFieldPlaceholder({
    this.number = '4242 4242 4242 4242',
    this.expiry = 'MM/YY',
    this.cvc = 'CVC',
    this.postalCode = 'ZIP',
  });

  /// Card number placeholder.
  final String number;

  /// Expiry placeholder.
  final String expiry;

  /// CVC placeholder.
  final String cvc;

  /// Postal code placeholder.
  final String postalCode;
}

class _FamCardFieldState extends State<FamCardField> {
  final _numberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvcController = TextEditingController();
  final _postalController = TextEditingController();

  final _numberFocus = FocusNode();
  final _expiryFocus = FocusNode();
  final _cvcFocus = FocusNode();
  final _postalFocus = FocusNode();

  CardBrand _brand = CardBrand.unknown;
  bool _hasFocus = false;

  String? _numberError;
  String? _expiryError;
  String? _cvcError;

  @override
  void initState() {
    super.initState();
    _numberController.addListener(_onNumberChanged);
    _expiryController.addListener(_onExpiryChanged);
    _cvcController.addListener(_onCvcChanged);
    _postalController.addListener(_onChanged);

    _numberFocus.addListener(_onFocusChanged);
    _expiryFocus.addListener(_onFocusChanged);
    _cvcFocus.addListener(_onFocusChanged);
    _postalFocus.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _numberController.dispose();
    _expiryController.dispose();
    _cvcController.dispose();
    _postalController.dispose();
    _numberFocus.dispose();
    _expiryFocus.dispose();
    _cvcFocus.dispose();
    _postalFocus.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    final hasFocus = _numberFocus.hasFocus ||
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

    // Auto-advance to expiry when complete
    if (number.length >= 16) {
      _expiryFocus.requestFocus();
    }

    _onChanged();
  }

  void _onExpiryChanged() {
    final expiry = _expiryController.text.replaceAll('/', '');

    // Auto-advance to CVC when complete
    if (expiry.length >= 4) {
      _cvcFocus.requestFocus();
    }

    _onChanged();
  }

  void _onCvcChanged() {
    final cvc = _cvcController.text;
    final maxLength = _brand == CardBrand.amex ? 4 : 3;

    // Auto-advance to postal when complete
    if (cvc.length >= maxLength && widget.enablePostalCode) {
      _postalFocus.requestFocus();
    }

    _onChanged();
  }

  void _onChanged() {
    final details = _getCardDetails();
    widget.onCardChanged?.call(details);
  }

  CardFieldInputDetails _getCardDetails() {
    final number = _numberController.text.replaceAll(' ', '');
    final expiry = _expiryController.text;
    final cvc = _cvcController.text;
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
        } else if (yearPart.length == 4) {
          expiryYear = int.tryParse(yearPart);
        }
      }
    }

    final isNumberValid = _validateNumber(number);
    final isExpiryValid = _validateExpiry(expiryMonth, expiryYear);
    final isCvcValid = _validateCvc(cvc);
    final isPostalValid = !widget.enablePostalCode || postal.isNotEmpty;

    final complete =
        isNumberValid && isExpiryValid && isCvcValid && isPostalValid;

    return CardFieldInputDetails(
      complete: complete,
      number: number.length >= 4
          ? '•••• ${number.substring(number.length - 4)}'
          : null,
      expiryMonth: expiryMonth,
      expiryYear: expiryYear,
      cvc: cvc.isNotEmpty ? '•' * cvc.length : null,
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
    if (number.startsWith('6011') ||
        number.startsWith('65') ||
        number.startsWith('644') ||
        number.startsWith('645') ||
        number.startsWith('646') ||
        number.startsWith('647') ||
        number.startsWith('648') ||
        number.startsWith('649')) {
      return CardBrand.discover;
    }
    if (number.startsWith('36') ||
        number.startsWith('38') ||
        number.startsWith('39') ||
        number.startsWith('300') ||
        number.startsWith('301') ||
        number.startsWith('302') ||
        number.startsWith('303') ||
        number.startsWith('304') ||
        number.startsWith('305')) {
      return CardBrand.diners;
    }
    if (number.startsWith('35')) return CardBrand.jcb;
    if (number.startsWith('62')) return CardBrand.unionPay;

    return CardBrand.unknown;
  }

  Widget _buildBrandIcon() {
    IconData icon;
    Color color;

    switch (_brand) {
      case CardBrand.visa:
        icon = Icons.credit_card;
        color = const Color(0xFF1A1F71);
      case CardBrand.mastercard:
        icon = Icons.credit_card;
        color = const Color(0xFFEB001B);
      case CardBrand.amex:
        icon = Icons.credit_card;
        color = const Color(0xFF006FCF);
      default:
        icon = Icons.credit_card;
        color = Colors.grey;
    }

    return Icon(icon, color: color, size: 24);
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme ?? FamThemeProvider.of(context);
    final placeholder = widget.placeholder ?? const CardFieldPlaceholder();

    return Container(
      decoration: BoxDecoration(
        color: theme.surfaceColor,
        borderRadius: BorderRadius.circular(theme.borderRadius),
        border: Border.all(
          color: _hasFocus ? theme.focusBorderColor : theme.borderColor,
          width: _hasFocus ? theme.borderWidth * 2 : theme.borderWidth,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          _buildBrandIcon(),
          const SizedBox(width: 12),
          Expanded(
            flex: 4,
            child: TextField(
              controller: _numberController,
              focusNode: _numberFocus,
              enabled: widget.enabled,
              autofocus: widget.autofocus,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                _CardNumberFormatter(),
              ],
              decoration: InputDecoration(
                hintText: placeholder.number,
                hintStyle: theme.getEffectiveHintStyle(context),
                border: InputBorder.none,
                errorText: _numberError,
              ),
              style: theme.getEffectiveInputStyle(context),
            ),
          ),
          Expanded(
            flex: 2,
            child: TextField(
              controller: _expiryController,
              focusNode: _expiryFocus,
              enabled: widget.enabled,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                _ExpiryFormatter(),
              ],
              decoration: InputDecoration(
                hintText: placeholder.expiry,
                hintStyle: theme.getEffectiveHintStyle(context),
                border: InputBorder.none,
                errorText: _expiryError,
              ),
              style: theme.getEffectiveInputStyle(context),
            ),
          ),
          Expanded(
            flex: 2,
            child: TextField(
              controller: _cvcController,
              focusNode: _cvcFocus,
              enabled: widget.enabled,
              keyboardType: TextInputType.number,
              obscureText: true,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(
                    _brand == CardBrand.amex ? 4 : 3),
              ],
              decoration: InputDecoration(
                hintText: placeholder.cvc,
                hintStyle: theme.getEffectiveHintStyle(context),
                border: InputBorder.none,
                errorText: _cvcError,
              ),
              style: theme.getEffectiveInputStyle(context),
            ),
          ),
          if (widget.enablePostalCode)
            Expanded(
              flex: 2,
              child: TextField(
                controller: _postalController,
                focusNode: _postalFocus,
                enabled: widget.enabled,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.characters,
                decoration: InputDecoration(
                  hintText: placeholder.postalCode,
                  hintStyle: theme.getEffectiveHintStyle(context),
                  border: InputBorder.none,
                ),
                style: theme.getEffectiveInputStyle(context),
              ),
            ),
        ],
      ),
    );
  }
}

class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(' ', '');
    if (text.length > 16) {
      return oldValue;
    }

    final buffer = StringBuffer();
    for (var i = 0; i < text.length; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write(' ');
      }
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
    if (text.length > 4) {
      return oldValue;
    }

    final buffer = StringBuffer();
    for (var i = 0; i < text.length; i++) {
      if (i == 2) {
        buffer.write('/');
      }
      buffer.write(text[i]);
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}
