# ossec_authd

Installs the OSSEC server package, applies server configuration, and manages
the `ossec-authd` systemd unit.

## Actions

| Action | Description |
|--------|-------------|
| `:create` | Installs the server package, writes configuration, and creates the authd unit (default) |
| `:delete` | Stops and removes the authd unit, removes configuration, and removes the server package |

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `install_dir` | String | `'/var/ossec'` | OSSEC installation directory |
| `manage_repository` | Boolean | `true` | Whether the Atomicorp repository should be managed |
| `ossec_conf` | Hash | `{}` | Additional OSSEC configuration merged over the defaults |
| `agent_conf` | Array | `[]` | Agent configuration entries written to `agent.conf` |
| `ip_address` | Boolean | `false` | Passes `-i` to `ossec-authd` to bind the configured IP |
| `port` | Integer | `1515` | authd listening port |
| `ca` | String, nil | `nil` | Optional CA file passed as `-v` |
| `certificate` | String | `'/var/ossec/etc/sslmanager.cert'` | SSL certificate path |
| `key` | String | `'/var/ossec/etc/sslmanager.key'` | SSL private key path |

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
