# frozen_string_literal: true

require_relative '../data/constants'
require 'discordrb'

def voice_help_embed(data)
    data.edit_response do |builder|
      builder.add_embed do |embed|
        embed.title = '**Voice Commands**'
        embed.colour = UI[5]
        embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: UI[1])
        embed.add_field(name: '``/voice disconnect``', value: EMBED[23])
        embed.add_field(name: '``/voice stop``', value: EMBED[24])
        embed.add_field(name: '``/voice help``', value: EMBED[25])
        embed.add_field(name: '``/voice play``', value: EMBED[26])
      end
    end
  end
