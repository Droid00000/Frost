# frozen_string_literal: true

module Boosters
  # Command handler for /booster role gradient.
  def self.colors(data)
    unless data.server.bot.permission?(:manage_roles)
      data.edit_response(content: RESPONSE[9])
      return
    end

    unless data.user.boosting?
      data.edit_response(content: RESPONSE[13])
      return
    end

    # Initalize the invoking user.
    member = Boosters::Member.new(data)

    if member.blank?
      data.edit_response(content: RESPONSE[2])
      return
    end

    if member.banned?
      data.edit_response(content: RESPONSE[10])
      return
    end

    options = {
      tertiary: :NULL,
      role: member.role,
      reason: reason(data),
      colour: to_color(data.options["start"]),
      secondary: to_color(data.options["end"])
    }

    gradient_validator = proc do
      if !options[:colour] && !options[:secondary]
        data.edit_response(content: RESPONSE[11])
        return
      end

      # Resolve the given role here.
      role = data.server.role(member.role)

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
      options.merge!(HOLOGRAPHIC)
    when 0
      options.merge!({
                       colour: member.color,
                       secondary: :NULL,
                       tertiary: :NULL
                     })
    end

    begin
      data.server.update_role(**options.compact)
    rescue Discordrb::Errors::NoPermission
      data.edit_response(content: RESPONSE[6])
      return
    end

    data.edit_response(content: RESPONSE[7])
  end
end
