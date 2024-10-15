# frozen_string_literal: true

require_relative '../data/constants'
require 'discordrb'

def voice_disconnect(data)
  if data.bot.voice.nil?
    data.edit_response(content: REPSONSE[40])
    return
  end

  data.bot.voice.destory
  data.edit_response(content: RESPONSE[41])
end
