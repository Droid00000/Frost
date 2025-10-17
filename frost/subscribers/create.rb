# frozen_string_literal: true

module Boosters
  # Command handler for /booster role claim.
  def self.create(data)
    unless data.server.bot.permission?(:manage_roles)
      data.edit_response(content: RESPONSE[10])
      return
    end

    unless data.user.boosting?
      data.edit_response(content: RESPONSE[15])
      return
    end

    if data.server.roles.size == 250
      data.edit_response(content: RESPONSE[8])
      return
    end

    unless safe_name?(data)
      data.edit_response(content: RESPONSE[14])
      return
    end

    # Initalize the invoking user.
    member = Boosters::Member.new(data)

    # Reset the state for the member.
    member.delete if member.blank_role?

    unless member.blank?
      data.edit_response(content: RESPONSE[19])
      return
    end

    if member.guild.blank?
      data.edit_response(content: RESPONSE[18])
      return
    end

    if member.banned?
      data.edit_response(content: RESPONSE[11])
      return
    end

    unless data.server.role(member.guild.hoist_role)
      data.edit_response(content: RESPONSE[9])
      return
    end

    options = {
      hoist: false,
      permissions: 0,
      mentionable: false,
      reason: reason(data),
      name: data.options["name"],
      icon: to_icon(data, member.guild),
      colour: to_color(data.options["color"])
    }

    begin
      role = data.server.create_role(**options)
    rescue Discordrb::Errors::NoPermission
      data.edit_response(content: RESPONSE[10])
      return
    end

    begin
      role.sort_above(member.guild.hoist_role)
    rescue Discordrb::Errors::NoPermission
      data.edit_response(content: RESPONSE[3])
      return role.delete
    end

    data.edit_response(content: RESPONSE[1])

    begin
      data.user.add_role(role, reason(data))
    rescue Discordrb::Errors::NoPermission
      data.edit_response(content: RESPONSE[10])
      return
    end

    member.role = role if role
  end
end
