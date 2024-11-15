# frozen_string_literal: true

require 'discordrb'
require 'constants'

def voice_pause(data)
  if data.bot.voice(data.server).nil?
    data.edit_response(content: REPSONSE[40])
    return
  end

  data.bot.voice(data.server).pause
  data.edit_response(content: RESPONSE[65])
end
