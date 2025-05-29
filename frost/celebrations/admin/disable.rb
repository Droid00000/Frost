# frozen_string_literal: true

module AdminCommands
  # Namespace for birthday admins.
  module Birthdays
    # Disable birthday perks in this server.
    def self.disable(data)
      unless data.user.permission?(:administrator)
        data.edit_response(content: RESPONSE[2])
        return
      end

      ::Birthdays::Guild.new(data, lazy: true).delete

      data.edit_response(content: RESPONSE[3])
    end
  end
end
