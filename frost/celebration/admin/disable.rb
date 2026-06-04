# frozen_string_literal: true

module Admin
  # Namespace for administrators.
  module Birthdays
    # Disable the birthdays-perks functionality for the guild.
    def self.disable(data)
      unless data.user.can_administrate?
        data.edit_response(content: RESPONSE[3])
        return
      end

      data.edit_response(content: RESPONSE[4])

      # Cleanup should be run asynchronously.
      ::Birthdays::Guild.delete(data.server_id)
    end
  end
end
