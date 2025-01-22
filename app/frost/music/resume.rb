# frozen_string_literal: true

module Music
  # Resume playback.
  def self.resume(data)
    unless CALLIOPE.players[data.server.id]
      data.edit_response(content: RESPONSE[82])
      return
    end

    unless CALLIOPE.players[data.server.id].paused?
      data.edit_response(content: RESPONSE[77])
      return
    end

    CALLIOPE.players[data.server.id].paused = false

    data.edit_response(content: RESPONSE[78])
  end
end
