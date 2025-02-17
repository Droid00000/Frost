# frozen_string_literal: true

module Birthday
  # setup and add your birthday.
  def self.edit(data)
    unless Frost::Birthdays::Settings.role(data)
      data.edit_response(content: RESPONSE[104])
      return
    end

    if data.options.empty?
      data.edit_response(content: RESPONSE[113])
      return
    end

    unless Frost::Birthdays.user?(data)
      data.edit_response(content: RESPONSE[103])
      return
    end

    if Birthday.timezone(data).nil? && data.options["timezone"]
      data.edit_response(content: RESPONSE[105])
      return
    end

    if data.options["date"]
      date = Time.parse(data.options["date"])
    end

    payload = {
      birthday: date&.iso8601,
      timezone: Birthday.timezone(data)
    }

    Frost::Birthdays.edit(data, payload.compact)

    data.edit_response(content: RESPONSE[117])
  end
end
