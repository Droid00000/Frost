# frozen_string_literal: true

module AdminCommands
  # Namespace for birthday admins.
  module Birthdays
    # Disable birthday perks in this server.
    def self.disable(data)
      unless data.user.permission?(:administrator)
        data.edit_response(content: RESPONSE[3])
        return
      end

      ::Birthdays::Guild.delete(data)

      data.edit_response(content: RESPONSE[4])
    end
  end
end
