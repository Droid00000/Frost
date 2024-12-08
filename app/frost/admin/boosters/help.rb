# frozen_string_literal: true

def help_booster(data)
  data.edit_response do |builder|
    builder.add_embed do |embed|
      embed.colour = UI[5]
      embed.title = EMBED[47]
      embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: UI[1])
      embed.add_field(name: '``/booster admin add``', value: EMBED[13])
      embed.add_field(name: '``/booster admin ban``', value: EMBED[14])
      embed.add_field(name: '``/booster admin help``', value: EMBED[15])
      embed.add_field(name: '``/booster admin unban``', value: EMBED[16])
      embed.add_field(name: '``/booster admin setup``', value: EMBED[17])
      embed.add_field(name: '``/booster admin disable``', value: EMBED[18])
      embed.add_field(name: '``/booster admin delete``', value: EMBED[19])
    end
  end
end
