# frozen_string_literal: true

require_relative '../data/constants'
require_relative '../data/functions'
require_relative '../data/schema'
require 'discordrb'

def create_role(data)
  if booster_records(server: data.server.id, user: data.user.id, type: :check_user)
    data.edit_response(content: RESPONSE[4])
    return
  end

  unless booster_records(server: data.server.id, type: :enabled)
    data.edit_response(content: RESPONSE[5])
    return
  end

  if booster_records(server: data.server.id, user: data.user.id, type: :banned)
    data.edit_response(content: RESPONSE[6])
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

  role = data.server.create_role(
    name: data.options['name'],
    colour: resolve_color(data.options['color']),
    hoist: false,
    mentionable: false,
    permissions: 0,
    reason: REASON[1]
  )

  role.sort_above(booster_records(server: data.server.id, type: :hoist_role))

  data.user.add_role(role, REASON[1])

  booster_records(server: data.server.id, user: data.user.id, role: role.id, type: :create)

  data.edit_response(content: "#{RESPONSE[1]} #{EMOJI[4]}")

  return unless !data.options['icon'].nil? && unlocked_icons?(data.server.boost_level)

  role.icon = File.open("/private#{find_icon(data.options['icon'])}", 'rb')
end
