# frozen_string_literal: true

module Boosters
  # Command handler for /booster role gradient.
  def self.colors(data)
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

    data.options.each do |name, value|
      data.options[name] = to_color(value)
    end

    payload = {
      reason: REASON[1],
      primary: data.options["first"],
      ternerary: data.options["third"],
      secondary: data.options["second"],
      role: Frost::Boosters::Members.role(data)
    }.compact

    data.edit_response(content: RESPONSE[2])

    data.server.update_role(**payload) if payload.size != 2
  end
end
