# frozen_string_literal: true

require 'data/constants'
require 'data/functions'

module NomAffection
  extend Discordrb::EventContainer

  application_command(:nom) do |event|
    event.defer(ephemeral: false)
    event.edit_response(content: "<@#{event.options['target']}>") do |builder|
      builder.add_embed do |embed|
        embed.colour = UI[3]
        embed.description = "**#{event.user.display_name}** noms <@#{event.options['target']}>"
        embed.image = Discordrb::Webhooks::EmbedImage.new(url: gif(:NOMS))
        embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: 'NOMS')
      end
    end
  end
end
