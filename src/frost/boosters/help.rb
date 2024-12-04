# frozen_string_literal: true

def help_embed(data)
  data.edit_response do |builder|
    builder.add_embed do |embed|
      embed.colour = UI[5]
      embed.title = EMBED[48]
      embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: UI[1])
      embed.add_field(name: '``/booster role claim``', value: EMBED[20])
      embed.add_field(name: '``/booster role edit``', value: EMBED[21])
      embed.add_field(name: '``/booster role delete``', value: EMBED[22])
      embed.add_field(name: '``/booster role help``', value: EMBED[15])
    end
  end
end
