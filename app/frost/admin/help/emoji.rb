# frozen_string_literal: true

def help_emoji(data)
  data.send_message(ephemeral: true) do |builder|
    builder.add_embed do |embed|
      embed.colour = UI[7]
      embed.title = EMBED[86]
      embed.description = EMBED[87]
      embed.timestamp = Time.at(Time.now)
      embed.add_field(name: EMBED[88], value: EMBED[89])
      embed.add_field(name: EMBED[91], value: EMBED[90])
      embed.add_field(name: EMBED[92], value: EMBED[93])
      embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: UI[1])
    end
  end
end
