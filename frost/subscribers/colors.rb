# frozen_string_literal: true

module Boosters
  # Command handler for /booster role gradient.
  def self.colors(data)
    unless data.server.bot.permission?(:manage_roles)
      data.edit_response(content: RESPONSE[6])
      return
    end

    unless data.user.boosting?
      data.edit_response(content: RESPONSE[9])
      return
    end

    # Initalize the invoking user.
    member = Boosters::Member.new(data)

    if member.blank?
      data.edit_response(content: RESPONSE[2])
      return
    end

    if member.banned?
      data.edit_response(content: RESPONSE[7])
      return
    end

    # Map to: { name => COLOR || name => :NULL }
    data.options.each do |name, value|
      data.options[name] = if value.match?(REGEX[1])
                             :NULL
                           else
                             to_color(value)
                           end
    end

    payload = {
      role: member.role,
      reason: REASON[1],
      tertiary: data.options["end"],
      secondary: data.options["start"]
    }.compact

    data.edit_response(content: RESPONSE[4])

    data.server.update_role(**payload) if payload.size > 2
  end
end
