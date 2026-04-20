# frozen_string_literal: true

def ossec_service_name
  %w(debian ubuntu).include?(os[:family]) ? 'ossec' : 'ossec-hids'
end
