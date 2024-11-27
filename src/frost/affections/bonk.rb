# frozen_string_literal: true

def bonk_member(data)
  data.edit_response(content: "<@#{data.options['target']}>") do |builder|
    builder.add_embed do |embed|
      embed.colour = UI[3]
      embed.title = '**BONKS**'
      embed.image = Discordrb::Webhooks::EmbedImage.new(url: gif(:BONK))
      embed.description = format(EMBED[28], data.user.display_name, data.options['target'])
    end
  end
end
