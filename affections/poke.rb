# frozen_string_literal: true

require_relative '../data/constants'
require_relative '../data/functions'

module PokeAffection
  extend Discordrb::EventContainer

  application_command(:poke) do |event|
    event.defer(ephemeral: false)
    event.edit_response(content: "<@#{event.options['target']}>") do |builder|
      builder.add_embed do |embed|
        embed.colour = UI[23]
        embed.description = "#{event.user.display_name} pokes <@#{event.options['target']}>"
        embed.image = Discordrb::Webhooks::EmbedImage.new(url: gif(:POKES))
        embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: 'POKES')
      end
    end
  end
end
