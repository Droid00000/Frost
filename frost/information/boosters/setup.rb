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
    setup_by: data.user.id,
    setup_at: Time.now.to_i,
    guild_id: data.server.id,
    any_icon: data.options["icon"],
    hoist_role: data.options["role"]
  }.compact

  unless payload.except(:guild_id).empty?
    Frost::Boosters::Settings.setup(payload)
  end

  data.edit_response(content: RESPONSE[33])
end
