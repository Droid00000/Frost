# frozen_string_literal: true

module Admin
  # Namespace for booster admins.
  module Boosters
    # Delete a pre-exisiting booster from the guild.
    def self.delete(data)
      unless data.user.permission?(:manage_roles)
        data.edit_response(content: RESPONSE[:manage_roles])
        return
      end

      unless ::Boosters::Guild.get(data.server_id)
        data.edit_response(content: RESPONSE[:unknown_guild])
        return
      end

      result = ::Boosters::Booster.delete(data)

      if prune && data.server.bot.permission?(:manage_roles)
        result&.role&.delete("Booster Admins (ID: #{data.user.id})")
      end

      data.edit_response(content: RESPONSE[:manual_deletion])
    end
  end
end
