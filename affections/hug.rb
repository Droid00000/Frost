# frozen_string_literal: true

require_relative '../data/constants'
require_relative '../data/functions'

module HugAffection
  extend Discordrb::EventContainer

  application_command(:hug) do |event|
    event.defer(ephemeral: false)
    event.edit_response(content: "<@#{event.options['target']}>") do |builder|
      builder.add_embed do |embed|
        embed.colour = UI[3]
        embed.description = "#{event.user.display_name} hugs <@#{event.options['target']}>"
        embed.image = Discordrb::Webhooks::EmbedImage.new(url: gif(:HUGS))
        embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: 'HUGS')
      end
    end
  end
end
