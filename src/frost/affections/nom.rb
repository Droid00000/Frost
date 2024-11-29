# frozen_string_literal: true

def nom_member(data)
  data.edit_response(content: data.member('target').mention) do |builder|
    builder.add_embed do |embed|
      embed.colour = UI[3]
      embed.title = EMBED[39]
      embed.image = Discordrb::Webhooks::EmbedImage.new(url: gif(:NOMS))
      embed.description = format(EMBED[27], data.user.display_name, data.options['target'])
    end
  end
end
