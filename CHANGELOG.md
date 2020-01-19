# Changelog

## [Unreleased]

### Added

- Migration to circleci testing
- Migration to github actions

### Changed

- Various Cookstyle and foodcritic fixes

### Deprecated

### Removed

## [1.2.0] - 2019-05-13

### Added

- Add distro based authd service name

### Changed

### Deprecated

### Removed

## [1.1.0] - 2018-08-13

- README Updates:
  - Fix broken links
  - Add reference to Wazzuh
- General updates to cookbook
  - Remove EOL distros
  - Update for current supported Chef version (13)

## [1.0.5] - 2014-04-15

- Avoid node.save to prevent incomplete attribute collections
- `dist-ossec-keys.sh` should be sorted for idempotency
- Ability to disable ossec configuration template
- Support for encrypted databags
- Support for environment-scoped searches
- Support for multiple email_to addresses

## [1.0.4] - 2013-05-14

- [COOK-2740]: Use FQDN for a client name
- [COOK-2739]: Upgrade OSSEC to version 2.7

## [1.0.2] - 2012-07-01

- [COOK-1394] - update ossec to version 2.6

## 1.0.0

- Initial/current release
