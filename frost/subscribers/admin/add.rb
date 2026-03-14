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

      if ::Boosters::Booster.get(data)
        data.edit_response(content: RESPONSE[:shared_conflict])
        return
      end

      ::Boosters::Booster.create(
        guild_id: data.server_id,
        user_id: data.options["target"],
        role_id: data.options["role"].to_i
      ) rescue nil

      data.edit_response(content: RESPONSE[:manual_insertion])
    end
  end
end
