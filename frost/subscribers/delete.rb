# frozen_string_literal: true

module Boosters
  # Command handler for /booster role delete.
  def self.delete(data)
    unless data.server.bot.permission?(:manage_roles)
      data.edit_response(content: RESPONSE[6])
      return
    end

    unless data.user.boosting?
      data.edit_response(content: RESPONSE[9])
      return
    end

    # Initalize the invoking user.
    member = Boosters::Member.new(data)

    if member.blank?
      data.edit_response(content: RESPONSE[2])
      return
    end

    if member.banned?
      data.edit_response(content: RESPONSE[7])
      return
    end

    data.server.role(member.role)&.delete
    
    # Delete the member after deleting their role.
    member.delete

    data.edit_response(content: RESPONSE[3])
  end
end
