# frozen_string_literal: true

require_relative '../data/constants'
require 'discordrb'

def general_help_embed(data)
  data.edit_response do |builder|
    builder.add_embed do |embed|
      embed.title = '**General Commands**'
      embed.colour = UI[5]
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
      embed.add_field(name: '``/boosting admin help``', value: EMBED[12])
    end
  end
end

def admin_booster_help_embed(data)
  data.edit_response do |builder|
    builder.add_embed do |embed|
      embed.title = '**Booster Admin Commands**'
      embed.colour = UI[5]
      embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: UI[1])
      embed.add_field(name: '``/boost admin add``', value: EMBED[13])
      embed.add_field(name: '``/boost admin ban``', value: EMBED[14])
      embed.add_field(name: '``/boost admin help``', value: EMBED[15])
      embed.add_field(name: '``/boost admin unban``', value: EMBED[16])
      embed.add_field(name: '``/boost admin setup``', value: EMBED[17])
      embed.add_field(name: '``/boost admin disable``', value: EMBED[18])
      embed.add_field(name: '``//boost admin delete``', value: EMBED[19])
    end
  end
end