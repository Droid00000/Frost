# frozen_string_literal: true

module Boosters
  # Create a role for a guild booster. This command takes three parameters.
  #
  # @param name [String] The name of the role for the booster's custom role that should be
  #   created. This must be between 1-100 characters, otherwise the request to Discord will fail.
  #
  # @param color [String] The base color to set for the role. This must be a hexadecimal value
  #   or one of the values mapped in {COLORS}. This will fallback to no color if no valid color is provided.
  #
  # @param icon [String, nil] The icon to set for the role. This can either be a custom emoji,
  #   a unicode emoji, or simply left blank. This parameter is silently discarded if the guild has disallowed
  #   using external emojis for role icons and an external emoji is provided, or if the guild does not support setting role icons.
  def self.create(data)
    unless data.server.bot.permission?(:manage_roles)
      data.edit_response(content: RESPONSE[10])
      return
    end

    unless data.user.boosting?
      data.edit_response(content: RESPONSE[15])
      return
    end

    if data.server.roles.size == 250
      data.edit_response(content: RESPONSE[8])
      return
    end

    unless safe_name?(data)
      data.edit_response(content: RESPONSE[14])
      return
    end

    unless (guild = Guild.get(data))
      data.edit_response(content: RESPONSE[18])
      return
    end

    if (member = Booster.get(data))
      data.edit_response(content: RESPONSE[19])
      return member&.try_delete(data)
    end

    if member&.banned?
      data.edit_response(content: RESPONSE[11])
      return
    end

    if guild.role_deleted?
      data.edit_response(content: RESPONSE[9])
      return
    end

    options = {
      hoist: false,
      permissions: 0,
      mentionable: false,
      reason: reason(data),
      name: data.options["name"],
      icon: to_icon(data, guild),
      colour: to_color(data.options["color"])
    }

    begin
      role = data.server.create_role(**options)
    rescue Discordrb::Errors::NoPermission
      data.edit_response(content: RESPONSE[10])
      return
    end

    begin
      role.sort_above(guild.role_id)
    rescue Discordrb::Errors::NoPermission
      data.edit_response(content: RESPONSE[3])
      return role.delete
    end

    data.edit_response(content: RESPONSE[1])

    begin
      data.user.add_role(role, reason(data))
    rescue Discordrb::Errors::NoPermission
      data.edit_response(content: RESPONSE[10])
      return
    end

    Booster.create(
      role: role,
      user_id: data.user.resolve_id,
      guild_id: data.server.resolve_id
    )
  end
end
