# frozen_string_literal: true

module Birthday
  # setup and add your birthday.
  def self.delete(data)
    Frost::Birthdays.delete(data)

    data.edit_response(content: format(RESPONSE[1]))
  end
end
