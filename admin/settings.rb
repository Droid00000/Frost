# frozen_string_literal: true

require_relative '../data/constants'
require_relative '../data/functions'
require_relative '../data/schema'
require 'discordrb'

def server_settings(data)
  data.edit_response do |builder|
    builder.add_embed do |embed|
      embed.title = '**Server Settings**'
      embed.colour = UI[5]
      embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: UI[21])
      embed.add_field(name: '``/Booster Perks``', value: "#{settings(:booster)}")
      embed.add_field(name: '``/Pin Archiver``', value: "#{settings(:archiver)}")
      embed.add_field(name: '``/Event Roles``', value: "#{settings(:events)}")
    end
  end
end
