# ossec_client

Installs the OSSEC agent package, manages the SSH authorization file used for
server-side key distribution, writes `client.keys`, and applies agent
configuration.

## Actions

| Action | Description |
|--------|-------------|
| `:create` | Installs and configures an OSSEC agent (default) |
| `:delete` | Removes agent configuration, key material, and the agent package |

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `install_dir` | String | `'/var/ossec'` | OSSEC installation directory |
| `manage_repository` | Boolean | `true` | Whether the Atomicorp repository should be managed |
| `ossec_conf` | Hash | `{}` | Additional OSSEC configuration merged over the defaults |
| `data_bag_name` | String | `'ossec'` | Data bag name containing SSH key material |
| `ssh_data_bag_item` | String | `'ssh'` | Data bag item containing the public key |
| `encrypted_data_bag` | Boolean | `false` | Whether the SSH data bag item is encrypted |
| `server_role` | String | `'ossec_server'` | Chef role used to discover the manager when `agent_server_ip` is not set |
| `server_env` | String, nil | `nil` | Optional Chef environment filter for manager discovery |
| `agent_server_ip` | String, nil | `nil` | Explicit manager IP address |
| `client_keys_content` | String, nil | `nil` | Optional content written to `client.keys` |

## Examples

### Configure an agent with an explicit manager IP

```ruby
ossec_client 'default' do
  agent_server_ip '192.0.2.10'
end
```

### Configure an agent using role-based discovery

```ruby
ossec_client 'default' do
  server_role 'ossec_server'
  server_env 'production'
end
```
