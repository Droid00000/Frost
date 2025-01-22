# frozen_string_literal: true

module Music
  # Delete the queue for this server.
  def self.remove(data)
    unless CALLIOPE.players[data.server.id]
      data.edit_response(content: RESPONSE[82])
      return
    end

    if CALLIOPE.players[data.server.id].paused?
      data.edit_response(content: RESPONSE[81])
      return
    end

    unless CALLIOPE.players[data.server.id].queue
      data.edit_response(content: RESPONSE[79])
      return
    end

    CALLIOPE.players[data.server.id].delete_queue

    data.edit_response(content: RESPONSE[84])
  end
end
