# v2.0.0 (2016-03-28)

## BREAKING CHANGES

- Completely refactored how configs are handled. Attributes in node['ossec']['conf'] are converted to XML for the ossec.conf file. See the Readme for details and examples.
- The WUI recipe has been removed as the WUI project is abandoned
- Removed arch as a supported platform
- The default recipe has been renamed local.rb for local type installs

## Other Changes

- Added scientific, oracle, and amazon as supported platforms in the metadata
- Added Chefspec
- Fixed ossec server search query; It now finds ossec_client nodes in chef
- Removed OSSEC wiki link from the readme
- Added .foodcritic file to disable FC003
- Updated Kitchen config to include additional platforms and the latest Test Kitchen format
- Added Rubocop config and resolved warnings
- Updated Berskfile to the latest format and added yum/apt deps
- Removed old Opscode contributing doc
- Added Gemfile with testing dependencies
- Updated the testing doc to match the current process
- Added chefignore file to limit the files that are uploaded to the Chef server
- Added source_url and issues_url to the metadata

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
