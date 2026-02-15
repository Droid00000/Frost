# frozen_string_literal: true

module Admin
  # Namespace for administrators.
  module Birthdays
    # Disable the birthdays-perks functionality for the guild.
    def self.disable(data)
      unless data.user.permission?(:administrator)
        data.edit_response(content: RESPONSE[3])
        return
      end

      data.edit_response(content: RESPONSE[4])

      # Cleanup should be async so interaction doesn't timeout.
      ::Birthdays::Storage.delete_guild(guild_id: data.server_id)
    end
  end
end
