## 1.1.0 - 2026-01-17

- ci: add --no-fatal-infos to flutter analyze
- ci: add pub get before format check and simplify analyze
- ci: update Flutter version to 3.38.5
- style: apply dart formatter
- fix(ci): remove deprecated lint rules and fix code errors
- fix(ci): use --fatal-warnings instead of --fatal-infos
- ci: add GitHub Actions workflows for CI/CD
- docs: standardize README to match TypeScript SDK structure
- docs(example): add example.dart for pub.dev
- feat(utils): add utility functions
- docs: add comprehensive README documentation
- test: add comprehensive unit tests
- feat(core): add main Fam class and library exports
- feat(ui): add pre-built payment widgets
- feat(webhooks): add webhook signature verification
- feat(modules): add all API modules
- feat(client): add native HTTP client with retry logic
- feat(types): add complete data models and types
- feat(errors): add typed exception hierarchy
- chore: initialize Flutter package structure

# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] - 2026-02-01

### Added

- **Portal Module**: Added missing fields to `PortalWebsiteConfig`:
  - `faviconUrl`: Favicon URL for portal branding
  - `supportEmail`: Support email address
  - `supportUrl`: Support page URL
  - `termsUrl`: Terms of service URL
  - `privacyUrl`: Privacy policy URL

### Changed

- Aligned portal types with TypeScript SDK v1.2.1

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
