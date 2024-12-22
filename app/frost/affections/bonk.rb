# frozen_string_literal: true

def bonk_member(data)
  data.respond(content: data.member('target').mention) do |builder|
    builder.add_embed do |embed|
      embed.colour = UI[3]
      embed.title = EMBED[37]
      embed.image = Discordrb::Webhooks::EmbedImage.new(url: gif(:BONK))
      embed.description = format(EMBED[28], data.user.display_name, data.member('target').display_name)
    end
  end
end
