# frozen_string_literal: true

module Boosters
  # Command handler for /booster role edit.
  def self.edit(data)
    unless data.server.bot.permission?(:manage_roles)
      data.edit_response(content: RESPONSE[10])
      return
    end

    # unless data.user.boosting?
    #  data.edit_response(content: RESPONSE[15])
    #  return
    # end

    unless safe_name?(data)
      data.edit_response(content: RESPONSE[14])
      return
    end

    if !(guild = Guild.get(data))
      data.edit_response(content: RESPONSE[18])
      return
    end

    if !(member = Booster.get(data))
      data.edit_response(content: RESPONSE[2])
      return
    end

    if member.banned?
      data.edit_response(content: RESPONSE[11])
      return
    end

    if member.role_deleted?
      data.edit_response(content: RESPONSE[2])
      return Booster.delete(data)
    end

    options = {
      role: member.role_id,
      reason: member.reason,
      name: data.options["name"],
      icon: to_icon(data, guild),
      colour: to_color(data.options["color"])
    }.compact

    if data.options["icon"]&.match?(REGEX[3])
      options[:icon] = :NULL
    end

    if options[:colour]
      options.merge!(tertiary: :NULL, secondary: :NULL)
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
    member.edit(color_id: options[:colour]) if options[:colour]
  end
end
