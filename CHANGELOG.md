# v2.0.0

## Bug

- [6cb5e39] Replace `rc` with `systemd` service configuration for Arch Linux
- [3b581e6] Find ossec_client nodes in Chef
- [0836d80] Fix `service_name` on Debian

## Improvement

- [a823be7] Add Web UI support and associated documentation
- [f8a11a1] Add partial node search support
- [b6c55dc] Improve testing, style, and documentation
- [02ae9a6] Upgrade OSSEC to version 2.8.3
- [0836d80] Add explicit `os` support for scientific/oracle/amazon platforms
- Various other testing improvements and syntax cleanup

## Breaking Changes

- [b00b396] Move to attribute driven configuration

# v1.0.5

## Bug

- Avoid node.save to prevent incomplete attribute collections
- `dist-ossec-keys.sh` should be sorted for idempotency

## Improvement

- Ability to disable ossec configuration template
- Support for encrypted databags
- Support for environment-scoped searches
- Support for multiple email_to addresses

# v1.0.4

## Bug

- [COOK-2740]: Use FQDN for a client name

## Improvement

- [COOK-2739]: Upgrade OSSEC to version 2.7

# v1.0.2:

- [COOK-1394] - update ossec to version 2.6

# v1.0.0:

- Initial/current release
