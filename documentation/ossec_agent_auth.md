# ossec_agent_auth

Installs the OSSEC agent package, runs `agent-auth` against a manager, and
applies the resulting agent configuration.

## Actions

| Action | Description |
|--------|-------------|
| `:create` | Installs the agent package, runs `agent-auth`, and writes agent configuration (default) |
| `:delete` | Removes agent configuration, deletes `client.keys`, and removes the agent package |

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `install_dir` | String | `'/var/ossec'` | OSSEC installation directory |
| `manage_repository` | Boolean | `true` | Whether the Atomicorp repository should be managed |
| `ossec_conf` | Hash | `{}` | Additional OSSEC configuration merged over the defaults |
| `agent_name` | String | node FQDN | Name passed to `agent-auth` |
| `server_role` | String | `'ossec_server'` | Chef role used to discover the manager when `agent_server_ip` is not set |
| `server_env` | String, nil | `nil` | Optional Chef environment filter for manager discovery |
| `agent_server_ip` | String, nil | `nil` | Explicit manager IP address |
| `port` | Integer | `1515` | authd listening port |
| `ca` | String, nil | `nil` | Optional CA file passed to `agent-auth` |
| `certificate` | String, nil | `nil` | Optional client certificate passed to `agent-auth` |
| `key` | String, nil | `nil` | Optional client key passed to `agent-auth` |

## Examples

### Register an agent with authd

```ruby
ossec_agent_auth 'default' do
  agent_server_ip '192.0.2.10'
end
```
