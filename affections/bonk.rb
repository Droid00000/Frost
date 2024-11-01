# frozen_string_literal: true

require 'data/constants'
require 'data/functions'

module BonkAffection
  extend Discordrb::EventContainer

  application_command(:bonk) do |event|
    event.defer(ephemeral: false)
    event.edit_response(content: "<@#{event.options['target']}>") do |builder|
      builder.add_embed do |embed|
        embed.colour = UI[3]
        embed.description = "**#{event.user.display_name}** bonks <@#{event.options['target']}>"
        embed.image = Discordrb::Webhooks::EmbedImage.new(url: gif(:BONK))
        embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: 'BONKS')
      end
    end
  end
end
