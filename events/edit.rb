# frozen_string_literal: true

require 'discordrb'
require 'data/schema'
require 'data/constants'
require 'data/functions'

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

  unless data.user.roles.include?(data.server.roles.find { |r| r.id == data.options['role'] })
    data.edit_response(content: RESPONSE[17])
    return
  end

  data.server.update_role(data.options['role'],
                          data.options['name'],
                          resolve_color(data.options['color']),
                          data.options['icon'],
                          REASON[5])

  data.edit_response(content: "#{RESPONSE[2]} #{EMOJI[3]}")
end
