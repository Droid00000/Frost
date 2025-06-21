# frozen_string_literal: true

module Boosters
  # Command handler for /booster role claim.
  def self.create(data)
    unless data.server.bot.permission?(:manage_roles)
      data.edit_response(content: RESPONSE[9])
      return
    end

    # unless data.user.boosting?
    #  data.edit_response(content: RESPONSE[12])
    #  return
    # end

    if data.server.roles.size == 250
      data.edit_response(content: RESPONSE[8])
      return
    end

    unless safe_name?(data.options["name"])
      data.edit_response(content: RESPONSE[11])
      return
    end

    # Initalize the invoking user.
    member = Boosters::Member.new(data)

    unless member.blank?
      data.edit_response(content: RESPONSE[16])
      return
    end

    if member.guild.blank?
      data.edit_response(content: RESPONSE[15])
      return
    end

    if member.banned?
      data.edit_response(content: RESPONSE[10])
      return
    end

    options = {
      colour: to_color(data.options["color"]),
      name: data.options["name"],
      reason: reason(data),
      mentionable: false,
      permissions: 0,
      hoist: false
    }

    if valid_icon?(data, member.guild)
      puts "icon is valid!"
      options[:icon] = to_icon(data)
    end

    begin
      role = data.server.create_role(**options)
    rescue Discordrb::Errors::NoPermission
      data.edit_response(content: RESPONSE[9])
      return
    end

    begin
      role.sort_above(member.guild.hoist_role)
    rescue Discordrb::Errors::NoPermission
      data.edit_response(content: RESPONSE[3])
      return role.delete
    end

    data.user.add_role(role, reason(data))

    member.role = role

    data.edit_response(content: RESPONSE[1])
  end
end
