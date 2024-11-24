# frozen_string_literal: true

def nom_member(data)
  data.edit_response(content: "<@#{data.options['target']}>") do |builder|
    builder.add_embed do |embed|
      embed.colour = UI[3]
      embed.title = '**NOMS**'
      embed.image = Discordrb::Webhooks::EmbedImage.new(url: gif(:NOMS))
      embed.description = EMBED[40] % [data.user.display_name, data.options['target']]
    end
  end
end
