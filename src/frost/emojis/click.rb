# frozen_string_literal: true

def select_click(data)
  unless data.bot.profile.on(data.server).permission?(:manage_emojis)
    data.update_message(content: RESPONSE[48])
    return
  end

  parsed_emoji = data.bot.parse_mentions(data.values.first).first

  if data.server.emoji_limit?(parsed_emoji)
    data.update_message(content: RESPONSE[45], ephemeral: true)
    return
  end

  emoji = data.server.add_emoji(parsed_emoji.name, parsed_emoji.file)

  data.send_message(content: "#{RESPONSE[43]} #{emoji.use}", ephemeral: true)
end
