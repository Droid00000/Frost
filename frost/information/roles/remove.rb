# frozen_string_literal: true

module AdminCommands
  # Namspace for admin commands.
  module Roles
    # Remove a single role from the DB.
    def self.remove(data)
      unless data.user.permission?(:manage_roles)
        data.edit_response(content: RESPONSE[18])
        return
      end

      Role.new(data, lazy: true).delete

      data.edit_response(content: format(RESPONSE[93], data.options["role"]))
    end
  end
end
