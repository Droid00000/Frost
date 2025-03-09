# frozen_string_literal: true

module Birthdays
  # Disable birthdays for the calling server.
  def self.disable(data)
    unless data.user.permission?(:administrator)
      data.edit_response(content: RESPONSE[51])
      return
    end

    Frost::Birthdays::Settings.disable(data)

    if data.options["prune"]
      Frost::Birthdays.prune(data)
    end

    data.edit_response(content: RESPONSE[109])
  end
end
