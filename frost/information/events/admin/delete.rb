# frozen_string_literal: true

module AdminCommands
  # Namespace for event admins.
  module Events
    # Remove an event role from a user.
    def self.delete(data)
      unless data.user.permission?(:manage_roles)
        data.edit_response(content: RESPONSE[1])
        return
      end

      options = {
        role_id: data.options["role"],
        user_id: data.options["target"]
      }

      POSTGRES[:event_users].where(**options).delete

      data.edit_response(content: RESPONSE[5])
    end
  end
end
