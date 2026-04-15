# ossec_local

Installs the OSSEC server package and configures it for the cookbook's local
manager workflow.

## Actions

- `:create`: Installs the server package and applies local configuration
- `:delete`: Removes local configuration and the server package

## Properties

- `install_dir` (`String`, default: `'/var/ossec'`): OSSEC installation
  directory
- `manage_repository` (`Boolean`, default: `true`): Whether the Atomicorp
  repository should be managed
- `ossec_conf` (`Hash`, default: `{}`): Additional OSSEC configuration merged
  over the defaults
- `agent_conf` (`Array`, default: `[]`): Agent configuration entries, written
  only where relevant
- `data_bag_name` (`String`, default: `'ossec'`): Data bag name for SSH key
  material
- `ssh_data_bag_item` (`String`, default: `'ssh'`): Data bag item containing
  SSH key material
- `encrypted_data_bag` (`Boolean`, default: `false`): Whether the SSH data bag
  item is encrypted

## Examples

### Install a local manager

```ruby
ossec_local 'default'
```
