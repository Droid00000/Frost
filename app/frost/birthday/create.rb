# frozen_string_literal: true

module Birthday
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

    if Birthday.timezone(data).nil?
      data.edit_response(content: RESPONSE[105])
      return
    end

    payload = {
      active: false,
      user_id: data.user.id,
      guild_id: data.server.id,
      timezone: Birthday.timezone(data),
      birthday: Time.parse(data.options["date"]).iso8601
    }

    Frost::Birthdays.add(**payload)

    data.edit_response(content: RESPONSE[107])
  end
end
