# ossec_agent_auth

Installs the OSSEC agent package, runs `agent-auth` against a manager, and
applies the resulting agent configuration.

## Actions

- `:create`: Installs the agent package, runs `agent-auth`, and writes agent
  configuration
- `:delete`: Removes agent configuration, deletes `client.keys`, and removes
  the agent package

## Properties

- `install_dir` (`String`, default: `'/var/ossec'`): OSSEC installation
  directory
- `manage_repository` (`Boolean`, default: `true`): Whether the Atomicorp
  repository should be managed
- `ossec_conf` (`Hash`, default: `{}`): Additional OSSEC configuration merged
  over the defaults
- `agent_name` (`String`, default: node FQDN): Name passed to `agent-auth`
- `server_role` (`String`, default: `'ossec_server'`): Chef role used to
  discover the manager when `agent_server_ip` is not set
- `server_env` (`String, nil`, default: `nil`): Optional Chef environment
  filter for manager discovery
- `agent_server_ip` (`String, nil`, default: `nil`): Explicit manager IP
  address
- `port` (`Integer`, default: `1515`): authd listening port
- `ca` (`String, nil`, default: `nil`): Optional CA file passed to
  `agent-auth`
- `certificate` (`String, nil`, default: `nil`): Optional client certificate
  passed to `agent-auth`
- `key` (`String, nil`, default: `nil`): Optional client key passed to
  `agent-auth`

## Examples

### Register an agent with authd

```ruby
ossec_agent_auth 'default' do
  agent_server_ip '192.0.2.10'
end
```
