# frozen_string_literal: true

def voice_resume(data)
  data.edit_response(content: RESPONSE[66])
end
