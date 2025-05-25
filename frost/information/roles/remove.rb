# frozen_string_literal: true

module AdminCommands
  # Namspace for admin commands.
  module Roles
    # Remove a single role from the DB.
    def self.remove(data)
      unless data.user.permission?(:manage_roles)
        data.edit_response(content: RESPONSE[3])
        return
      end

      Role.new(data, lazy: true).delete

      data.edit_response(content: RESPONSE[8])
    end
  end
end
