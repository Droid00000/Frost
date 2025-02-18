# frozen_string_literal: true

module Boosters
  # Command handler for /booster role edit.
  def self.edit(data)
    unless data.server.bot.permission?(:manage_roles)
      data.edit_response(content: RESPONSE[47])
      return
    end

    unless data.user.boosting?
      data.edit_response(content: RESPONSE[8])
      return
    end

    unless safe_name?(data.options["name"])
      data.edit_response(content: RESPONSE[7])
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

    if data.options.empty?
      data.edit_response(content: "#{RESPONSE[2]} #{EMOJI[2]}")
      return
    end

    payload = {
      role: Frost::Boosters::Members.role(data),
      colour: resolve_color(data.options["color"]),
      name: data.options["name"],
      icon: resolve_icon(data),
      reason: REASON[1]
    }

    payload.delete(:icon) unless valid_icon?(data)

    data.server.update_role(**payload)

    data.edit_response(content: "#{RESPONSE[2]} #{EMOJI[2]}")
  end
end
