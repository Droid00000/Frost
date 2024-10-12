# frozen_string_literal: true

require_relative '../data/constants'
require_relative '../data/functions'
require_relative '../data/schema'
require 'discordrb'

def edit_role(data)
  if booster_records(server: data.server.id, user: data.user.id, type: :banned)
    data.edit_response(content: RESPONSE[6])
    return
  end

  unless booster_records(server: data.server.id, user: data.user.id, type: :check_user)
    data.edit_response(content: RESPONSE[9])
    return
  end

  unless booster_records(server: data.server.id, type: :enabled)
    data.edit_response(content: RESPONSE[5])
    return
  end

  unless data.user.boosting?
    data.edit_response(content: RESPONSE[8])
    return
  end

  unless safe_name?(data.options['name'])
    data.edit_response(content: RESPONSE[7])
    return
  end

  role = booster_records(server: data.server.id, user: data.user.id, type: :get_role)

  data.server.update_role(role, data.options['name'], data.options['color'], data.options['icon'], REASON[2])

  data.edit_response(content: "#{RESPONSE[2]} #{EMOJI[2]}")
end
