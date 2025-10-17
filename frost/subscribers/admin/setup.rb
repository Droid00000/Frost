# frozen_string_literal: true

module AdminCommands
  # Namespace for booster admins.
  module Boosters
    # Setup booster perks or edit them.
    def self.setup(data)
      unless data.user.permission?(:manage_roles)
        data.edit_response(content: RESPONSE[6])
        return
      end

      options = {
        added_features: 0,
        unset_features: 0,
        user_id: data.user.id,
        role_id: data.options["role"]
      }

      guild = ::Boosters::Guild.new(data, lazy: true)

      case data.options["icon"]
      when TrueClass
        options[:added_features] |= ::Boosters::Guild::FLAGS[:any_icon]
      when FalseClass
        options[:unset_features] |= ::Boosters::Guild::FLAGS[:any_icon]
      end

      state = guild.edit(**options.compact)

      if state == 400 && options[:role_id].nil?
        data.edit_response(content: RESPONSE[3])
        return
      end

      if state == 200
        data.edit_response(content: RESPONSE[8])
      else
        data.edit_response(content: RESPONSE[9])
      end
    end
  end
end
