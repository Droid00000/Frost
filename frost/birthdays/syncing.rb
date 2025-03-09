# frozen_string_literal: true

module Birthdays
  # Sync your birthday to a server.
  def self.sync(data)
    unless Frost::Birthdays::Settings.role(data)
      data.edit_response(content: RESPONSE[104])
      return
    end

    unless Frost::Birthdays.user?(data)
      data.edit_response(content: RESPONSE[103])
      return
    end

    member = Frost::Birthdays.user(data)

    payload = {
      active: false,
      user_id: data.user.id,
      guild_id: data.server.id,
      timezone: member[:timezone],
      birthday: member[:birthday].iso8601
    }

    Frost::Birthdays.add(**payload)

    data.edit_response(content: RESPONSE[117])
  end
end
