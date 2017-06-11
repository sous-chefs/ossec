property :dir, String, default: '/var/ossec'
property :ossec_key, String, default: lazy { ossec_key['pubkey'] }
property :ossec_server, [String, Array]

action :config do
  directory "#{new_resource.dir}/.ssh" do
    owner 'ossec'
    group 'ossec'
    mode '0750'
  end

  template "#{new_resource.dir}/.ssh/authorized_keys" do
    source 'ssh_key.erb'
    owner 'ossec'
    group 'ossec'
    mode '0600'
    variables(
      key: new_resource.ossec_key
    )
  end

  file "#{new_resource.dir}/etc/client.keys" do
    owner 'ossec'
    group 'ossec'
    mode '0660'
  end
end
