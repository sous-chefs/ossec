# ossec_config

Renders `ossec.conf` and `agent.conf`, then enables and conditionally starts
the packaged OSSEC service.

## Actions

- `:create`: Writes configuration files and enables or starts the main service
  as appropriate
- `:delete`: Stops or disables the service and removes the managed
  configuration files

## Properties

- `install_type` (`String`, default: name): Configuration role. Must be
  `local`, `server`, or `agent`
- `install_dir` (`String`, default: `'/var/ossec'`): OSSEC installation
  directory
- `ossec_conf` (`Hash`, default: `{}`): Additional OSSEC configuration merged
  over the defaults
- `agent_conf` (`Array`, default: `[]`): Agent configuration entries written on
  server installs
- `agent_server_ip` (`String, nil`, default: `nil`): Server IP used for agent
  configuration

## Examples

### Configure a local install

```ruby
ossec_config 'local'
```

### Configure an agent with an explicit manager IP

```ruby
ossec_config 'agent' do
  agent_server_ip '192.0.2.10'
end
```
