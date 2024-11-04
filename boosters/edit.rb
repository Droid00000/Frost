# frozen_string_literal: true

require 'discordrb'
require 'data/schema'
require 'data/constants'
require 'data/functions'

def edit_role(data)
  if booster_records(server: data.server.id, user: data.user.id, type: :banned)
    data.edit_response(content: RESPONSE[6])
    return
  end

  unless booster_records(server: data.server.id, user: data.user.id, type: :check_user)
    data.edit_response(content: RESPONSE[9])
    return
  end

  unless data.bot.profile.on(data.server).permission?(:manage_roles)
    data.edit_response(content: RESPONSE[60])
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

  data.server.update_role(role,
                          data.options['name'],
                          resolve_color(data.options['color']),
                          data.options['icon'],
                          REASON[2])

  data.edit_response(content: "#{RESPONSE[2]} #{EMOJI[2]}")
end
