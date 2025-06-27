# frozen_string_literal: true

module Vanity
  # Command handler for /vanity role gradient.
  def self.colors(data)
    unless data.server.bot.permission?(:manage_roles)
      data.edit_response(content: RESPONSE[3])
      return
    end

    options = {
      tertiary: :NULL,
      reason: reason(data),
      role: data.options["role"],
      colour: ::Boosters.to_color(data.options["start"]),
      secondary: ::Boosters.to_color(data.options["end"])
    }

    role = data.server.role(data.options["role"])

    gradient_validator = proc do
      if !options[:colour] && !options[:secondary]
        data.edit_response(content: RESPONSE[11])
        return
      end

      if role.holographic? || !role.colors.gradient?
        unless options[:colour]
          data.edit_response(content: RESPONSE[14])
          return
        end

        unless options[:secondary]
          data.edit_response(content: RESPONSE[15])
          return
        end
      end
    end

    case data.options["style"]
    when 1
      gradient_validator.call
    when 2
      options.merge!(::Boosters::HOLOGRAPHIC)
    when 0
      options.merge!({
                       colour: role.color,
                       secondary: :NULL,
                       tertiary: :NULL
                     })
    end

    unless exempt?(data.user, Guild.new(data))
      data.edit_response(content: RESPONSE[6])
      return
    end

    begin
      data.server.update_role(**options.compact)
    rescue Discordrb::Errors::NoPermission
      data.edit_response(content: RESPONSE[1])
      return
    end

    data.edit_response(content: RESPONSE[2])
  end
end
