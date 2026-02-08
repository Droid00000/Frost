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

    unless (guild = Guild.get(data))
      data.edit_response(content: RESPONSE[18])
      return
    end

    unless (member = Booster.get(data))
      data.edit_response(content: RESPONSE[2])
      return
    end

    if Ban.get(data)
      data.edit_response(content: RESPONSE[11])
      return
    end

    unless (role = member.role)
      data.edit_response(content: RESPONSE[2])
      return Booster.delete(data)
    end

    if guild.no_gradient?
      data.edit_response(content: RESPONSE[7])
      return
    end

    if !data.interaction.server_features.any?(:enhanced_role_colors) && options["style"] != 0
      data.edit_response(content: RESPONSE[7])
      return
    end

    options = {
      tertiary: nil,
      reason: member.reason,
      primary: get_color(data.options["start"]) || :undef,
      secondary: get_color(data.options["end"]) || :undef
    }

    state = if options["style"] == 1
              # When the style of the role is a two-point gradient, we should simply try
              # and validate the colors that the user provided to us.
              validate_gradient(role: role, one: options[:primary], two: options[:secondary])

            elsif options["style"] == 0
              # When the style of the role is a solid color, we should reset the other two
              # gradient parameters and reset back to the base color of the booster.
              options.merge!({ primary: member.role_color, tertiary: nil, secondary: nil })

            elsif options["style"] == 2 && (options[:primary] || options[:secondary])
              # When the style of the role is holographic and the other two parameters are provided
              # we ignore the style and treat the request as if it's for a custom gradient.
              validate_gradient(role: role, one: options[:primary], two: options[:secondary])

            elsif options["style"] == 2 && !(options[:primary] && options[:secondary])
              # When the style of the role is holographic and the other two parameters aren't provided
              # we should not ignore the style and instead set the three colors for the holographic preset.
              options.merge!({ primary: 11_127_295, secondary: 16_759_788, tertiary: 16_761_760 })
            end

    if state.is_a?(String)
      data.edit_response(content: state)
      return
    end

    begin
      role.update_colors(**options)
    rescue Discordrb::Errors::NoPermission
      data.edit_response(content: RESPONSE[6])
      return
    end

    data.edit_response(content: RESPONSE[7])
  end
end
