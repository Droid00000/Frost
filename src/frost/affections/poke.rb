# frozen_string_literal: true

module PokeAffection
  extend Discordrb::EventContainer

  application_command(:poke) do |event|
    event.defer(ephemeral: false)
    event.edit_response(content: "<@#{event.options['target']}>") do |builder|
      builder.add_embed do |embed|
        embed.colour = UI[3]
        embed.title = '**POKES**'
        embed.image = Discordrb::Webhooks::EmbedImage.new(url: gif(:POKES))
        embed.description = EMBED[38] % [event.user.display_name, event.options['target']]
      end
    end
  end
end
