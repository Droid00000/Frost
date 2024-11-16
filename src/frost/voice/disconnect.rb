# frozen_string_literal: true

require 'calliope'
require 'discordrb'
require 'constants'

def voice_disconnect(data)
  data.edit_response(content: "#{RESPONSE[41]} #{EMOJI[6]}")
end
