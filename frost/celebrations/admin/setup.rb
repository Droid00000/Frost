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
      guild = ::Birthdays::Guild.new(data, lazy: true)

      options = {
        user_id: data.user.id,
        role_id: data.options["role"],
        channel_id: data.options["channel"]
      }

      state = guild.edit(**options.compact)

      if state == 400 && options[:role_id].nil?
        data.edit_response(content: RESPONSE[2])
        return
      end

      if state == 200
        data.edit_response(content: RESPONSE[5])
      else
        data.edit_response(content: RESPONSE[6])
      end
    end
  end
end
