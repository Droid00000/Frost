# frozen_string_literal: true

def help_music(data)
  data.send_message(ephemeral: true) do |builder|
    builder.add_embed do |embed|
      embed.colour = UI[7]
      embed.title = EMBED[156]
      embed.timestamp = Time.now
      embed.description = EMBED[157]
      embed.add_field(name: EMBED[160], value: EMBED[170])
      embed.add_field(name: EMBED[158], value: EMBED[168])
      embed.add_field(name: EMBED[178], value: EMBED[179])
      embed.add_field(name: EMBED[159], value: EMBED[169])
      embed.add_field(name: EMBED[161], value: EMBED[171])
      embed.add_field(name: EMBED[162], value: EMBED[172])
      embed.add_field(name: EMBED[163], value: EMBED[173])
      embed.add_field(name: EMBED[164], value: EMBED[174])
      embed.add_field(name: EMBED[165], value: EMBED[175])
      embed.add_field(name: EMBED[166], value: EMBED[176])
      embed.add_field(name: EMBED[167], value: EMBED[177])
      embed.add_field(name: EMBED[181], value: EMBED[180])
      embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: UI[1])
    end
  end
end
