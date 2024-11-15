# frozen_string_literal: true

require 'schema'
require 'discordrb'
require 'constants'
require 'functions'

# Application command handler for /booster role claim.
def create_role(data)
  if booster_records(server: data.server.id, user: data.user.id, type: :banned)
    data.edit_response(content: RESPONSE[6])
    return
  end

  if data.server.role_limit?
    data.edit_response(content: RESPONSE[59])
    return
  end

  if booster_records(server: data.server.id, user: data.user.id, type: :check_user)
    data.edit_response(content: RESPONSE[4])
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

  role = data.server.create_role(
    name: data.options['name'],
    colour: resolve_color(data.options['color']),
    icon: data.emojis('icon')&.file,
    reason: REASON[1]
  )

  role.sort_above(booster_records(server: data.server.id, type: :hoist_role))

  data.user.add_role(role, REASON[1])

  booster_records(server: data.server.id, user: data.user.id, role: role.id, type: :create)

  data.edit_response(content: "#{RESPONSE[1]} #{EMOJI[4]}")
end
