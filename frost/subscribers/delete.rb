# frozen_string_literal: true

module Boosters
  # Command handler for /booster role delete.
  def self.delete(data)
    unless data.server.bot.permission?(:manage_roles)
      data.edit_response(content: RESPONSE[10])
      return
    end

    unless data.user.boosting?
      data.edit_response(content: RESPONSE[15])
      return
    end

    if !Guild.get(data)
      data.edit_response(content: RESPONSE[18])
      return
    end

    if !(member = Member.get(data))
      data.edit_response(content: RESPONSE[2])
      return
    end

    if member.banned?
      data.edit_response(content: RESPONSE[11])
      return
    end

    if member.role_deleted?
      data.edit_response(content: RESPONSE[4])
      return Member.delete(data)
    end

    role = data.server.role(member.role_id)

    # The role may not exist sometimes.
    begin
      role&.delete(member.reason)
    rescue Discordrb::Errors::NoPermission
      data.edit_response(content: RESPONSE[5])
      return
    end

    data.edit_response(content: RESPONSE[4])
    Member.delete(data)
  end
end
