# frozen_string_literal: true

module Admin
  # Namespace for administrators.
  module Birthdays
    # Enable birthday perks in this server.
    def self.setup(data)
      unless data.user.permission?(:administrator)
        data.edit_response(content: RESPONSE[3])
        return
      end

      options = {
        setup_by: data.user.id,
        setup_at: Time.now.to_i,
        guild_id: data.server_id,
        role_id: data.options["role"]&.to_i,
        channel_id: data.options["channel"]&.to_i
      }

      state = ::Birthdays::Storage.create_guild(**options)

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
