# frozen_string_literal: true

def voice_stop(data)
  data.edit_response(content: RESPONSE[42])
end
