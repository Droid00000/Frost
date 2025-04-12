# frozen_string_literal: true

module Boosters
  # Command handler for /booster role gradient.
  def self.colors(data)
    # Return early unless we have the permission to
    # create and manage roles in this server.
    unless data.server.bot.permission?(:manage_roles)
      data.edit_response(content: RESPONSE[47])
      return
    end

    # Return early unless the user is boosting this server.
    unless data.user.boosting?
      data.edit_response(content: RESPONSE[8])
      return
    end

    # Initalize the booster guild and the user
    # we're operating on for this command.
    guild, member = Guild.new(data), User.new(data)

    # Check if our server is setup. If not, we can
    # simply return early here.
    if guild.blank?
      data.edit_response(content: RESPONSE[5])
      return
    end

    # Check if our user is banned. If so, then
    # we can simply return early here.
    if member.banned?
      data.edit_response(content: RESPONSE[6])
      return
    end

    # Ensure our user already has a role. If they
    # don't we can simply return early.
    if member.blank?
      data.edit_response(content: RESPONSE[4])
      return
    end

    data.options.each do |name, value|
      data.options[name] = to_color(value)
    end

    payload = {
      role: member.role,
      reason: REASON[1],
      primary: data.options["first"],
      ternerary: data.options["third"],
      secondary: data.options["second"]
    }.compact

    data.edit_response(content: RESPONSE[2])

    data.server.update_role(**payload) if payload.size > 2
  end
end
