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
        setup_by: data.user.id,
        setup_at: Time.now.to_i,
        guild_id: data.server.id,
        role_id: data.options["role"]
      }

      guild = ::Boosters::Guild.new(data)

      if guild.blank? && data.options["role"].nil?
        data.edit_response(content: RESPONSE[2])
        return
      end

      if guild.blank? && data.options["icon"].nil?
        data.edit_response(content: RESPONSE[3])
        return
      end

      unless data.options["icon"].nil?
        options[:features] = case data.options["icon"]
                             when TrueClass
                               (guild.features || 0) | ::Boosters::Guild::FLAGS[:any_icon]
                             when FalseClass
                               (guild.features || 0) & ~::Boosters::Guild::FLAGS[:any_icon]
                             end
      end

      guild.edit(**options.compact)

      if guild.blank?
        data.edit_response(content: RESPONSE[9])
      else
        data.edit_response(content: RESPONSE[8])
      end
    end
  end
end
