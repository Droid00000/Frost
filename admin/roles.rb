# frozen_string_literal: true

require_relative '../data/constants'
require_relative '../data/schema'
require 'discordrb'

def setup_event_roles(data)
  if event_records(server: data.server.id, role: data.options['role'], type: :check_role)
    data.edit_response(content: RESPONSE[23])
    return
  end

  event_records(server: data.server.id, role: data.options['role'], type: :register_role)
  data.edit_response(content: "#{RESPONSE[24]} <@&#{data.options['role']}>")
end
