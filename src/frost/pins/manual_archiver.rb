# frozen_string_literal: true

module ManualPinArchiver
  extend Discordrb::EventContainer

  application_command(:archive) do |event|
    event.defer(ephemeral: true)
    pins = event.channel.pins

    if pins.count == 50 && archiver_records(server: event.server.id, type: :check)
      archive_channel = event.bot.channel(archiver_records(server: event.server.id, type: :get))
      message = pins[1]

      archive_channel.send_embed do |embed|
        embed.colour = UI[2]
        embed.description = message.content&.to_s if message.content
        embed.add_field(name: 'Source', value: "[Jump!](#{message.link})")
        embed.image = Discordrb::Webhooks::EmbedImage.new(url: message.attachments.first.url) if message.attachments.any?
        embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: message.author.display_name, icon_url: message.author.avatar_url)
        embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: "#{message.id} • #{resolve_time(message.timestamp.to_s)}")
      end
      message.unpin(REASON[7])
      event.edit_response(content: "#{RESPONSE[20]} #{EMOJI[3]}")
    end
  end
end
