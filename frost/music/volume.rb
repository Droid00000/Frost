# frozen_string_literal: true

module Music
  # Adjust the volume.
  def self.volume(data)
    unless CALLIOPE.players[data.server.id]
      data.edit_response(content: RESPONSE[82])
      return
    end

    CALLIOPE.players[data.server.id].volume = data.options["volume"]

    data.edit_response(content: RESPONSE[80])
  end
end
