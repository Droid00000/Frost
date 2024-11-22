# frozen_string_literal: true

def sticker_info(data)
  unless data.target.stickers?
    data.edit_response(content: RESPONSE[72])
    return
  end

  data.edit_response do |builder|
    builder.add_embed do |embed|
      embed.colour = UI[8]
      embed.title = EMBED[31]
      embed.url = data.target.sticker[0].url
      embed.add_field(name: EMBED[32], value: data.target.sticker[0].name || EMBED[35])
      embed.add_field(name: EMBED[33], value: data.target.sticker[0].description || EMBED[35]) if data.target.sticker[0].description
      embed.add_field(name: EMBED[34], value: data.target.sticker[0].tags || EMBED[35]) if data.target.sticker[0].tags
      embed.image = Discordrb::Webhooks::EmbedImage.new(url: data.target.sticker[0].url)
      embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: "Sticker ID: #{data.target.sticker[0].id}")
    end
  end
end
