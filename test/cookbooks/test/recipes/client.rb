# frozen_string_literal: true

ossec_client 'default' do
  agent_server_ip '192.0.2.10'
  client_keys_content '001 test-agent 192.0.2.10 deadbeefdeadbeefdeadbeefdeadbeef'
end
