# Changelog

## Unreleased

- [BREAKING CHANGE] Remove support for Chef 13
  - Require Chef 15.3
- Update stale workflow to v8
- Update vscode extensions
- Update renovate config
- Update yamllint config

## 2.0.4 - *2023-03-20*

Standardise files with files in sous-chefs/repo-management

## 2.0.3 - *2023-03-15*

Standardise files with files in sous-chefs/repo-management

## 2.0.2 - *2023-02-23*

Standardise files with files in sous-chefs/repo-management

## 2.0.1 - *2023-02-14*

Standardise files with files in sous-chefs/repo-management

## 2.0.0 - *2023-01-12*

- Standardise files with files in sous-chefs/repo-management
- Partially modernize cookbook
  - Refactor library helper
- Properly set repositories for various supported platforms
- Cleanup and Fix CI
- Add support to various platforms
- Fix idempotency issues

## 1.2.7 - *2022-02-08*

- Standardise files with files in sous-chefs/repo-management

## 1.2.6 - *2022-02-07*

- Remove delivery folder
- Standardise files with files in sous-chefs/repo-management

## 1.2.5 - *2021-09-08*

- resolved cookstyle error: recipes/authd.rb:25:4 refactor: `Chef/Modernize/UseChefLanguageSystemdHelper`

## 1.2.4 - *2021-08-30*

- Standardise files with files in sous-chefs/repo-management

## 1.2.3 - *2021-06-01*

- resolved cookstyle error: spec/unit/recipes/agent_spec.rb:5:31 convention: `Style/ExpandPathArguments`
- resolved cookstyle error: spec/unit/recipes/client_spec.rb:5:31 convention: `Style/ExpandPathArguments`
- resolved cookstyle error: spec/unit/recipes/server_spec.rb:5:31 convention: `Style/ExpandPathArguments`

## 1.2.2 - 2020-05-14

- resolved cookstyle error: recipes/common.rb:20:35 convention: `Layout/TrailingWhitespace`
- resolved cookstyle error: recipes/common.rb:20:36 refactor: `ChefModernize/FoodcriticComments`
- resolved cookstyle error: recipes/common.rb:90:24 convention: `Layout/TrailingWhitespace`
- resolved cookstyle error: recipes/common.rb:90:25 refactor: `ChefModernize/FoodcriticComments`

## 1.2.1 - 2020-05-05

- Migration to Github Actions

- Various Cookstyle and foodcritic fixes
- resolved cookstyle error: libraries/helpers.rb:31:18 convention: `Style/HashEachMethods`

### Deprecated

## [1.2.0] - 2019-05-13

- Add distro based authd service name

### Deprecated

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
