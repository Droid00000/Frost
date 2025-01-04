# frozen_string_literal: true

# Setup booster perks for a server, or update them.
def setup_booster(data)
  unless data.user.permission?(:manage_roles)
    data.edit_response(content: RESPONSE[18])
    return
  end

  Frost::Boosters::Settings.setup(data)

  data.edit_response(content: format(RESPONSE[33], data.options["role"]))
end
