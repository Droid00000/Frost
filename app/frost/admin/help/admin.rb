# frozen_string_literal: true

def help_admin(data)
  data.send_message(ephemeral: true) do |builder|
    builder.add_embed do |embed|
      embed.colour = UI[7]
      embed.title = EMBED[47]
      embed.description = EMBED[134]
      embed.timestamp = Time.at(Time.now)
      embed.add_field(name: EMBED[127], value: EMBED[135])
      embed.add_field(name: EMBED[128], value: EMBED[136])
      embed.add_field(name: EMBED[129], value: EMBED[137])
      embed.add_field(name: EMBED[130], value: EMBED[138])
      embed.add_field(name: EMBED[131], value: EMBED[139])
      embed.add_field(name: EMBED[132], value: EMBED[140])
      embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: UI[1])
    end
  end
end
