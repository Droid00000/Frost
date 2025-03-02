# frozen_string_literal: true

def help_birthday(data)
  data.send_message(ephemeral: true) do |builder|
    builder.add_embed do |embed|
      embed.colour = UI[7]
      embed.title = EMBED[240]
      embed.timestamp = Time.now
      embed.description = EMBED[241]
      embed.add_field(name: EMBED[245], value: EMBED[250])
      embed.add_field(name: EMBED[244], value: EMBED[249])
      embed.add_field(name: EMBED[243], value: EMBED[251])
      embed.add_field(name: EMBED[246], value: EMBED[248])
      embed.add_field(name: EMBED[242], value: EMBED[247])
      embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: UI[1])
    end
  end
end
