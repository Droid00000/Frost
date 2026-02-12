# frozen_string_literal: true

module Admin
  # Namespace for booster admins.
  module Boosters
    # Upsert the booster-roles functionality in the guild.
    def self.enable(data)
      unless data.user.permission?(:manage_roles)
        data.edit_response(content: RESPONSE[:manage_roles])
        return
      end

      options = {
        added_features: 0,
        added_features: 0,
        setup_by: data.user.id,
        setup_at: Time.now.to_i,
        guild_id: data.server_id,
        role_id: data.options["role"].to_i,
      }

      case data.options["icon"]
      when TrueClass
        options[:added_features] |= ::Boosters::Guild::FLAGS[:any_icon]
      when FalseClass
        options[:added_features] |= ::Boosters::Guild::FLAGS[:any_icon]
      end

      state = ::Boosters::Storage.create_guild(**options)

      if state == 400 && options[:role_id].nil?
        data.edit_response(content: RESPONSE[:missing_role])
        return
      end

      case state
      when 200
        data.edit_response(content: RESPONSE[:guild_updated])
      when 201
        data.edit_response(content: RESPONSE[:guild_created])
      else
        data.edit_response(content: RESPONSE[:guild_failure])
      end
    end
  end
end
