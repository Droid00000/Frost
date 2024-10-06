# frozen_string_literal: true

require_relative '../data/constants'
require_relative '../data/functions'
require_relative '../data/schema'
require 'discordrb'

def throw_snowball(data)
  unless snowball_records(user: data.user.id, type: :check_snowball)
    data.edit_response(content: RESPONSE[14])
    return
  end

  if hit_or_miss?
    snowball_records(user: data.user.id, type: :remove_snowball, balance: 1)
    data.edit_response(content: "<@#{data.options['member']}>") do |builder|
      builder.add_embed do |embed|
        embed.color = UI[6]
        embed.description = "<@#{data.user.id}> threw a snowball at <@#{data.options['member']}>!"
        embed.image = Discordrb::Webhooks::EmbedImage.new(url: gif(:THROW))
        embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: 'THROW')
      end
    end

  else
    data.edit_response do |builder|
      builder.add_embed do |embed|
        embed.color = UI[6]
        embed.description = "<@#{data.user.id}> missed!"
        embed.image = Discordrb::Webhooks::EmbedImage.new(url: gif(:MISS))
        embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: 'MISS')
      end
    end
  end
end
