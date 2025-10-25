# frozen_string_literal: true

module Events
  # Command handler for /event role remove.
  def self.delete(data)
    unless data.server.bot.permission?(:manage_roles)
      data.edit_response(content: RESPONSE[3])
      return
    end

    member = Events::Member.new(data)

    unless member.role?
      data.edit_response(content: RESPONSE[6])
      return
    end

    if member.blank?
      data.edit_response(content: RESPONSE[4])
      return
    end

    if data.user.role?(role.role_id)
      begin
        data.user.remove_role(role.role_id, "Event Roles")
      rescue Discordrb::Errors::NoPermission
        data.edit_response(content: RESPONSE[5])
        return
      end
    end

    data.edit_response(**MENTIONS, content: format(RESPONSE[1], role.role_id))
  end
end
