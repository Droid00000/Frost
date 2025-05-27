# frozen_string_literal: true

module Birthdays
  # Delete your birthday.
  def self.delete(data)
    # Initialize and delete in one go.
    Member.new(data, lazy: true).delete

    data.edit_response(content: RESPONSE[4])
  end
end
