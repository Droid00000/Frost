# frozen_string_literal: true

require_relative '../data/constants'
require_relative '../data/functions'
require_relative '../data/schema'
require 'discordrb'

def edit_event_role(data)
  unless event_records(server: data.server.id, type: :enabled)
    data.edit_response(content: RESPONSE[301])
    return
  end

  unless event_records(server: data.server.id, role: data.options['role'], type: :check_role)
    data.edit_response(content: RESPONSE[508])
    return
  end

  unless safe_name?(data.options['name'])
    data.edit_response(content: RESPONSE[400])
    return
  end

  unless role = data.server.roles.find {|r| r.id == data.options['role']} && data.user.roles.include?(role)
    data.edit_response(content: RESPONSE[508])
    return
  end

  modify_guild_role(data.server.id, data.user.id, name: data.options['name'], color: data.options['color'], type: event, role: data.options['role'])

  if !data.options['icon'].nil? && unlocked_icons?(data.server.boost_level)
    modify_guild_role(data.server.id, data.user.id, icon: data.options['icon'], type: event, role: data.options['role'])
  end

  data.edit_response(content: "#{RESPONSE[202]} #{EMOJI[20]}")
end