# frozen_string_literal: true

def throw_snowball(data)
  unless Frost::Snow.snowball?(data)
    data.respond(content: RESPONSE[14], ephemeral: true)
    return
  end

  Frost::Snow.balance(data)
  
  if rand(1..10) >= 5
    data.respond(content: data.member('member').mention) do |builder|
      builder.add_embed do |embed|
        embed.color = UI[6]
        embed.title = EMBED[44]
        embed.image = Discordrb::Webhooks::EmbedImage.new(url: gif(:THROW))
        embed.description = format(EMBED[33], data.user.display_name, data.options['member'])
      end
    end

  else
    data.respond do |builder|
      builder.add_embed do |embed|
        embed.color = UI[6]
        embed.title = EMBED[45]
        embed.description = format(EMBED[32], data.user.display_name)
        embed.image = Discordrb::Webhooks::EmbedImage.new(url: gif(:MISS))
      end
    end
  end
end
