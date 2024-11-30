# frozen_string_literal: true

def throw_snowball(data)
  unless snowball_records(user: data.user.id, type: :check_snowball)
    data.respond(content: RESPONSE[14])
    return
  end

  snowball_records(user: data.user.id, type: :remove_snowball, balance: 1)

  if rand(1..10) >= 5
    data.respond(content: data.member('member').mention) do |builder|
      builder.add_embed do |embed|
        embed.color = UI[6]
        embed.title = '**HIT**'
        embed.image = Discordrb::Webhooks::EmbedImage.new(url: gif(:THROW))
        embed.description = format(EMBED[33], data.user.display_name, data.options['member'])
      end
    end

  else
    data.respond do |builder|
      builder.add_embed do |embed|
        embed.color = UI[6]
        embed.title = '**MISS**'
        embed.description = EMBED[32] % data.user.display_name
        embed.image = Discordrb::Webhooks::EmbedImage.new(url: gif(:MISS))
      end
    end
  end
end
