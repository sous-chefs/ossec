ossec cookbook
==============

[![Cookbook Version](https://img.shields.io/cookbook/v/ossec.svg)](https://supermarket.chef.io/cookbooks/ossec)

Installs OSSEC from source in a server-agent installation. See:

http://www.ossec.net/doc/manual/installation/index.html

Requirements
------------
#### Platforms
Tested on Ubuntu and ArchLinux, but should work on any Unix/Linux platform supported by OSSEC. Installation by default is done from source, so the build-essential cookbook needs to be used (see below).

This cookbook doesn't configure Windows systems yet. For information on installing OSSEC on Windows, see the [free chapter](http://www.ossec.net/ossec-docs/OSSEC-book-ch2.pdf)

#### Chef
- Chef 11+

#### Cookbooks
- apt
- yum-atomic

Attributes
----------

Default values are based on the defaults from OSSEC's own install.sh installation script.

* `node['ossec']['server_role']` - When using server/agent setup, this role is used to search for the OSSEC server, default `ossec_server`.
* `node['ossec']['server_env']` - When using server/agent setup, this value will scope the role search to the specified environment, default nil.
* `node['ossec']['logs']` - Array of log files to analyze. Default is an empty array. These are in addition to the default logs in the ossec.conf.erb template.
* `node['ossec']['syscheck_freq']` - Frequency that syscheck is executed, default 22 hours (79200 seconds)
* `node['ossec']['data_bag']['encrypted']` - Boolean value which indicates whether or not the OSSEC data bag is encrypted
* `node['ossec']['data_bag']['name']` - The name of the data bag to use
* `node['ossec']['data_bag']['ssh']` - The name of the data bag item which contains the OSSEC keys
* `node['ossec']['disable_config_generation']` - Boolean that dictates whether this cookbook should drop the ossec.conf template or not. This is useful if you're using a wrapper cookbook and would like to generate your own template.

The `user` attributes are used to populate the config file (ossec.conf) and preload values for the installation script.

* `node['ossec']['user']['install_type']` - This is set automatically to either `server`, `agent`, or `local` before writing ossec.conf. The OSSEC packages do not differentiate between server and local installations but the cookbook behaviour varies slightly.
* `node['ossec']['user']['dir']` - Installation directory for OSSEC, default `/var/ossec`. All existing packages use this directory so you should not change this.
* `node['ossec']['user']['syscheck']` - Whether to enable the integrity checking process, syscheck. Default true. It is safe and recommended to leave this enabled.
* `node['ossec']['user']['rootcheck']` - Whether to enable the rootkit checking process, rootcheck. Default true. It is safe and recommended to leave this enabled.
* `node['ossec']['user']['agent_server_ip']` - The IP of the OSSEC server. The client recipe will attempt to determine this value via search. Default is nil, only required for agent installations.
* `node['ossec']['user']['enable_email']` - Enable or disable email alerting. Default is true.
* `node['ossec']['user']['email']` - Destination email address for OSSEC alerts. Default is `ossec@example.com` and should be changed via a role attribute.  Can take a string or an array of email addresses.
* `node['ossec']['user']['smtp']` - Sets the SMTP relay to send email out. Default is 127.0.0.1, which assumes that a local MTA is set up (e.g., postfix).
* `node['ossec']['user']['white_list']` - Array of additional IP addresses to white list. Default is empty.

Recipes
-------

###repository

Adds the OSSEC repository to the package manager. This recipe is included by others and should not be used directly. For highly customised setups, you should use `ossec::install_agent` or `ossec::install_server` instead.

###install_agent

Installs the agent packages but performs no explicit configuation.

###install_server

Install the server packages but performs no explicit configuation.

###common

Puts the configuration file in place and starts the (agent or server) service. This recipe is included by other recipes and generally should not be used directly.

Note that the service will not be started if the client.keys file is missing or empty. For agents, this results in an error. For servers, this prevents ossec-remoted from starting, resulting in agents being unable to connect. Once client.keys does exist with content, simply perform another chef-client run to start the service.

###default

Runs `ossec::install_server` and then configures for local-only use. Do not mix this recipe with the others below.

###agent

OSSEC uses the term `agent` instead of client. The agent recipe includes the `ossec::client` recipe.

###client

Configures the system as an OSSEC agent to the OSSEC server. This recipe will search for the server based on `node['ossec']['server_role']`. It will also set the `agent_server_ip` attribute. The ossec user will have an SSH key created so the server can distribute the agent key.

###server

Sets up a system to be an OSSEC server. This recipe will search for all nodes that have an `ossec` attribute and add them as an agent.

To manage additional agents on the server that don't run chef, or for agentless OSSEC configuration (for example, routers), add a new node for them and create the `node['ossec']['agentless']` attribute as true. For example if we have a router named gw01.example.com with the IP `192.168.100.1`:

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

Enable agentless monitoring in OSSEC and register the hosts on the server. Automated configuration of agentless nodes is not yet supported by this cookbook. For more information on the commands and configuration directives required in `ossec.conf`, see the [OSSEC Documentation](http://www.ossec.net/doc/manual/agent/agentless-monitoring.html)

Usage
-----

The cookbook can be used to install OSSEC in one of the three types:

* local - use the ossec::default recipe.
* server - use the ossec::server recipe.
* agent - use the ossec::client recipe

For local-only installations, add just `recipe[ossec]` to the node run list, or put it in a role (like a base role).

###Server/Agent

This section describes how to use the cookbook for server/agent configurations.

The server will use SSH to distribute the OSSEC agent keys. Create a data bag `ossec`, with an item `ssh`. It should have the following structure:

    {
      "id": "ssh",
      "pubkey": "",
      "privkey": ""
    }

Generate an ssh keypair and get the privkey and pubkey values. The output of the two ruby commands should be used as the privkey and pubkey values respectively in the data bag.

    ssh-keygen -t rsa -f /tmp/id_rsa
    ruby -e 'puts IO.read("/tmp/id_rsa")'
    ruby -e 'puts IO.read("/tmp/id_rsa.pub")'

For the OSSEC server, create a role, `ossec_server`. Add attributes per above as needed to customize the installation.

    % cat roles/ossec_server.rb
    name "ossec_server"
    description "OSSEC Server"
    run_list("recipe[ossec::server]")
    override_attributes(
      "ossec" => {
        "user" => {
          "email" => "ossec@yourdomain.com",
          "smtp" => "smtp.yourdomain.com"
        }
      }
    )

For OSSEC agents, create a role, `ossec_client`.

    % cat roles/ossec_client.rb
    name "ossec_client"
    description "OSSEC Client Agents"
    run_list("recipe[ossec::client]")
    override_attributes(
      "ossec" => {
        "user" => {
          "email" => "ossec@yourdomain.com",
          "smtp" => "smtp.yourdomain.com"
        }
      }
    )

Customization
----

The main configuration file is maintained by Chef as a template, `ossec.conf.erb`. It should just work on most installations, but can be customized for the local environment. Notably, the rules, ignores and commands may be modified.

Further reading:

* [OSSEC Documentation](http://www.ossec.net/doc/index.html)

License and Author
------------------

Copyright 2010-2015, Chef Software, Inc (<legal@chef.io>)

```
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
