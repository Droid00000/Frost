# frozen_string_literal: true

module Boosters
  # Command handler for /booster role edit.
  def self.edit(data)
    unless data.server.bot.permission?(:manage_roles)
      data.edit_response(content: RESPONSE[6])
      return
    end

    # unless data.user.boosting?
    #  data.edit_response(content: RESPONSE[9])
    #  return
    # end

    unless safe_name?(data.options["name"])
      data.edit_response(content: RESPONSE[8])
      return
    end

    # Initalize the invoking user.
    member = Boosters::Member.new(data)

    if member.banned?
      data.edit_response(content: RESPONSE[7])
      return
    end

    payload = {
      colour: to_color(data.options["color"]),
      name: data.options["name"],
      role: member.role(data),
      reason: reason(data)
    }.compact
    
    if member.blank? && payload.size == 3
      Boosters.create(data, member: member)
      return
    end
    
    if member.blank?
      data.edit_response(content: RESPONSE[2])
      return
    end

    if valid_icon?(data, member.guild)
      payload[:icon] = to_icon(data)
    end

    if data.options["icon"]&.match?(REGEX[2])
      payload[:icon] = :NULL
    end
    
    if payload.size > 2
      data.server.update_role(**payload)
    end
    
    data.edit_response(content: RESPONSE[4])
  end
end
