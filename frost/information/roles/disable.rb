# frozen_string_literal: true

module AdminCommands
  # Namspace for admin commands.
  module Roles
    # Disable event perks for the calling server.
    def self.disable(data)
      unless data.user.permission?(:manage_roles)
        data.edit_response(content: RESPONSE[18])
        return
      end

      Guild.new(data, lazy: true).delete

      data.edit_response(content: RESPONSE[39])
    end
  end
end
