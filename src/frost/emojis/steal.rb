# frozen_string_literal: true

require 'discordrb'
require 'constants'

def steal_emojis(data)
  unless data.target.emoji?
    data.edit_response(content: RESPONSE[55])
    return
  end

  unless data.bot.profile.on(data.server).permission?(:manage_emojis)
    data.edit_response(content: RESPONSE[61])
    return
  end

  emojis = []

  data.target.emoji.each do |emoji|
    break if data.server.emoji_limit?(emoji)

    emoji = data.server.add_emoji(emoji.name, emoji.file)
    emojis << emoji
  end

  data.edit_response(content: "#{RESPONSE[57]} **#{emojis.count}**")
end