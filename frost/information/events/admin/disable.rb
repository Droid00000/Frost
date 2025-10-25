# frozen_string_literal: true

module AdminCommands
  # Namespace for event admins.
  module Events
    # Remove an event role for a server.
    def self.disable(data)
      unless data.user.permission?(:manage_roles)
        data.edit_response(content: RESPONSE[1])
        return
      end

      options = {
        guild_id: data.server.id,
        role_id: data.options["role"]
      }

      POSTGRES[:event_roles].where(**options).delete

      data.edit_response(**MENTIONS, content: format(RESPONSE[2], options[:role_id]))
    end
  end
end
