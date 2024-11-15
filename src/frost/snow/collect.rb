# frozen_string_literal: true

require 'schema'
require 'discordrb'
require 'constants'
require 'functions'

def collect_snowball(data)
  snowball_records(user: data.user.id, type: :add_user) unless snowball_records(user: data.user.id, type: :check_user)

  snowball_records(user: data.user.id, type: :add_snowball, balance: 1)

  data.edit_response do |builder|
    builder.add_embed do |embed|
      embed.color = UI[6]
      embed.description = "**#{data.user.display_name}** collected one snowball!"
      embed.image = Discordrb::Webhooks::EmbedImage.new(url: gif(:COLLECT))
      embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: 'GATHER')
    end
  end
end
