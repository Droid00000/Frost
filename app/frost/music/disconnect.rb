# frozen_string_literal: true

module Music
  # End the current session.
  def self.disconnect(data)
    unless CALLIOPE.players[data.server.id]
      data.edit_response(content: RESPONSE[82])
      return
    end

    gateway_voice_disconnect(data)

    CALLIOPE.delete_player(data.server.id)

    data.edit_response(content: RESPONSE[87])
  end
end
