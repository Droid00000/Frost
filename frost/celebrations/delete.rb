# frozen_string_literal: true

module Birthdays
  # Delete your birthday.
  def self.delete(data)
    # Initialize and delete in one go.
    Member.new(data, lazy: true).delete

    # Delete the current task if it exists.
    Orchestrator.unschedule(data.user)

    data.edit_response(content: RESPONSE[5])
  end
end
