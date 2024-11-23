# frozen_string_literal: true

module HugAffection
  extend Discordrb::EventContainer

  application_command(:hug) do |event|
    event.defer(ephemeral: false)
    event.edit_response(content: "<@#{event.options['target']}>") do |builder|
      builder.add_embed do |embed|
        embed.colour = UI[3]
        embed.title = '**HUGS**'
        embed.image = Discordrb::Webhooks::EmbedImage.new(url: gif(:HUGS))
        embed.description = EMBED[39] % [event.user.display_name, event.options['target']]
      end
    end
  end
end
