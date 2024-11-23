# frozen_string_literal: true

module PunchAffection
  extend Discordrb::EventContainer

  application_command(:punch) do |event|
    event.defer(ephemeral: false)
    return unless CONFIG['Discord']['COMMANDS'].include?(event.user.id)

    event.edit_response(content: "<@#{event.options['target']}>") do |builder|
      builder.add_embed do |embed|
        embed.colour = UI[3]
        embed.title = '**PUNCH**'
        embed.image = Discordrb::Webhooks::EmbedImage.new(url: gif(:PUNCH))
        embed.description = EMBED[37] % [event.user.display_name, event.options['target']]
      end
    end
  end
end
