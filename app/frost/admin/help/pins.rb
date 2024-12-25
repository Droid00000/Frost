# frozen_string_literal: true

def help_pins(data)
  data.send_message(ephemeral: true) do |builder|
    builder.add_embed do |embed|
      embed.colour = UI[7]
      embed.title = EMBED[73]
      embed.description = EMBED[74]
      embed.timestamp = Time.at(Time.now)
      embed.add_field(name: EMBED[78], value: EMBED[75])
      embed.add_field(name: EMBED[79], value: EMBED[76])
      embed.add_field(name: EMBED[80], value: EMBED[77])
      embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: UI[1])
    end
  end
end
