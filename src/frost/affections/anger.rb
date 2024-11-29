# frozen_string_literal: true

def angry_member(data)
  data.edit_response(content: data.member('target').mention) do |builder|
    builder.add_embed do |embed|
      embed.colour = UI[3]
      embed.title = EMBED[36]
      embed.image = Discordrb::Webhooks::EmbedImage.new(url: gif(:ANGRY))
      embed.description = format(EMBED[29], data.options['target'])
    end
  end
end
