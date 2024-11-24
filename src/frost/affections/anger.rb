# frozen_string_literal: true

def angry_member(data)
  data.edit_response(content: "<@#{data.options['target']}>") do |builder|
    builder.add_embed do |embed|
      embed.colour = UI[3]
      embed.title = '**ANGER**'
      embed.image = Discordrb::Webhooks::EmbedImage.new(url: gif(:ANGRY))
      embed.description = EMBED[42] % [data.options['target']]
    end
  end
end
