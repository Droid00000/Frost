# frozen_string_literal: true

module Birthdays
  # setup and add your birthday.
  def self.create(data)
    unless Frost::Birthdays::Settings.role(data)
      data.edit_response(content: RESPONSE[104])
      return
    end

    if Frost::Birthdays.user?(data)
      data.edit_response(content: RESPONSE[112])
      return
    end

    if Birthdays.timezone(data).nil?
      data.edit_response(content: RESPONSE[129])
      return
    end

    if Birthdays.date(data).nil?
      data.edit_response(content: RESPONSE[130])
      return
    end

    payload = {
      active: false,
      user_id: data.user.id,
      guild_id: data.server.id,
      birthday: Birthdays.date(data),
      timezone: Birthdays.timezone(data)
    }

    Frost::Birthdays.add(**payload)

    data.edit_response(content: RESPONSE[107])
  end
end
