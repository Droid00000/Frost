# frozen_string_literal: true

require 'discordrb'
require 'data/constants'

def create_emoji(data)
  unless data.target.emoji?
    data.edit_response(content: RESPONSE[55])
    return
  end

  data.edit_response do |builder, components|
    components.row do |buttons|
      data.target.emoji.each_with_index do |emoji, position|
        break if position > 4

        buttons.button(style: UI[9], emoji: emoji.id, custom_id: position)
      end
    end

    builder.add_embed do |embed|
      embed.title = EMBED[28]
      embed.color = UI[5]
    end
  end
end

def steal_emojis(data)
  unless data.target.emoji?
    data.edit_response(content: RESPONSE[55])
    return
  end

  unless data.bot.profile.on(data.server).permission?(:manage_emojis)
    data.edit_response(content: RESPONSE[61])
    return
  end

  if data.server.emoji_limit?
    data.edit_response(content: RESPONSE[58])
    return
  end

  data.target.emoji.each do |emoji|
    break if data.server.emoji_limit?(emoji)
    
    data.server.add_emoji(emoji.name, emoji.file)
  end

  data.edit_response(content: "#{RESPONSE[57]} **#{data.target.emoji.count}**")
end
