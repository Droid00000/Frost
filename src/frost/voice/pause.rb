# frozen_string_literal: true

require 'calliope'
require 'discordrb'
require 'constants'

def voice_pause(data)
  data.edit_response(content: RESPONSE[65])
end
