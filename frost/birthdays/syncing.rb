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

    Frost::Birthdays.sync(data)

    data.edit_response(content: RESPONSE[117])
  end
end
