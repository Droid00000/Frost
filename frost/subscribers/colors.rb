# frozen_string_literal: true

module Boosters
  # Command handler for /booster role gradient.
  def self.colors(data)
    unless data.server.bot.permission?(:manage_roles)
      data.edit_response(content: RESPONSE[7])
      return
    end

    # unless data.user.boosting?
    #  data.edit_response(content: RESPONSE[10])
    #  return
    # end

    # Initalize the invoking user.
    member = Boosters::Member.new(data)

    if member.blank?
      data.edit_response(content: RESPONSE[2])
      return
    end

    if member.banned?
      data.edit_response(content: RESPONSE[8])
      return
    end

    # Map to: { name => COLOR || name => :NULL }
    data.options.each do |name, value|
      data.options[name] = if value.match?(REGEX[2])
                             :NULL
                           else
                             to_color(value)
                           end
    end

    options = {
      role: member.role,
      reason: reason(data),
      tertiary: data.options["end"],
      secondary: data.options["start"]
    }.compact

    if options.size > 2
      begin
        data.server.update_role(**options)
      rescue Discordrb::Errors::NoPermission
        data.edit_response(content: RESPONSE[7])
        return
      end
    end

    data.edit_response(content: RESPONSE[5])
  end
end
