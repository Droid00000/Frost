# frozen_string_literal: true

require 'discordrb'
require 'constants'

def voice_disconnect(data)
  if data.bot.voice(data.server).nil?
    data.edit_response(content: REPSONSE[40])
    return
  end

  data.bot.voice(data.server).destroy
  data.edit_response(content: "#{RESPONSE[41]} #{EMOJI[6]}")
end
