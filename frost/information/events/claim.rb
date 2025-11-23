# frozen_string_literal: true

module Events
  # Add an event role to a user.
  def self.claim(data)
    unless data.server.bot.permission?(:manage_roles)
      data.edit_response(content: RESPONSE[3])
      return
    end

    unless (role = Role.get(data))
      data.edit_response(content: RESPONSE[7])
      return
    end

    unless role.user?(user: data.user)
      data.edit_response(content: RESPONSE[5])
      return
    end

    if data.options["display"]
      edit_roles(data.server.role(role.id), data.user)
    elsif !data.user.role?(role.id)
      data.user.add_role(role.id, "Event Roles") rescue nil
    end

    data.edit_response(**MENTIONS, content: format(RESPONSE[2], role.id))
  end
end
