# frozen_string_literal: true

module SleepAffection
  extend Discordrb::EventContainer

  application_command(:sleep) do |event|
    event.defer(ephemeral: false)
    event.edit_response(content: "<@#{event.options['target']}>") do |builder|
      builder.add_embed do |embed|
        embed.colour = UI[3]
        embed.title = '**SLEEPY**'
        embed.image = Discordrb::Webhooks::EmbedImage.new(url: gif(:SLEEPY))
        embed.description = EMBED[36] % [event.user.display_name, event.options['target']]
      end
    end
  end
end
