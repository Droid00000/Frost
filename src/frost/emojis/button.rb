# frozen_string_literal: true

require 'discordrb'
require 'data/constants'

def button_click(data, button)
  unless data.bot.profile.on(data.server).permission?(:manage_emojis)
    data.update_message(content: RESPONSE[61])
    return
  end

  if data.server.emoji_limit?(data.get_component(button).emoji)
    data.update_message(content: RESPONSE[58], ephemeral: true)
    return
  end

  data.update_message do |builder, components|
    components.row do |buttons|
      data.message.to_message.buttons.each do |old_button|
        buttons.button(style: old_button.custom_id == button ? 4 : old_button.style,
                       emoji: old_button.emoji.id, custom_id: old_button.custom_id)
      end
    end

    builder.add_embed do |embed|
      embed.title = EMBED[28]
      embed.color = UI[5]
    end
  end

  emoji = data.server.add_emoji(data.get_component(button).emoji.name,
                                data.get_component(button).emoji.file)

  data.send_message(content: "#{RESPONSE[56]} #{emoji.mention}", ephemeral: true)
end
