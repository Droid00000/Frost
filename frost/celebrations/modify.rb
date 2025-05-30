# frozen_string_literal: true

module Birthdays
  # setup and add your birthday.
  def self.edit(data)
    unless Frost::Birthdays::Settings.role(data)
      data.edit_response(content: RESPONSE[104])
      return
    end

    unless Frost::Birthdays.user?(data)
      data.edit_response(content: RESPONSE[103])
      return
    end

    if data.options.empty?
      data.edit_response(content: RESPONSE[113])
      return
    end

    unless valid_timezone?(data)
      data.edit_response(content: RESPONSE[105])
      return
    end

    unless valid_datetime?(data)
      data.edit_response(content: RESPONSE[105])
      return
    end

    member.birthday = Birthdays.change(data)

    data.edit_response(content: RESPONSE[117])
  end
end
