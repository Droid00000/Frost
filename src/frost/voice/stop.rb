# frozen_string_literal: true

require 'discordrb'
require 'constants'

def voice_stop(data)
  data.edit_response(content: RESPONSE[42])
end
