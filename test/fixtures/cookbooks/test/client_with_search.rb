server = []
server_role = 'ossec_server'
server_env = nil

search_string = "role:#{server_role}"
search_string << " AND chef_environment:#{server_env}" if server_env

if node.run_list.roles.include?(node['ossec']['server_role'])
  server << node['ipaddress']
else
  search(:node, search_string) do |n|
    server << n['ipaddress']
  end
end

agent_server_ip = ossec_server.first

ossec_client_install 'client'

key = data_bag_item('ossec', 'ssh')

ossec_client_config '' do
  ossec_key key
  ossec_server agent_server_ip
end

include_recipe 'ossec::common'
