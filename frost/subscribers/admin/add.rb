# frozen_string_literal: true

module Admin
  # Namespace for booster admins.
  module Boosters
    # Create an artifical booster for the guild.
    def self.create(data)
      unless data.user.permission?(:manage_roles)
        data.edit_response(content: RESPONSE[:manage_roles])
        return
      end

      unless ::Boosters::Guild.get(data.server_id)
        data.edit_response(content: RESPONSE[:unknown_guild])
        return
      end

      user_role = data.server.role(data.options["role"].to_i)

      unless user_role
        data.edit_response(content: RESPONSE[:unknown_role])
        return
      end

      if (user = ::Boosters::Booster.get(data))
        user.edit(role: user_role.id)
      else
        ::Boosters::Booster.create(
          role: user_role.id,
          guild_id: data.server_id,
          user_id: data.options["target"]
        )
      end

      data.edit_response(content: RESPONSE[:manual_insertion])
    end
  end
end
