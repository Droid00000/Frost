# frozen_string_literal: true

def add_sticker(data)
  unless data.target.stickers?
    data.edit_response(content: RESPONSE[72])
    return
  end

  unless data.target.sticker.premium?
    data.edit_response(content: RESPONSE[73])
    return
  end

  unless data.server.sticker_limit?
    data.edit_response(content: RESPONSE[74])
    return
  end

  sticker = data.server.add_sticker(data.target.sticker[0].name,
                                    data.target.sticker[0].file,
                                    data.target.sticker[0].description,
                                    data.target.sticker[0].tags, REASON[8])

  data.edit_response do |builder|
    builder.add_embed do |embed|
      embed.colour = UI[8]
      embed.title = EMBED[31]
      embed.url = sticker.url
      embed.add_field(name: EMBED[32], value: sticker.name || EMBED[35])
      embed.add_field(name: EMBED[33], value: sticker.description || EMBED[35])
      embed.add_field(name: EMBED[34], value: sticker.tags || EMBED[35])
      embed.image = Discordrb::Webhooks::EmbedImage.new(url: sticker.url)
      embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: "Sticker ID: #{sticker.id}")
    end
  end
end
