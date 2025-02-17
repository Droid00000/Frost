# frozen_string_literal: true

module Music
  # Move the bot to a different channel.
  def self.move(data)
    unless data.server.bot.permission?(:connect, data.channels("channel"))
      data.edit_response(content: RESPONSE[99])
      return
    end

    gateway_voice_move(data)

    data.edit_response(content: RESPONSE[100])
  end
end
