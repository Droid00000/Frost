# frozen_string_literal: true

def help_booster(data)
  data.send_message(ephemeral: true) do |builder|
    builder.add_embed do |embed|
      embed.colour = UI[7]
      embed.title = EMBED[48]
      embed.description = EMBED[120]
      embed.add_field(name: EMBED[117], value: EMBED[121])
      embed.add_field(name: EMBED[118], value: EMBED[123])
      embed.add_field(name: EMBED[119], value: EMBED[122])
      embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: UI[1])
    end
  end
end
