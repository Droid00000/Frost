# frozen_string_literal: true

module Boosters
  # Command handler for /booster role delete.
  def self.delete(data)
    unless data.server.bot.permission?(:manage_roles)
      data.edit_response(content: RESPONSE[47])
      return
    end

    unless data.user.boosting?
      data.edit_response(content: RESPONSE[8])
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

    role = Frost::Boosters::Members.role(data)

    data.server.role(role)&.delete(REASON[1])

    Frost::Boosters::Members.delete(data)

    data.edit_response(content: "#{RESPONSE[3]} #{EMOJI[3]}")
  end
end
