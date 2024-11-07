# frozen_string_literal: true

require 'discordrb'
require 'data/constants'

def voice_help_embed(data)
  data.edit_response do |builder|
    builder.add_embed do |embed|
      embed.title = '**Voice Commands**'
      embed.colour = UI[5]
      embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: UI[1])
      embed.add_field(name: '``/music disconnect``', value: EMBED[23])
      embed.add_field(name: '``/music resume``', value: EMBED[30])
      embed.add_field(name: '``/music pause``', value: EMBED[29])
      embed.add_field(name: '``/music stop``', value: EMBED[24])
      embed.add_field(name: '``/music help``', value: EMBED[25])
      embed.add_field(name: '``/music play``', value: EMBED[26])
    end
  end
end
