# frozen_string_literal: true

module AdminCommands
  # Namespace for booster admins.
  module Boosters
    # Disable booster perks for a server.
    def self.disable(data)
      unless data.user.permission?(:manage_roles)
        data.edit_response(content: RESPONSE[6])
        return
      end

      data.edit_response(content: RESPONSE[7])

      # Do this after, since it can take a while.
      Boosters::Guild.delete(data)
    end
  end
end
