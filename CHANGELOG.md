# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2024-01-17

### Added

- Initial release of FAM Flutter SDK
- Full API coverage for FAM payment platform
- **Users Module**: Natural and Legal user management
- **Wallets Module**: Wallet creation and management
- **PayIns Module**: Card payments, recurring payments, refunds
- **PayOuts Module**: Bank wire transfers
- **Transfers Module**: Wallet-to-wallet transfers
- **Cards Module**: Card registration, validation, preauthorizations
- **Bank Accounts Module**: IBAN, GB, US, CA, and other account types
- **KYC Module**: Document upload and verification
- **UBO Module**: Ultimate Beneficial Owner declarations
- **Recipients Module**: SCA-compliant recipient management
- **Subscriptions Module**: Recurring subscription management
- **Portal Module**: Customer portal session management
- **Webhooks**: Secure webhook signature verification
- Automatic retry with exponential backoff
- Comprehensive typed error handling
- Zero third-party dependencies (except `crypto` for HMAC)
- Full Dart 3.0+ null safety support
- Cross-platform support (iOS, Android, Web, Desktop)
