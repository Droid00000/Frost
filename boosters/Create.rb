# frozen_string_literal: true

require '../data/constants'
require '../data/functions'
require '../data/schema'
require 'discordrb'

def create_role(data)
  unless booster_records(server: data.server.id, user: data.user.id, type: :check_user)
    data.edit_response(content: RESPONSE[226])
    return
  end

  unless booster_records(server: data.server.id, type: :enabled)  
    data.edit_response(content: RESPONSE[301])
    return
  end

  if booster_records(server: data.server.id, user: data.user.id, type: :banned)  
    data.edit_response(content: RESPONSE[302])
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

    role = data.server.create_role(
      name: data.options['name'],
      color: resolve_color(data.options['color']),
      hoist: false,
      mentionable: false,
      permissions: 0,
      reason: RESPONSE[100]
    )
    
    data.user.add_role(
      role, reason = RESPONSE[100]
    )

    role.sort_above(
      booster_records(server: data.server.id,
      type: :hoist_role)
    )

    booster_records(
      server: data.server.id,
      user: data.user.id,
      role: role.id,
      type: :create    
    )
    
    data.edit_response(content: "#{RESPONSE[201]} #{EMOJI[40]}")

    return unless !data.options['icon'].nil? && unlocked_icons?(data.server.boost_level)

      role.icon = File.open("/private#{find_icon(data.options['icon'])}", 'rb')
    end
  end
end