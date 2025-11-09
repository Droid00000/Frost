# frozen_string_literal: true

module Boosters
  # Modify a role's colors, for a booster. This command takes three parameters.
  #
  # @param style [Integer] The style of the gradient to apply. This can be one
  #   of three values. `0` signifies that any gradient effects should be removed
  #   and we should revert the user's role to their base colour. `1` signifies that
  #   we should check the other two `start` and `end` parameters, since the user wants
  #   to apply a gradient effect. Lastly, `2` signifies that the user wants to apply a
  #   holographic style. If the `start` or `end` parameters are filled with a value, then
  #   we should treat the command as if the style was set to `2`. Otherwise, we should apply
  #   the holographic preset to the role's colors.
  #
  # @param start [String, nil] The starting color to set for the role's gradient. If the role does
  #   not have a pre-existing gradient set, then the `end` parameter must also be filled with a value.
  #
  # @param end [String, nil] The ending color to set for the role's gradient. If the role does not
  #   have a pre-existing gradient set, then the `start` parameter must also be filled with a value.
  def self.colors(data)
    unless data.server.bot.permission?(:manage_roles)
      data.edit_response(content: RESPONSE[10])
      return
    end

    unless data.user.boosting?
      data.edit_response(content: RESPONSE[15])
      return
    end

    unless Guild.get(data)
      data.edit_response(content: RESPONSE[18])
      return
    end

    unless (member = Booster.get(data))
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
      tertiary: :NULL,
      role: member.role_id,
      reason: member.reason,
      colour: to_color(data.options["start"]),
      secondary: to_color(data.options["end"])
    }.compact

    role = data.server.role(options[:role])

    gradient_validator = proc do
      if !options[:colour] && !options[:secondary]
        if role.gradient?
          data.edit_response(content: RESPONSE[13])
          return
        end

        unless role.gradient?
          data.edit_response(content: RESPONSE[12])
          return
        end
      end

      if role.holographic? || !role.gradient?
        unless options[:colour]
          data.edit_response(content: RESPONSE[16])
          return
        end

        unless options[:secondary]
          data.edit_response(content: RESPONSE[17])
          return
        end
      end
    end

    case data.options["style"]
    when 1
      gradient_validator.call
    when 2
      if options[:colour] || options[:secondary]
        gradient_validator.call
      else
        options.merge!(HOLOGRAPHIC_COLORS)
      end
    when 0
      options.merge!(
        tertiary: :NULL,
        secondary: :NULL,
        colour: member.role_color
      )
    end

    begin
      data.server.update_role(**options)
    rescue Discordrb::Errors::NoPermission
      data.edit_response(content: RESPONSE[6])
      return
    end

    data.edit_response(content: RESPONSE[7])
  end
end
