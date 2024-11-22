# frozen_string_literal: true

module AngerAffection
  extend Discordrb::EventContainer

  application_command(:angered) do |event|
    event.defer(ephemeral: false)
    event.edit_response(content: "<@#{event.options['target']}>") do |builder|
      builder.add_embed do |embed|
        embed.colour = UI[3]
        embed.description = "Watch out <@#{event.options['target']}>! Someone seems to be angry today!"
        embed.image = Discordrb::Webhooks::EmbedImage.new(url: gif(:ANGRY))
        embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: 'ANGER')
      end
    end
  end
end
