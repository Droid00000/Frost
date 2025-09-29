# frozen_string_literal: true

module AdminCommands
  # Namespace for booster admins.
  module Boosters
    # Disable booster perks for a server.
    def self.disable(data)
      unless data.user.permission?(:manage_server)
        data.edit_response(content: RESPONSE[6])
        return
      end

      ::Boosters::Guild.new(data, lazy: true).delete

      data.edit_response(content: RESPONSE[7])
    end
  end
end
