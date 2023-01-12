# ossec cookbook

[![Cookbook Version](https://img.shields.io/cookbook/v/ossec.svg)](https://supermarket.chef.io/cookbooks/ossec)
[![Build Status](https://img.shields.io/circleci/project/github/sous-chefs/ossec/master.svg)](https://circleci.com/gh/sous-chefs/ossec)
[![OpenCollective](https://opencollective.com/sous-chefs/backers/badge.svg)](#backers)
[![OpenCollective](https://opencollective.com/sous-chefs/sponsors/badge.svg)](#sponsors)
[![License](https://img.shields.io/badge/License-Apache%202.0-green.svg)](https://opensource.org/licenses/Apache-2.0)

Installs OSSEC from source in a server-agent installation. See:

[http://www.ossec.net/docs/manual/installation/index.html](http://www.ossec.net/docs/manual/installation/index.html)

For managing Wazuh, consider using the Wazuh Chef Cookbook here: [https://github.com/wazuh/wazuh-chef](https://github.com/wazuh/wazuh-chef)

## Maintainers

This cookbook is maintained by the Sous Chefs. The Sous Chefs are a community of Chef cookbook maintainers working together to maintain important cookbooks. If you’d like to know more please visit [sous-chefs.org](https://sous-chefs.org/) or come chat with us on the Chef Community Slack in [#sous-chefs](https://chefcommunity.slack.com/messages/C2V7B88SF).

## Requirements

### Platforms

- Ubuntu / Debian
- RHEL and derivatives

### Chef

- Chef 16.13+

### Cookbooks

- yum-atomic

## Attributes

- `node['ossec']['dir']` - Installation directory for OSSEC, default `/var/ossec`. All existing packages use this directory so you should not change this.
- `node['ossec']['server_role']` - When using server/agent setup, this role is used to search for the OSSEC server, default `ossec_server`.
- `node['ossec']['server_env']` - When using server/agent setup, this value will scope the role search to the specified environment, default nil.
- `node['ossec']['agent_server_ip']` - The IP of the OSSEC server. The client recipe will attempt to determine this value via search. Default is nil, only required for agent installations.
- `node['ossec']['data_bag']['encrypted']` - Boolean value which indicates whether or not the OSSEC data bag is encrypted
- `node['ossec']['data_bag']['name']` - The name of the data bag to use
- `node['ossec']['data_bag']['ssh']` - The name of the data bag item which contains the OSSEC keys

### ossec.conf

OSSEC's configuration is mainly read from an XML file called `ossec.conf`. You can directly control the contents of this file using node attributes under `node['ossec']['conf']`. These attributes are mapped to XML using Gyoku. See the [Gyoku site](https://github.com/savonrb/gyoku) for details on how this works.

Chef applies attributes from all attribute files regardless of which recipes were executed. In order to make wrapper cookbooks easier to write, `node['ossec']['conf']` is divided into the three installation types mentioned below, `local`, `server`, and `agent`. You can also set attributes under `all` to apply settings across all installation types. The typed attributes are automatically deep merged over the `all` attributes in the normal Chef manner.

`true` and `false` values are automatically mapped to `"yes"` and `"no"` as OSSEC expects the latter.

`ossec.conf` makes little use of XML attributes so you can generally construct nested hashes in the usual fashion. Where an attribute is required, you can do it like this:

```ruby
default['ossec']['conf']['all']['syscheck']['directories'] = [
  { '@check_all' => true, 'content!' => '/bin,/sbin' },
  '/etc,/usr/bin,/usr/sbin'
]
```

This produces:

```xml
<syscheck>
  <directories check_all="yes">/bin,/sbin</directories>
  <directories>/etc,/usr/bin,/usr/sbin</directories>
</syscheck>
```

The default values are based on those given in the OSSEC manual. They do not include any specific rules, checks, outputs, or alerts as everyone has different requirements.

### agent.conf

OSSEC servers can also distribute configuration to agents through the centrally managed XM file called `agent.conf`. Since Chef is better at distributing configuration than OSSEC is, the cookbook leaves this file blank by default. Should you want to populate it, it is done in a similar manner to the above. Since this file is only used on servers, you can define the attributes directly under `node['ossec']['agent_conf']`. Unlike conventional XML files, `agent.conf` has multiple root nodes so `node['ossec']['agent_conf']` must be treated as an array like so.

```ruby
default['ossec']['agent_conf'] = [
  {
    'syscheck' => { 'frequency' => 4321 },
    'rootcheck' => { 'disabled' => true }
  },
  {
    '@os' => 'Windows',
    'content!' => {
      'syscheck' => { 'frequency' => 1234 }
    }
  }
]
```

This produces:

```xml
<agent_config>
  <syscheck>
    <frequency>4321</frequency>
  </syscheck>
  <rootcheck>
    <disabled>yes</disabled>
  </rootcheck>
</agent_config>

<agent_config os="Windows">
  <syscheck>
    <frequency>1234</frequency>
  </syscheck>
</agent_config>
```

## Recipes

### repository

Adds the OSSEC repository to the package manager. This recipe is included by others and should not be used directly. For highly customised setups, you should use `ossec::install_agent` or `ossec::install_server` instead.

### install_agent

Installs the agent packages but performs no explicit configuration.

### install_server

Install the server packages but performs no explicit configuration.

### common

Puts the configuration file in place and starts the (agent or server) service. This recipe is included by other recipes and generally should not be used directly.

Note that the service will not be started if the client.keys file is missing or empty. For agents, this results in an error. For servers, this prevents ossec-remoted from starting, resulting in agents being unable to connect. Once client.keys does exist with content, simply perform another chef-client run to start the service.

### default

Runs `ossec::install_server` and then configures for local-only use. Do not mix this recipe with the others below.

### agent

OSSEC uses the term `agent` instead of client. The agent recipe includes the `ossec::client` recipe.

### client

Configures the system as an OSSEC agent to the OSSEC server. This recipe will search for the server based on `node['ossec']['server_role']`. It will also set the `agent_server_ip` attribute. The ossec user will have an SSH key created so the server can distribute the agent key.

### server

Sets up a system to be an OSSEC server. This recipe will search for all nodes that have an `ossec` attribute and add them as an agent.

To manage additional agents on the server that don't run chef, or for agentless OSSEC configuration (for example, routers), add a new node for them and create the `node['ossec']['agentless']` attribute as true. For example if we have a router named gw01.example.com with the IP `192.168.100.1`:

```shell
% knife node create gw01.example.com
{
  "name": "gw01.example.com",
  "json_class": "Chef::Node",
  "automatic": {
  },
  "normal": {
    "hostname": "gw01",
    "fqdn": "gw01.example.com",
    "ipaddress": "192.168.100.1",
    "ossec": {
      "agentless": true
    }
  },
  "chef_type": "node",
  "default": {
  },
  "override": {
  },
  "run_list": [
  ]
}
```

Enable agentless monitoring in OSSEC and register the hosts on the server. Automated configuration of agentless nodes is not yet supported by this cookbook. For more information on the commands and configuration directives required in `ossec.conf`, see the [OSSEC Documentation](http://www.ossec.net/docs/manual/agent/agentless-monitoring.html)

### agent_auth

If you do not wish to distribute agent keys via SSH then the authd mechanism provides an alternative. Set the `agent_server_ip` attribute manually and this recipe will attempt to register with the given server running ossec-authd. To allow registration with a new server after changing `agent_server_ip`, delete the client.keys file and rerun the recipe.

### authd

For a server to accept agent registrations, it needs to be running ossec-authd. This recipe installs an init script for it (systemd only for now) and will attempt to start it once the mandatory SSL certificate and key have been put in place. From OSSEC 2.9, you can also set a CA certificate to validate agents against.

## Usage

The cookbook can be used to install OSSEC in one of the three types:

- local - use the ossec::default recipe.
- server - use the ossec::server recipe.
- agent - use the ossec::client recipe

For local-only installations, add just `recipe[ossec]` to the node run list, or put it in a role (like a base role).

### Server/Agent

This section describes how to use the cookbook for server/agent configurations.

The server will use SSH to distribute the OSSEC agent keys. Create a data bag `ossec`, with an item `ssh`. It should have the following structure:

```shell
{
  "id": "ssh",
  "pubkey": "",
  "privkey": ""
}
```

Generate an ssh keypair and get the privkey and pubkey values. The output of the two ruby commands should be used as the privkey and pubkey values respectively in the data bag.

```shell
ssh-keygen -t rsa -f /tmp/id_rsa
ruby -e 'puts IO.read("/tmp/id_rsa")'
ruby -e 'puts IO.read("/tmp/id_rsa.pub")'
```

For the OSSEC server, create a role, `ossec_server`. Add attributes per above as needed to customize the installation.

```shell
% cat roles/ossec_server.rb
name "ossec_server"
description "OSSEC Server"
run_list("recipe[ossec::server]")
override_attributes(
  "ossec" => {
    "conf" => {
      "server" => {
        "global" => {
          "email_to" => "ossec@yourdomain.com",
          "smtp_server" => "smtp.yourdomain.com"
        }
      }
    }
  }
)
```

For OSSEC agents, create a role, `ossec_client`.

```shell
% cat roles/ossec_client.rb
name "ossec_client"
description "OSSEC Client Agents"
run_list("recipe[ossec::client]")
override_attributes(
  "ossec" => {
    "conf" => {
      "agent" => {
        "syscheck" => {
          "frequency" => 321
        }
      }
    }
  }
)
```

## Customization

The main configuration file is maintained by Chef as a template, `ossec.conf.erb`. It should just work on most installations, but can be customized for the local environment. Notably, the rules, ignores and commands may be modified.

Further reading:

- [OSSEC Documentation](http://www.ossec.net/docs/index.html)

## Contributors

This project exists thanks to all the people who [contribute.](https://opencollective.com/sous-chefs/contributors.svg?width=890&button=false)

### Backers

Thank you to all our backers!

![https://opencollective.com/sous-chefs#backers](https://opencollective.com/sous-chefs/backers.svg?width=600&avatarHeight=40)

### Sponsors

Support this project by becoming a sponsor. Your logo will show up here with a link to your website.

![https://opencollective.com/sous-chefs/sponsor/0/website](https://opencollective.com/sous-chefs/sponsor/0/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/1/website](https://opencollective.com/sous-chefs/sponsor/1/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/2/website](https://opencollective.com/sous-chefs/sponsor/2/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/3/website](https://opencollective.com/sous-chefs/sponsor/3/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/4/website](https://opencollective.com/sous-chefs/sponsor/4/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/5/website](https://opencollective.com/sous-chefs/sponsor/5/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/6/website](https://opencollective.com/sous-chefs/sponsor/6/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/7/website](https://opencollective.com/sous-chefs/sponsor/7/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/8/website](https://opencollective.com/sous-chefs/sponsor/8/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/9/website](https://opencollective.com/sous-chefs/sponsor/9/avatar.svg?avatarHeight=100)
