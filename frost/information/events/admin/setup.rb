# frozen_string_literal: true

module AdminCommands
  # Namespace for event admins.
  module Events
    # Setup an event role.
    def self.setup(data)
      unless data.user.permission?(:manage_roles)
        data.edit_response(content: RESPONSE[1])
        return
      end

      role = data.server.role(data.options["role"])

      options = {
        role_id: role.id,
        setup_by: data.user.id,
        setup_at: Time.now.to_i,
        guild_id: data.server.id
      }

      if options[:role_id].to_i == data.server.id
        data.edit_response(content: RESPONSE[1])
        return
      end

      role.tags&.instance_variables&.each do |name|
        if role.tags.instance_variable_get(name)
          data.edit_response(content: RESPONSE[1])
          return
        end
      end

      POSTGRES[:event_roles].insert_conflict.insert(**options)

      data.edit_response(**MENTIONS, content: format(RESPONSE[3], role.id))
    end
  end
end
