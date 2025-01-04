# frozen_string_literal: true

# Application command handler for /booster role delete.
def delete_role(data)
  unless data.user.boosting?
    data.edit_response(content: RESPONSE[8])
    return
  end

  unless data.server.bot.permission?(:manage_roles)
    data.edit_response(content: RESPONSE[47])
    return
  end

  unless Frost::Boosters::Settings.get(data)
    data.edit_response(content: RESPONSE[5])
    return
  end

  unless Frost::Boosters::Members.role(data)
    data.edit_response(content: RESPONSE[9])
    return
  end

  if Frost::Boosters::Ban.user?(data)
    data.edit_response(content: RESPONSE[6])
    return
  end

  data.server.role(Frost::Boosters::Members.role(data))&.delete(REASON[3])

  Frost::Boosters::Members.delete(data)

  data.edit_response(content: "#{RESPONSE[3]} #{EMOJI[3]}")
end
