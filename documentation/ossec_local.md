# ossec_local

Installs the OSSEC server package and configures it for the cookbook's local
manager workflow.

## Actions

| Action | Description |
|--------|-------------|
| `:create` | Installs the server package and applies local configuration (default) |
| `:delete` | Removes local configuration and the server package |

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `install_dir` | String | `'/var/ossec'` | OSSEC installation directory |
| `manage_repository` | Boolean | `true` | Whether the Atomicorp repository should be managed |
| `ossec_conf` | Hash | `{}` | Additional OSSEC configuration merged over the defaults |
| `agent_conf` | Array | `[]` | Agent configuration entries, written only where relevant |
| `data_bag_name` | String | `'ossec'` | Data bag name for SSH key material |
| `ssh_data_bag_item` | String | `'ssh'` | Data bag item containing SSH key material |
| `encrypted_data_bag` | Boolean | `false` | Whether the SSH data bag item is encrypted |

## Examples

### Install a local manager

```ruby
ossec_local 'default'
```
