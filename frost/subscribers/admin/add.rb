# frozen_string_literal: true

module AdminCommands
  # Namespace for booster admins.
  module Boosters
    # Manually adds a user to the database.
    def self.add(data)
      unless data.user.permission?(:manage_roles)
        data.edit_response(content: RESPONSE[6])
        return
      end

      unless Boosters::Guild.get(data)
        data.edit_response(content: RESPONSE[4])
        return
      end

      case Boosters::Booster.get(data)&.banned?
      when TrueClass
        return data.edit_response(content: RESPONSE[5])
      when FalseClass
        return data.edit_response(content: RESPONSE[12])
      end

      # Resolve the role we need to add here.
      role = data.server.role(data.options["role"])

      Boosters::Booster.create(
        role: role,
        user_id: data.options["target"],
        guild_id: data.server.resolve_id
      )

      data.edit_response(content: RESPONSE[13])
    end
  end
end
