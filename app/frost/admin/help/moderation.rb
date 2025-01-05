# frozen_string_literal: true

def help_mod(data)
  data.send_message(ephemeral: true) do |builder|
    builder.add_embed do |embed|
      embed.colour = UI[7]
      embed.title = EMBED[72]
      embed.timestamp = Time.now
      embed.description = EMBED[102]
      embed.add_field(name: EMBED[107], value: EMBED[113])
      embed.add_field(name: EMBED[115], value: EMBED[116])
      embed.add_field(name: EMBED[103], value: EMBED[109])
      embed.add_field(name: EMBED[108], value: EMBED[114])
      embed.add_field(name: EMBED[104], value: EMBED[110])
      embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: UI[1])
    end
  end
end
