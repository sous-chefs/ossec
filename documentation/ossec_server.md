# ossec_server

Installs the OSSEC server package, registers managed agents discovered through
Chef search, installs the SSH private key used for key distribution, and writes
server configuration.

## Actions

- `:create`: Installs and configures an OSSEC server
- `:delete`: Removes server configuration, managed key-distribution artifacts,
  and the server package

## Properties

- `install_dir` (`String`, default: `'/var/ossec'`): OSSEC installation
  directory
- `manage_repository` (`Boolean`, default: `true`): Whether the Atomicorp
  repository should be managed
- `ossec_conf` (`Hash`, default: `{}`): Additional OSSEC configuration merged
  over the defaults
- `agent_conf` (`Array`, default: `[]`): Agent configuration entries written to
  `agent.conf`
- `data_bag_name` (`String`, default: `'ossec'`): Data bag name containing SSH
  key material
- `ssh_data_bag_item` (`String`, default: `'ssh'`): Data bag item containing
  the private key
- `encrypted_data_bag` (`Boolean`, default: `false`): Whether the SSH data bag
  item is encrypted
- `server_role` (`String`, default: `'ossec_server'`): Role used to exclude the
  server itself from agent discovery
- `server_env` (`String, nil`, default: `nil`): Optional Chef environment
  filter for agent discovery

## Examples

### Configure a server with default discovery

```ruby
ossec_server 'default'
```

### Configure a server with custom OSSEC settings

```ruby
ossec_server 'default' do
  ossec_conf(
    'global' => {
      'email_notification' => true,
      'email_to' => 'ossec@example.com'
    }
  )
end
```
