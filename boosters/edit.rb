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

  modify_guild_role(data.server.id, data.user.id, name: data.options['name'], color: data.options['color'], type: booster)

  if data.options['icon'] && unlocked_icons?(data.server.boost_level)
    modify_guild_role(data.server.id, data.user.id, icon: data.options['icon'], type: booster)
  end

  data.edit_response(content: "#{RESPONSE[2]} #{EMOJI[2]}")
end
