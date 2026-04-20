# ossec_authd

Installs the OSSEC server package, applies server configuration, and manages
the `ossec-authd` systemd unit.

## Actions

- `:create`: Installs the server package, writes configuration, and creates the
  authd unit
- `:delete`: Stops and removes the authd unit, removes configuration, and
  removes the server package

## Properties

- `install_dir` (`String`, default: `'/var/ossec'`): OSSEC installation
  directory
- `manage_repository` (`Boolean`, default: `true`): Whether the Atomicorp
  repository should be managed
- `ossec_conf` (`Hash`, default: `{}`): Additional OSSEC configuration merged
  over the defaults
- `agent_conf` (`Array`, default: `[]`): Agent configuration entries written to
  `agent.conf`
- `ip_address` (`Boolean`, default: `false`): Passes `-i` to `ossec-authd` to
  bind the configured IP
- `port` (`Integer`, default: `1515`): authd listening port
- `ca` (`String, nil`, default: `nil`): Optional CA file passed as `-v`
- `certificate` (`String`, default: `'/var/ossec/etc/sslmanager.cert'`): SSL
  certificate path
- `key` (`String`, default: `'/var/ossec/etc/sslmanager.key'`): SSL private key
  path

## Examples

### Start authd with the default certificate paths

```ruby
ossec_authd 'default'
```

### Start authd with a CA file

```ruby
ossec_authd 'default' do
  ca '/var/ossec/etc/root-ca.pem'
end
```
