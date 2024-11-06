# frozen_string_literal: true

require 'discordrb'
require 'data/schema'
require 'data/constants'
require 'data/functions'

def tag_info(data)
  unless tag_records(name: data.options['name'], type: :exists?)
    data.edit_response(content: RESPONSE[52])
    return
  end

  message = data.bot.resolve_message(tag_records(name: data.options['name'], type: :get)[0],
                                     tag_records(name: data.options['name'], type: :get)[2])

  owner = data.bot.member(tag_records(name: data.options['name'], type: :get)[3],
                          tag_records(name: data.options['name'], type: :get)[1])

  data.edit_response do |builder|
    builder.add_embed do |embed|
      embed.colour = UI[5]
      embed.description = message.content.to_s
      embed.image = Discordrb::Webhooks::EmbedImage.new(url: message.attachments[0].url.to_s) if message.attachments.any?
      embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: owner.display_name, url: message.link, icon_url: owner.avatar_url)
      embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: "#{message.id} • #{resolve_time(metadata[4].to_s)}")
      embed.add_field(name: 'Source', value: "[Jump!](#{message.link})")
    end
  end
end
