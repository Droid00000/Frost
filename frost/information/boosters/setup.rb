# frozen_string_literal: true

# Setup booster perks for a server, or update them.
def setup_booster(data)
  unless data.user.permission?(:manage_roles)
    data.edit_response(content: RESPONSE[18])
    return
  end

  unless enabled?(data)
    data.edit_response(content: RESPONSE[124])
    return
  end

  payload = {
    guild_id: data.server.id,
    any_icon: data.options["icon"],
    hoist_role: data.options["role"]
  }

  unless payload.except(:guild_id).empty?
    Frost::Boosters::Settings.setup(payload.compact)
  end

  data.edit_response(content: RESPONSE[33])
end
