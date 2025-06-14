# frozen_string_literal: true

module Birthdays
  # Delete your birthday.
  def self.delete(data)
    # Initialize and delete in one go.
    Member.new(data, lazy: true).delete

    # Delete the local record for the user.
    Birthdays::Scheduler.delete(data.user.id)

    data.edit_response(content: RESPONSE[5])
  end
end
