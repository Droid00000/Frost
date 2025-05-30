# frozen_string_literal: true

module AdminCommands
  # Namespace for birthday admins.
  module Birthdays
    # Enable birthday perks in this server.
    def self.setup(data)
      unless data.user.permission?(:administrator)
        data.edit_response(content: RESPONSE[2])
        return
      end

      # Initialize the invoking guild.
      guild = ::Birthdays::Guild.new(data)

      options = {
        setup_by: data.user.id,
        setup_at: Time.now.to_i,
        guild_id: data.server.id,
        role_id: data.options["role"],
        channel_id: data.options["channel"]
      }

      if guild.blank? && options[:role_id].nil?
        data.edit_response(content: RESPONSE[1])
        return
      end

      guild.edit(**options.compact)

      if guild.blank?
        data.edit_response(content: RESPONSE[5])
      else
        data.edit_response(content: RESPONSE[4])
      end
    end
  end
end
