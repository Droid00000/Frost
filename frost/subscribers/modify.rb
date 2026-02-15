# frozen_string_literal: true

module Boosters
  # Modify a role for a guild booster. This command takes three parameters.
  #
  # @param name [String, nil] The new name to set for the booster's role. If provided, the name must be
  #   be between 1-100 characters. If this parameter is `nil`, then the role's name will not be updated.
  #
  # @param color [String, nil] The new base color to set for the booster's role. If provided, This must be
  #   a hexadecimal value  or one of the values mapped in {COLORS}. Additionally, if the role currently has
  #   a gradient set, then the gradient will be #be overwritten and replaced with the solid color that was provided.
  #   If this parameter is `nil`, then the role's color will not be updated.
  #
  # @param icon [String, nil] The new icon to set for the booster's role. This can either be a custom emoji, a
  #   unicode emoji, or simply left blank. This parameter is silently discarded if the guild has disallowed using external
  #   emojis for role icons and an external emoji is provided, or if the guild does not support setting role icons. If this
  #   parameter is `nil`, then the role's icon will not be updated.
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

    unless (guild = Guild.get(data))
      data.edit_response(content: RESPONSE[18])
      return
    end

    if Ban.get(data)
      data.edit_response(content: RESPONSE[11])
      return
    end

    unless (member = Booster.get(data))
      data.edit_response(content: RESPONSE[2])
      return
    end

    unless member.role
      data.edit_response(content: RESPONSE[2])
      return Booster.delete(data)
    end

    options = {
      reason: member.reason,
      role_id: member.role_id,
      name: data.options["name"],
      display_icon: get_icon(data, guild) || :undef,
      colors: get_color(data.options["color"]) || :undef
    }.compact

    if data.options["icon"]&.match?(REGEX[3])
      options[:display_icon] = nil
    end

    if (color = options[:colors] && color != :undef)
      options[:colors] = {
        tertiary_color: nil,
        primary_color: color,
        secondary_color: nil
      }
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

    return unless options[:colors] != :undef

    member.edit(color: options[:colors][:primary_color])
  end
end
