service_name = case os[:family]
               when 'ubuntu', 'debian'
                 'ossec'
               else
                 'ossec-hids'
               end

describe service(service_name) do
  it { should be_installed }
end

describe package('ossec-hids-server') do
  it { should be_installed }
end
