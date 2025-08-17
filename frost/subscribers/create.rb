# frozen_string_literal: true

module Boosters
  # Command handler for /booster role claim.
  def self.create(data)
    unless data.server.bot.permission?(:manage_roles)
      data.edit_response(content: RESPONSE[9])
      return
    end

    unless data.user.boosting?
      data.edit_response(content: RESPONSE[14])
      return
    end

    if data.server.roles.size == 250
      data.edit_response(content: RESPONSE[8])
      return
    end

    unless safe_name?(data)
      data.edit_response(content: RESPONSE[13])
      return
    end

    # Initalize the invoking user.
    member = Boosters::Member.new(data)

    unless member.blank?
      data.edit_response(content: RESPONSE[18])
      return
    end

    if member.guild.blank?
      data.edit_response(content: RESPONSE[17])
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

    data.edit_response(content: RESPONSE[1])

    data.user.add_role(role, reason(data))

    # rubocop:disable Lint/UselessSetterCall
    member.role = role
    # rubocop:enable Lint/UselessSetterCall
  end
end
