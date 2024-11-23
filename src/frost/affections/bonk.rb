# frozen_string_literal: true

module BonkAffection
  extend Discordrb::EventContainer

  application_command(:bonk) do |event|
    event.defer(ephemeral: false)
    event.edit_response(content: "<@#{event.options['target']}>") do |builder|
      builder.add_embed do |embed|
        embed.colour = UI[3]
        embed.title = '**BONKS**'
        embed.image = Discordrb::Webhooks::EmbedImage.new(url: gif(:BONK))
        embed.description = EMBED[41] % [event.user.display_name, event.options['target']]
      end
    end
  end
end
