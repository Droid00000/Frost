# frozen_string_literal: true

require 'discordrb'
require 'data/constants'

def button_click(data, button)
  components.row do |buttons|
    data.message.to_message.buttons.each do |old_button|
      buttons.button(style: old_button.custom_id == buton ? :danger : :primary,
      emoji: old_button.emoji.id, custom_id: old_button.custom_id)
    end
  end

  data.update_message do |builder, components|
    builder.add_embed do |embed|
      embed.title = EMBED[28]
      embed.color = UI['5']
    end
  end

  button_emoji = [data.get_component(button).emoji.name,
                  data.get_component(button).emoji.file]

  emoji = data.server.add_emoji(button_emoji[0], button_emoji[1])
  data.send_message(content: "#{RESPONSE[56]} #{emoji.mention}", ephemeral: true)
end
