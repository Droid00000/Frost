# frozen_string_literal: true

module Boosters
  # Command handler for /booster role gradient.
  def self.colors(data)
    unless data.server.bot.permission?(:manage_roles)
      data.edit_response(content: RESPONSE[10])
      return
    end

    unless data.user.boosting?
      data.edit_response(content: RESPONSE[15])
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
      tertiary: :NULL,
      role: member.role,
      reason: reason(data),
      colour: to_color(data.options["start"]),
      secondary: to_color(data.options["end"])
    }

    # Resolve the given role here.
    role = data.server.role(member.role)

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
        options.merge!(HOLOGRAPHIC)
      end
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
