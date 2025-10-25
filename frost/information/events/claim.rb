# frozen_string_literal: true

module Events
  # Command handler for /event role claim.
  def self.claim(data)
    unless data.server.bot.permission?(:manage_roles)
      data.edit_response(content: RESPONSE[3])
      return
    end

    if data.options["role"].to_i == data.server.id
      data.edit_response(content: RESPONSE[4])
      return
    end

    member = Events::Member.new(data)

    unless member.role?
      data.edit_response(content: RESPONSE[7])
      return
    end

    if member.blank?
      data.edit_response(content: RESPONSE[4])
      return
    end

    begin
      case data.options["display"]
      when TrueClass
        update_roles(data, member)
      when FalseClass
        unless data.user.role?(member.role_id)
          data.user.add_role(member.role_id, "Event Roles")
        end
      end
    rescue Discordrb::Errors::NoPermission
      data.edit_response(content: RESPONSE[5])
      return
    end

    data.edit_response(**MENTIONS, content: format(RESPONSE[2], member.role_id))
  end
end
