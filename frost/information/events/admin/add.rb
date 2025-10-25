# frozen_string_literal: true

module AdminCommands
  # Namespace for event admins.
  module Events
    # Manually add a user to the database.
    def self.add(data)
      unless data.user.permission?(:manage_roles)
        data.edit_response(content: RESPONSE[1])
        return
      end

      options = {
        guild_id: data.server.id,
        role_id: data.options["role"],
        user_id: data.options["target"]
      }

      begin
        POSTGRES[:event_users].insert_conflict.insert(**options)
      rescue Sequel::ForeignKeyConstraintViolation
        data.edit_response(content: RESPONSE[7])
        return
      end

      data.edit_response(content: RESPONSE[6])
    end
  end
end
