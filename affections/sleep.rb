# frozen_string_literal: true

require_relative '../data/constants'
require_relative '../data/functions'

module SleepAffection
  extend Discordrb::EventContainer

  application_command(:sleep) do |event|
    event.defer(ephemeral: false)
    event.edit_response(content: "<@#{event.options['target']}>") do |builder|
      builder.add_embed do |embed|
        embed.colour = UI[23]
        embed.description = "#{event.user.display_name} says <@#{event.options['target']} should go to bed!>"
        embed.image = Discordrb::Webhooks::EmbedImage.new(url: gif(:SLEEPY))
        embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: 'SLEEP')
      end
    end
  end
end
