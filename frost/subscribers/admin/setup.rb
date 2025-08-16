# frozen_string_literal: true

module AdminCommands
  # namespace for booster admins.
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
        role_id: data.options["role"],
        any_icon: data.options["icon"]
      }

      guild = ::Boosters::Guild.new(data)

      if guild.blank? && options[:role_id].nil?
        data.edit_response(content: RESPONSE[2])
        return
      end

      if guild.blank? && options[:any_icon].nil?
        data.edit_response(content: RESPONSE[3])
        return
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
