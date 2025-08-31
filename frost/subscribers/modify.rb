# frozen_string_literal: true

module Boosters
  # Command handler for /booster role edit.
  def self.edit(data)
    unless data.server.bot.permission?(:manage_roles)
      data.edit_response(content: RESPONSE[10])
      return
    end

    unless data.user.boosting?
      data.edit_response(content: RESPONSE[15])
      return
    end

    unless safe_name?(data)
      data.edit_response(content: RESPONSE[14])
      return
    end

    # Initalize the invoking user.
    member = Boosters::Member.new(data)

    if member.guild.blank?
      data.edit_response(content: RESPONSE[18])
      return
    end

    if member.blank?
      data.edit_response(content: RESPONSE[2])
      return
    end

    if member.banned?
      data.edit_response(content: RESPONSE[11])
      return
    end

    if data.server.role(member.role).nil?
      data.edit_response(content: RESPONSE[2])
      return member.delete
    end

    options = {
      colour: to_color(data.options["color"]),
      name: data.options["name"],
      reason: reason(data),
      role: member.role
    }.compact

    if valid_icon?(data, member.guild)
      options[:icon] = to_icon(data)
    end

    if data.options["icon"]&.match?(REGEX[3])
      options[:icon] = :NULL
    end

    if options[:colour]
      options[:secondary] = :NULL
      options[:tertiary] = :NULL
    end

    if options.size > 2
      begin
        data.server.update_role(**options)
      rescue Discordrb::Errors::NoPermission
        data.edit_response(content: RESPONSE[6])
        return
      end
    end

    data.edit_response(content: RESPONSE[7])

    # Do this after in order to not block everything else.
    member.color = options[:colour] if options[:colour]
  end
end
