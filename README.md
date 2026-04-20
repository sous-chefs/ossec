# ossec cookbook

[![Cookbook Version](https://img.shields.io/cookbook/v/ossec.svg)](https://supermarket.chef.io/cookbooks/ossec)
[![License](https://img.shields.io/badge/License-Apache%202.0-green.svg)](https://opensource.org/licenses/Apache-2.0)

This cookbook provides custom resources for installing and configuring OSSEC
HIDS from the Atomicorp package archives used by the legacy cookbook.

The package path is constrained by upstream and vendor archive support. Read
[LIMITATIONS.md](LIMITATIONS.md) before expanding platform coverage.

## Maintainers

This cookbook is maintained by the Sous Chefs. See
[sous-chefs.org](https://sous-chefs.org/).

## Requirements

### Chef

- Chef Infra Client 15.3+

### Supported platforms

- Amazon Linux 2023
- Debian 12 / 13
- Rocky Linux 9
- Ubuntu 22.04 / 24.04

The actual package archive is broader than this list, but the cookbook only
declares currently-supported platforms that align with the documented vendor
support and the maintained Kitchen matrix.

## Resources

- [ossec_repository](documentation/ossec_repository.md)
- [ossec_install](documentation/ossec_install.md)
- [ossec_config](documentation/ossec_config.md)
- [ossec_local](documentation/ossec_local.md)
- [ossec_client](documentation/ossec_client.md)
- [ossec_server](documentation/ossec_server.md)
- [ossec_authd](documentation/ossec_authd.md)
- [ossec_agent_auth](documentation/ossec_agent_auth.md)

## Data bag

Server and client key distribution uses a data bag item that defaults to
`ossec/ssh`.

```json
{
  "id": "ssh",
  "pubkey": "ssh-ed25519 AAAA...",
  "privkey": "-----BEGIN OPENSSH PRIVATE KEY-----\n..."
}
```

If you use encrypted data bags, set `encrypted_data_bag true` on the resource.

## Usage

### Local manager

```ruby
ossec_local 'default'
```

### Agent

```ruby
ossec_client 'default' do
  agent_server_ip '192.0.2.10'
end
```

### Server

```ruby
ossec_server 'default'
```

### authd

```ruby
ossec_authd 'default' do
  certificate '/var/ossec/etc/sslmanager.cert'
  key '/var/ossec/etc/sslmanager.key'
end
```

### agent-auth registration

```ruby
ossec_agent_auth 'default' do
  agent_server_ip '192.0.2.10'
end
```

## Configuration

`ossec_config`, `ossec_local`, `ossec_client`, `ossec_server`, `ossec_authd`,
and `ossec_agent_auth` all accept an `ossec_conf` hash that is rendered to
`/var/ossec/etc/ossec.conf` via Gyoku.

For server workflows, `agent_conf` is written to
`/var/ossec/etc/shared/agent.conf`.

Example:

```ruby
ossec_server 'default' do
  ossec_conf(
    'global' => {
      'email_notification' => true,
      'email_to' => 'ossec@example.com',
      'smtp_server' => 'smtp.example.com'
    }
  )
  agent_conf(
    [
      {
        'syscheck' => { 'frequency' => 4321 },
        'rootcheck' => { 'disabled' => true }
      }
    ]
  )
end
```

## Testing

```shell
berks install
cookstyle
chef exec rspec --format documentation
KITCHEN_LOCAL_YAML=kitchen.dokken.yml kitchen test default-ubuntu-2404 --destroy=always
```
