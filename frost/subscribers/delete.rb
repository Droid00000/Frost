# frozen_string_literal: true

module Boosters
  # Command handler for /booster role delete.
  def self.delete(data)
    unless data.server.bot.permission?(:manage_roles)
      data.edit_response(content: RESPONSE[9])
      return
    end

    unless data.user.boosting?
      data.edit_response(content: RESPONSE[14])
      return
    end

    # Initalize the invoking user.
    member = Boosters::Member.new(data)

    if member.guild.blank?
      data.edit_response(content: RESPONSE[17])
      return
    end

    if member.blank?
      data.edit_response(content: RESPONSE[2])
      return
    end

    if member.banned?
      data.edit_response(content: RESPONSE[10])
      return
    end

    role = data.server.role(member.role)

    # The role may not exist sometimes.
    begin
      role&.delete(reason(data))
    rescue Discordrb::Errors::NoPermission
      data.edit_response(content: RESPONSE[5])
      return
    end

    data.edit_response(content: RESPONSE[4])

    # Perform the cleanup in the background
    member.delete
  end
end
