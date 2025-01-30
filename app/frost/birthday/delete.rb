# frozen_string_literal: true

module Birthday
  # setup and add your birthday.
  def self.delete(data)
    unless Frost::Birthdays.user?(data)
      data.edit_response(content: RESPONSE[103])
      return
    end
    
    Frost::Birthdays.delete(data)

    data.edit_response(content: format(RESPONSE[106]))
  end
end
