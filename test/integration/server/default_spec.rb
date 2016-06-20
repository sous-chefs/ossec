service_name = case os[:family]
               when 'ubuntu', 'debian'
                 'ossec'
               else
                 'ossec-hids'
               end

describe service(service_name) do
  it { should be_enabled }
  # it { should be_running } # can't be enabled due to status command returning 1
end
