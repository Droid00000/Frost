# frozen_string_literal: true

module Music
  # Pause the player.
  def self.pause(data)
    if data.user.voice_channel.nil?
      data.edit_response(content: RESPONSE[71])
      return
    end

    unless CALLIOPE.players[data.server.id]
      data.edit_response(content: RESPONSE[82])
      return
    end

    if data.server.bot.voice_channel.nil?
      data.edit_response(content: RESPONSE[75])
      return
    end

    if CALLIOPE.players[data.server.id].paused?
      data.edit_response(content: RESPONSE[74])
      return
    end

    CALLIOPE.players[data.server.id].paused = true

    data.edit_response(content: RESPONSE[76])
  end
end
