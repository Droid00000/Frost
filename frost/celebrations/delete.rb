# frozen_string_literal: true

module Birthdays
  # Delete your birthday.
  def self.delete(data)
    # Initialize and delete in one go.
    Member.new(data, lazy: true).delete

    # Delete the local record for the user.
    Scheduler.delete(data.user.id)

    data.edit_response(content: RESPONSE[7])
  end
end
