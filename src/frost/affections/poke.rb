# frozen_string_literal: true

def poke_member(data)
  data.edit_response(content: "<@#{data.options['target']}>") do |builder|
    builder.add_embed do |embed|
      embed.colour = UI[3]
      embed.title = '**POKES**'
      embed.image = Discordrb::Webhooks::EmbedImage.new(url: gif(:POKES))
      embed.description = EMBED[25] % [data.user.display_name, data.options['target']]
    end
  end
end
