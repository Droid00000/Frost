# frozen_string_literal: true

require_relative '../data/constants'
require_relative '../data/functions'
require_relative '../data/schema'
require 'discordrb'

def edit_role(data)
  unless booster_records(server: data.server.id, user: data.user.id, type: :check_user)
    data.edit_response(content: RESPONSE[404])
    return
  end

  if booster_records(server: data.server.id, user: data.user.id, type: :banned)
    data.edit_response(content: RESPONSE[302])
    return
  end

  unless booster_records(server: data.server.id, type: :enabled)
    data.edit_response(content: RESPONSE[301])
    return
  end

  unless data.user.boosting?
    data.edit_response(content: RESPONSE[401])
    return
  end

  unless safe_name?(data.options['name'])
    data.edit_response(content: RESPONSE[400])
    return
  end

  modify_guild_role(data.server.id, data.user.id, name: data.options['name'], color: data.options['color'], type: booster)

  if !data.options['icon'].nil? && unlocked_icons?(data.server.boost_level)
    modify_guild_role(data.server.id, data.user.id, icon: data.options['icon'], type: booster)
  end

  data.edit_response(content: "#{RESPONSE[202]} #{EMOJI[20]}")
end
