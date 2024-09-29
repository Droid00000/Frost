# frozen_string_literal: true

require_relative '../data/constants'
require_relative '../data/functions'
require_relative '../data/schema'
require 'discordrb'

def collect_snowball(data)
  unless snowball_records(user: data.user.id, type: :check_user)
    snowball_records(user: data.user.id, type: :add_user)
  end

  snowball_records(user: data.user.id, type: :add_snowball, balance: 1)

  data.edit_response do |builder|
    builder.add_embed do |embed|
      embed.color = UI[26]
      embed.description = "<@#{data.user.id}> collected one snowball!"
      embed.image = Discordrb::Webhooks::EmbedImage.new(url: gif(:COLLECT))
      embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: "GATHER")
    end
  end
end
