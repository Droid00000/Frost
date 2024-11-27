# frozen_string_literal: true

def steal_emojis(data)
  unless data.target.emoji?
    data.edit_response(content: RESPONSE[42])
    return
  end

  unless data.server.bot.permission?(:manage_emojis)
    data.edit_response(content: RESPONSE[48])
    return
  end

  emojis = []

  data.target.emoji.each do |emoji|
    break if data.server.emoji_limit?(emoji)

    emoji = data.server.add_emoji(emoji.name, emoji.file)
    emojis << emoji
  end

  data.edit_response(content: RESPONSE[44] % emojis.count)
end
