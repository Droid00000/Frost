# frozen_string_literal: true

def voice_pause(data)
  data.edit_response(content: RESPONSE[65])
end
