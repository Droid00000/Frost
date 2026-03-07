# frozen_string_literal: true

module Boosters
  # Modify a role's colors, for a booster. This command takes three parameters.
  #
  # @param holographic [true, false, nil] Whether or not to apply or remove the holographic
  #   style from the role.
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

    if Ban.get(data)
      data.edit_response(content: RESPONSE[11])
      return
    end

    unless (member = Booster.get(data))
      data.edit_response(content: RESPONSE[2])
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

    if data.interaction.server_features.none?(:enhanced_role_colors)
      data.edit_response(content: RESPONSE[7])
      return
    end

    options = {
      tertiary: nil,
      reason: member.reason,
      primary: get_color(data.options["start"]) || :undef,
      secondary: get_color(data.options["end"]) || :undef
    }

    state = if !data.options["holographic"].nil? && options.values[2..].all?(:undef)
              # When the holographic parameter is set to either true or false, and none of the
              # other options have been passed, we should attempt to set the holographic colors.
              tertiary = data.options["holographic"] ? 16_761_760 : nil
  
              options.merge!(primary: 11_127_295, secondary: 16_759_788, tertiary: tertiary)
            else
              # When the holographic parameter is either left blank, or one of the two options
              # have been provided as valid colors, then attempt to validate the two-point gradient.

              validate_gradient(role: role, one: options[:primary], two: options[:secondary])
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
