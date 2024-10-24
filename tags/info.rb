# frozen_string_literal: true

require_relative '../data/constants'
require_relative '../data/functions'
require_relative '../data/schema'
require 'discordrb'

def tag_info(data)
  unless tag_records(name: data.options['name'], type: :exists?)
    data.edit_response(content: RESPONSE[52])
    return
  end

  metadata = tag_records(name: data.options['name'], type: :get)
  message = data.bot.resolve_message(metadata[0], metadata[2])
  owner = data.bot.member(metadata[3], metadata[1])

  data.edit_response do |builder|
    builder.add_embed do |embed|
      if message.attachments.any?
        embed.colour = UI[5]
        embed.description = message.content.to_s
        embed.image = Discordrb::Webhooks::EmbedImage.new(url: message.attachments[0].url.to_s)
        embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: owner.display_name, url: message.link,
                                                            icon_url: owner.avatar_url)
        embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: "#{message.id} • #{time_data(metadata[4].to_s)}")
        embed.add_field(name: 'Source', value: "[Jump!](#{message.link})")
      else
        embed.colour = UI[5]
        embed.description = message.content.to_s
        embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: owner.display_name, url: message.link,
                                                            icon_url: owner.avatar_url)
        embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: "#{message.id} • #{resolve_time(metadata[4].to_s)}")
        embed.add_field(name: 'Source', value: "[Jump!](#{message.link})")
      end
    end
  end
end
