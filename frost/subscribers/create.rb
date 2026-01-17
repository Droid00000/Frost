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
      return member&.try_delete
    end

    if member&.banned?
      data.edit_response(content: RESPONSE[11])
      return
    end

    if guild.role_deleted?
      data.edit_response(content: RESPONSE[9])
      return
    end

    # The audit log reason to show.
    reason = "Booster Roles (ID: #{data.user.id})"

    begin
      role = data.server.create_role(
        hoist: false,
        reason: reason,
        permissions: 0,
        mentionable: false,
        name: data.options["name"],
        display_icon: serialize_icon(data, guild),
        colour: serialize_color(data.options["color"])
      )
    rescue Discordrb::Errors::NoPermission
      data.edit_response(content: RESPONSE[10])
      return
    end

    begin
      role.move(above: guild.role_id)
    rescue Discordrb::Errors::NoPermission
      data.edit_response(content: RESPONSE[3])
      return role.delete(reason)
    end

    data.edit_response(content: RESPONSE[1])

    begin
      data.user.add_role(role, reason)
    rescue Discordrb::Errors::NoPermission
      data.edit_response(content: RESPONSE[10])
      return
    end

    Booster.create(
      role: role,
      user_id: data.user.id,
      guild_id: data.server_id
    )

    # If an exception was raised here, that means either the {guild_id, user_id} constraint was
    # violated, or the guild disabled booster perks during the execution of the application command. When
    # this happens, we can just delete the duplicate role that was just created, and call it a day afterwards.
  rescue Sequel::UniqueConstraintViolation, Sequel::ForeignKeyConstraintViolation
    data.server.role(role).delete(reason)
  end
end
