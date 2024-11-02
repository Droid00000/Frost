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

        buttons.button(style: :primary, emoji: emoji.id, custom_id: position)
      end
    end

    builder.add_embed do |embed|
      embed.title = EMBED[28]
      embed.color = UI[5]
    end
  end
end
