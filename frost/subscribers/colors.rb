# frozen_string_literal: true

module Boosters
  # Command handler for /booster role gradient.
  def self.colors(data)
    unless data.server.bot.permission?(:manage_roles)
      data.edit_response(content: RESPONSE[9])
      return
    end

    unless data.user.boosting?
      data.edit_response(content: RESPONSE[12])
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

    if member.guild.blank?
      data.edit_response(content: RESPONSE[15])
      return
    end

    options = {
      role: member.role,
      reason: reason(data),
      colour: to_color(data.options["start"]),
      secondary: to_color(data.options["end"])
    }.compact

    validate_gradient_colors = proc do
      if options[:colour].nil?
        return data.edit_response(content: RESPONSE[13])
      end

      if options[:secondary].nil?
        return data.edit_response(content: RESPONSE[14])
      end
    end

    case data.options["style"]
    when 0
      options[:colour] = member.color
    when 2
      options.merge!(HOLOGRAPHIC)
    when 1
      validate_gradient_colors
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
