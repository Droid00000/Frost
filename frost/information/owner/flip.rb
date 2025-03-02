# frozen_string_literal: true

def coin_flip(data)
  if rand(1..100) >= 50
    data.edit_response(content: RESPONSE[85])
  else
    data.edit_response(content: RESPONSE[86])
  end
end
