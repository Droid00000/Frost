# frozen_string_literal: true

module AdminCommands
  # namespace for booster admins.
  module Boosters
    # Setup booster perks or edit them.
    def self.setup(data)
      unless data.user.permission?(:manage_roles)
        data.edit_response(content: RESPONSE[5])
        return
      end

      options = {
        setup_by: data.user.id,
        setup_at: Time.now.to_i,
        guild_id: data.server.id,
        any_icon: data.options["icon"],
        hoist_role: data.options["role"]
      }.compact

      guild = Guild.new(data)

      if guild.blank? && options[:hoist_role].nil?
        data.edit_response(content: RESPONSE[1])
        return
      end

      if guild.blank? && options[:any_icon].nil?
        data.edit_response(content: RESPONSE[2])
        return
      end

      guild.edit(**options)

      if guild.blank?
        data.edit_response(content: RESPONSE[8])
      else
        data.edit_response(content: RESPONSE[7])
      end
    end
  end
end
