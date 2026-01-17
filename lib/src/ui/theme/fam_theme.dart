/// Theme configuration for FAM UI components.
///
/// Provides customizable styling for all FAM payment widgets.
library;

import 'package:flutter/material.dart';

/// Theme data for FAM UI components.
///
/// ```dart
/// FamTheme(
///   primaryColor: Colors.blue,
///   backgroundColor: Colors.white,
///   errorColor: Colors.red,
///   borderRadius: 8.0,
/// )
/// ```
class FamTheme {
  /// Creates a FAM theme.
  const FamTheme({
    this.primaryColor = const Color(0xFF6772E5),
    this.backgroundColor = Colors.white,
    this.surfaceColor = const Color(0xFFF7F8F9),
    this.textColor = const Color(0xFF32325D),
    this.secondaryTextColor = const Color(0xFF8898AA),
    this.errorColor = const Color(0xFFFA755A),
    this.successColor = const Color(0xFF24B47E),
    this.borderColor = const Color(0xFFE6EBF1),
    this.focusBorderColor = const Color(0xFF6772E5),
    this.borderRadius = 8.0,
    this.borderWidth = 1.0,
    this.inputPadding = const EdgeInsets.symmetric(
      horizontal: 12.0,
      vertical: 16.0,
    ),
    this.fontFamily,
    this.labelStyle,
    this.inputStyle,
    this.hintStyle,
    this.errorStyle,
    this.buttonStyle,
    this.buttonTextStyle,
  });

  /// Creates a dark theme variant.
  factory FamTheme.dark() => const FamTheme(
        primaryColor: Color(0xFF7C8AFF),
        backgroundColor: Color(0xFF1A1F36),
        surfaceColor: Color(0xFF2A2F45),
        textColor: Color(0xFFFFFFFF),
        secondaryTextColor: Color(0xFFA3ACB9),
        borderColor: Color(0xFF3C4257),
        focusBorderColor: Color(0xFF7C8AFF),
      );

  /// Primary brand color.
  final Color primaryColor;

  /// Background color for cards/sheets.
  final Color backgroundColor;

  /// Surface color for input fields.
  final Color surfaceColor;

  /// Primary text color.
  final Color textColor;

  /// Secondary/hint text color.
  final Color secondaryTextColor;

  /// Error state color.
  final Color errorColor;

  /// Success state color.
  final Color successColor;

  /// Default border color.
  final Color borderColor;

  /// Focused border color.
  final Color focusBorderColor;

  /// Border radius for inputs and buttons.
  final double borderRadius;

  /// Border width.
  final double borderWidth;

  /// Padding inside input fields.
  final EdgeInsets inputPadding;

  /// Custom font family.
  final String? fontFamily;

  /// Custom label text style.
  final TextStyle? labelStyle;

  /// Custom input text style.
  final TextStyle? inputStyle;

  /// Custom hint text style.
  final TextStyle? hintStyle;

  /// Custom error text style.
  final TextStyle? errorStyle;

  /// Custom button style.
  final ButtonStyle? buttonStyle;

  /// Custom button text style.
  final TextStyle? buttonTextStyle;

  /// Gets the effective label style.
  TextStyle getEffectiveLabelStyle(BuildContext context) =>
      labelStyle ??
      TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textColor,
      );

  /// Gets the effective input style.
  TextStyle getEffectiveInputStyle(BuildContext context) =>
      inputStyle ??
      TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        color: textColor,
      );

  /// Gets the effective hint style.
  TextStyle getEffectiveHintStyle(BuildContext context) =>
      hintStyle ??
      TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        color: secondaryTextColor,
      );

  /// Gets the effective error style.
  TextStyle getEffectiveErrorStyle(BuildContext context) =>
      errorStyle ??
      TextStyle(
        fontFamily: fontFamily,
        fontSize: 12,
        color: errorColor,
      );

  /// Gets the default input decoration.
  InputDecoration getInputDecoration({
    String? labelText,
    String? hintText,
    String? errorText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    bool isFocused = false,
    bool hasError = false,
  }) =>
      InputDecoration(
        labelText: labelText,
        hintText: hintText,
        errorText: errorText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: hasError ? errorColor : borderColor,
            width: borderWidth,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: hasError ? errorColor : borderColor,
            width: borderWidth,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: hasError ? errorColor : focusBorderColor,
            width: borderWidth * 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: errorColor,
            width: borderWidth,
          ),
        ),
        contentPadding: inputPadding,
      );

  /// Gets the effective button style.
  ButtonStyle getEffectiveButtonStyle(BuildContext context) =>
      buttonStyle ??
      ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        textStyle: buttonTextStyle ??
            TextStyle(
              fontFamily: fontFamily,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
      );

  /// Creates a copy with updated values.
  FamTheme copyWith({
    Color? primaryColor,
    Color? backgroundColor,
    Color? surfaceColor,
    Color? textColor,
    Color? secondaryTextColor,
    Color? errorColor,
    Color? successColor,
    Color? borderColor,
    Color? focusBorderColor,
    double? borderRadius,
    double? borderWidth,
    EdgeInsets? inputPadding,
    String? fontFamily,
    TextStyle? labelStyle,
    TextStyle? inputStyle,
    TextStyle? hintStyle,
    TextStyle? errorStyle,
    ButtonStyle? buttonStyle,
    TextStyle? buttonTextStyle,
  }) =>
      FamTheme(
        primaryColor: primaryColor ?? this.primaryColor,
        backgroundColor: backgroundColor ?? this.backgroundColor,
        surfaceColor: surfaceColor ?? this.surfaceColor,
        textColor: textColor ?? this.textColor,
        secondaryTextColor: secondaryTextColor ?? this.secondaryTextColor,
        errorColor: errorColor ?? this.errorColor,
        successColor: successColor ?? this.successColor,
        borderColor: borderColor ?? this.borderColor,
        focusBorderColor: focusBorderColor ?? this.focusBorderColor,
        borderRadius: borderRadius ?? this.borderRadius,
        borderWidth: borderWidth ?? this.borderWidth,
        inputPadding: inputPadding ?? this.inputPadding,
        fontFamily: fontFamily ?? this.fontFamily,
        labelStyle: labelStyle ?? this.labelStyle,
        inputStyle: inputStyle ?? this.inputStyle,
        hintStyle: hintStyle ?? this.hintStyle,
        errorStyle: errorStyle ?? this.errorStyle,
        buttonStyle: buttonStyle ?? this.buttonStyle,
        buttonTextStyle: buttonTextStyle ?? this.buttonTextStyle,
      );
}

/// Inherited widget for providing FAM theme to descendants.
class FamThemeProvider extends InheritedWidget {
  /// Creates a theme provider.
  const FamThemeProvider({
    required this.theme,
    required super.child,
    super.key,
  });

  /// The theme to provide.
  final FamTheme theme;

  /// Gets the theme from the closest ancestor.
  static FamTheme of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<FamThemeProvider>();
    return provider?.theme ?? const FamTheme();
  }

  /// Gets the theme from the closest ancestor, or null if not found.
  static FamTheme? maybeOf(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<FamThemeProvider>();
    return provider?.theme;
  }

  @override
  bool updateShouldNotify(FamThemeProvider oldWidget) =>
      theme != oldWidget.theme;
}
