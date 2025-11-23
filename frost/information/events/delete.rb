# frozen_string_literal: true

module Events
  # Remove an event role from a user.
  def self.delete(data)
    unless data.server.bot.permission?(:manage_roles)
      data.edit_response(content: RESPONSE[3])
      return
    end

    unless (role = Role.get(data))
      data.edit_response(content: RESPONSE[6])
      return
    end

    unless role.user?(user: data.user)
      data.edit_response(content: RESPONSE[4])
      return
    end

    if data.user.role?(role.id)
      data.user.remove_role(role.id, "Event Roles") rescue nil
    end

    data.edit_response(**MENTIONS, content: format(RESPONSE[1], role.id))
  end
end
