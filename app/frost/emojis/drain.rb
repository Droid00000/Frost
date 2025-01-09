# frozen_string_literal: true

def drain_emojis(data)
  unless data.user.id == CONFIG["Discord"]["OWNER"]
    data.edit_response(content: RESPONSE[18])
    return
  end

  while (emoji = Frost::Emojis.drain.shift)
    Frost::Emojis.add(emoji[:emoji], emoji[:guild])
  end

  data.edit_response(content: RESPONSE[97])
end
