# frozen_string_literal: true

require 'discordrb'
require 'data/constants'

def voice_stop(data)
  if data.bot.voice(data.server).nil?
    data.edit_response(content: REPSONSE[40])
    return
  end

  data.bot.voice(data.server).stop_playing
  data.edit_response(content: RESPONSE[42])
end
