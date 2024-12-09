# frozen_string_literal: true

def collect_snowball(data)
  Frost::Snow.user(data) unless Frost::Snow.user?(data)

  Frost::Snow.balance(data, add: true)

  data.edit_response do |builder|
    builder.add_embed do |embed|
      embed.color = UI[6]
      embed.title = EMBED[43]
      embed.description = format(EMBED[30], data.user.display_name)
      embed.image = Discordrb::Webhooks::EmbedImage.new(url: gif(:COLLECT))
    end
  end
end
