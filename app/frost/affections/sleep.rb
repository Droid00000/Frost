# frozen_string_literal: true

def sleep_member(data)
  data.respond(content: data.member('target').mention) do |builder|
    builder.add_embed do |embed|
      embed.colour = UI[3]
      embed.title = EMBED[42]
      embed.image = Discordrb::Webhooks::EmbedImage.new(url: gif(:SLEEPY))
      embed.description = format(EMBED[23], data.user.display_name, data.member('target').display_name)
    end
  end
end
