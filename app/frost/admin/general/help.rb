# frozen_string_literal: true

def general_help(data)
  data.edit_response do |builder|
    builder.add_embed do |embed|
      embed.colour = UI[5]
      embed.title = EMBED[46]
      embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: UI[1])
      embed.add_field(name: '``/hug``', value: EMBED[1])
      embed.add_field(name: '``/nom``', value: EMBED[2])
      embed.add_field(name: '``/poke``', value: EMBED[3])
      embed.add_field(name: '``/help``', value: EMBED[4])
      embed.add_field(name: '``/about``', value: EMBED[5])
      embed.add_field(name: '``/sleep``', value: EMBED[6])
      embed.add_field(name: '``/angered``', value: EMBED[7])
      embed.add_field(name: '``/shutdown``', value: EMBED[8])
      embed.add_field(name: '``/booster role help``', value: EMBED[9])
      embed.add_field(name: '``/event roles setup``', value: EMBED[10])
      embed.add_field(name: '``/pin archiver setup``', value: EMBED[11])
      embed.add_field(name: '``/booster admin help``', value: EMBED[12])
    end
  end
end
