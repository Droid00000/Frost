# frozen_string_literal: true

module Boosters
  # Command handler for /booster role edit.
  def self.edit(data)
    unless data.server.bot.permission?(:manage_roles)
      data.edit_response(content: RESPONSE[7])
      return
    end

    unless data.user.boosting?
      data.edit_response(content: RESPONSE[10])
      return
    end

    unless safe_name?(data.options["name"])
      data.edit_response(content: RESPONSE[9])
      return
    end

    # Initalize the invoking user.
    member = Boosters::Member.new(data)

    if member.banned?
      data.edit_response(content: RESPONSE[8])
      return
    end

    if member.blank?
      data.edit_response(content: RESPONSE[2])
      return
    end

    if member.guild.blank?
      data.edit_response(content: RESPONSE[11])
      return
    end

    options = {
      colour: to_color(data.options["color"]),
      name: data.options["name"],
      role: member.role(data),
      reason: reason(data)
    }.compact

    if valid_icon?(data, member.guild)
      options[:icon] = to_icon(data)
    end

    if data.options["icon"]&.match?(REGEX[2])
      options[:icon] = :NULL
    end

    if options.size > 2
      begin
        data.server.update_role(**options)
      rescue Discordrb::Errors::NoPermission
        data.edit_response(content: RESPONSE[7])
        return
      end
    end

    data.edit_response(content: RESPONSE[5])
  end
end
