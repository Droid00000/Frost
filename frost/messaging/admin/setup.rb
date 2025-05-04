# frozen_string_literal: true

module Pins
  # Setup the pin archiver.
  def self.setup(data)
    options = {
      setup_by: data.user.id,
      setup_at: Time.now.to_i,
      guild_id: data.server.id,
      channel_id: data.options["channel"]
    }

    Guild.new(data, lazy: true).edit(**options)

    data.edit_response(content: format(RESPONSE[3], data.options["channel"]))
  end
end
