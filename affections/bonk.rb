# frozen_string_literal: true

require_relative '../data/constants'
require_relative '../data/functions'

module BonkAffection
  extend Discordrb::EventContainer

  application_command(:bonk) do |event|
    event.defer(ephemeral: false)
    event.edit_response(content: "<@#{event.options['target']}>") do |builder|
      builder.add_embed do |embed|
        embed.colour = UI[3]
        embed.description = "<@#{event.user.id}> bonks <@#{event.options['target']}>!"
        embed.image = Discordrb::Webhooks::EmbedImage.new(url: gif(:BONK))
        embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: 'BONKS')
      end
    end
  end
end
