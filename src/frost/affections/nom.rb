# frozen_string_literal: true

module NomAffection
  extend Discordrb::EventContainer

  application_command(:nom) do |event|
    event.defer(ephemeral: false)
    event.edit_response(content: "<@#{event.options['target']}>") do |builder|
      builder.add_embed do |embed|
        embed.colour = UI[3]
        embed.title = '**NOMS**'
        embed.image = Discordrb::Webhooks::EmbedImage.new(url: gif(:NOMS))
        embed.description = EMBED[40] % [event.user.display_name, event.options['target']]
      end
    end
  end
end
