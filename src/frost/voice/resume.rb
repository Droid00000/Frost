# frozen_string_literal: true

require 'discordrb'
require 'constants'

def voice_resume(data)
  data.edit_response(content: RESPONSE[66])
end
