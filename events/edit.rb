# frozen_string_literal: true

require_relative '../data/constants'
require_relative '../data/functions'
require_relative '../data/schema'
require 'discordrb'

def edit_event_role(data)
  unless event_records(server: data.server.id, type: :enabled)
    data.edit_response(content: RESPONSE[5])
    return
  end

  unless event_records(server: data.server.id, role: data.options['role'], type: :check_role)
    data.edit_response(content: RESPONSE[17])
    return
  end

  unless safe_name?(data.options['name'])
    data.edit_response(content: RESPONSE[7])
    return
  end

  unless role = data.server.roles.find { |r| r.id == data.options['role'] } && data.user.roles.include?(role)
    data.edit_response(content: RESPONSE[17])
    return
  end

  data.server.update_role(data.options['role'], data.options['name'], data.options['color'], data.options['icon'], REASON[5])

  data.edit_response(content: "#{RESPONSE[2]} #{EMOJI[3]}")
end
