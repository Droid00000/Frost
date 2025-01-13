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

  count = 0

  data.target.emoji.uniq.each do |emoji|
    data.server.add_emoji(emoji.name, emoji.file)
    count += 1
  rescue StandardError
    break
  end

  data.edit_response(content: RESPONSE[44] % count)
end
