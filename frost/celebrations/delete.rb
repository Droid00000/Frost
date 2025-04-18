# frozen_string_literal: true

module Birthdays
  # Delete your birthday.
  def self.delete(data)
    unless Frost::Birthdays.user?(data)
      data.edit_response(content: RESPONSE[103])
      return
    end

    Frost::Birthdays.delete(data)

    data.edit_response(content: RESPONSE[106])
  end
end
