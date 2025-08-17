# frozen_string_literal: true

module Birthdays
  # Sync your birthday to a server.
  def self.sync(data)
    # Initialize the invoking user.
    member = Birthdays::Member.new(data)

    if member.blank?
      data.edit_response(content: RESPONSE[1])
      return
    end

    if member.guild.blank?
      data.edit_response(content: RESPONSE[4])
      return
    end

    member.synced? ? member.desync : member.sync

    if member.synced?
      data.edit_response(content: RESPONSE[2])
    else
      data.edit_response(content: RESPONSE[3])
    end
  end
end
