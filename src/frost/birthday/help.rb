# frozen_string_literal: true

def birthday_help(data)
  data.edit_response do |builder|
    builder.add_embed do |embed|
      embed.title = '**Booster Commands**'
      embed.colour = UI[5]
      embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: UI[1])
      embed.add_field(name: '``/set birthday``', value: EMBED[48])
      embed.add_field(name: '``/view birthday``', value: EMBED[49])
      embed.add_field(name: '``/birthday help``', value: EMBED[15])
      embed.add_field(name: '``/birthday admin help``', value: EMBED[50])
    end
  end
end
