# frozen_string_literal: true

def select_click(data)
  unless data.bot.profile.on(data.server).permission?(:manage_emojis)
    data.update_message(content: RESPONSE[48])
    return
  end

  parsed_emoji = data.bot.parse_mentions(data.values[0])

  if data.server.emoji_limit?(parsed_emoji[0])
    data.update_message(content: RESPONSE[45], ephemeral: true)
    return
  end

  emoji = data.server.add_emoji(parsed_emoji[0].name, parsed_emoji[0].file)

  data.send_message(content: "#{RESPONSE[43]} #{emoji.use}", ephemeral: true)
end
