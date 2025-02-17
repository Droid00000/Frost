# frozen_string_literal: true

# Setup booster perks for a server, or update them.
def setup_booster(data)
  unless data.user.permission?(:manage_roles)
    data.edit_response(content: RESPONSE[18])
    return
  end

  if data.options.empty?
    data.edit_response(content: RESPONSE[113])
    return
  end

  unless Frost::Boosters::Settings.role || data.options["role"]
    data.edit_response(content: RESPONSE[124])
    return
  end

  payload = {
    guild_id: data.server.id,
    hoist_role: data.options["role"],
    guild_icon: data.options["icon"],
  }

  Frost::Boosters::Settings.setup(payload.compact)

  data.edit_response(content: format(RESPONSE[33], data.options["role"]))
end
