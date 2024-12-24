# frozen_string_literal: true

def help_snow(data)
  data.send_message(ephemeral: true) do |builder|
    builder.add_embed do |embed|
      embed.colour = UI[7]
      embed.title = EMBED[94]
      embed.description = EMBED[95]
      embed.add_field(name: EMBED[96], value: EMBED[99])
      embed.add_field(name: EMBED[97], value: EMBED[100])
      embed.add_field(name: EMBED[98], value: EMBED[101])
      embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: UI[1])
    end
  end
end
