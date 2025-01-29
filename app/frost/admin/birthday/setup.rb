# frozen_string_literal: true

def setup_birthdays(data)
  unless data.user.permission?(:administrator)
    data.edit_response(content: RESPONSE[1])
    return
  end

  payload = {
    guild_id: data.server.id,
    role_id: data.options["role"],
    channel_id: data.options["channel"]
  }.compact

  if Frost::Birthdays::Settings.role(data)
    Frost::Birthdays::Settings.edit(data, payload)
  end

  unless Frost::Birthdays::Settings.role(data)
    Frost::Birthdays::Settings.setup(payload)
  end

  data.edit_response(content: RESPONSE[1])
end
