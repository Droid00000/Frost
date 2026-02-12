# frozen_string_literal: true

module Admin
  # Namespace for booster admins.
  module Boosters
    # Disable the booster-roles functionality for the guild.
    def self.disable(data)
      unless data.user.permission?(:manage_roles)
        data.edit_response(content: RESPONSE[:manage_roles])
        return
      end

      data.edit_response(content: RESPONSE[:guild_deleted])

      # Cleanup should be async so interaction doesn't timeout.
      ::Boosters::Storage.delete_guild(guild_id: data.server_id)
    end
  end
end
