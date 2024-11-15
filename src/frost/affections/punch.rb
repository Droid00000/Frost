# frozen_string_literal: true

require 'constants'
require 'functions'

module PunchAffection
  extend Discordrb::EventContainer

  application_command(:punch) do |event|
    event.defer(ephemeral: false)
    return unless CONFIG['Discord']['COMMANDS'].include?(event.user.id)

    event.edit_response(content: "<@#{event.options['target']}>") do |builder|
      builder.add_embed do |embed|
        embed.colour = UI[3]
        embed.description = "**#{event.user.display_name}** punches <@#{event.options['target']}>!"
        embed.image = Discordrb::Webhooks::EmbedImage.new(url: gif(:PUNCH))
        embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: 'PUNCH')
      end
    end
  end
end
