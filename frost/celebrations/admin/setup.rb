# frozen_string_literal: true

module AdminCommands
  # Namespace for birthday admins.
  module Birthdays
    # Enable birthday perks in this server.
    def self.setup(data)
      unless data.user.permission?(:administrator)
        data.edit_response(content: RESPONSE[3])
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
      }.compact

      if guild.blank? && options[:role_id].nil?
        data.edit_response(content: RESPONSE[2])
        return
      end

      # This is optional, so allow it to be removed.
      if options[:channel_id]&.match?(REGEX[3])
        options[:channel_id] = nil
      end

      guild.edit(**options)

      if guild.blank?
        data.edit_response(content: RESPONSE[6])
      else
        data.edit_response(content: RESPONSE[5])
      end
    end
  end
end
