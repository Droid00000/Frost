# frozen_string_literal: true

require_relative '../data/constants'
require_relative '../data/functions'
require_relative '../data/schema'
require 'discordrb'

def throw_snowball(data)
  unless snowball_records(user: data.user.id, type: :check_user)
    data.edit_response(content: RESPONSE[505])
    return
  end

  unless snowball_records(user: data.user.id, type: :check_snowball)
    data.edit_response(content: RESPONSE[505])
    return
  end

  snowball_records(user: data.user.id, type: :remove_snowball)

  data.edit_response("<@#{data.options['member']}>") do |builder|
    builder.add_embed do |embed|
      embed.description = "<@#{data.user.id}> threw a snowball at <@#{data.options['member']}>!"
      embed.image = Discordrb::Webhooks::EmbedImage.new(url: gif(:THROW))
      embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: 'THROW')
    end
  end
end
