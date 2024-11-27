# frozen_string_literal: true

def throw_snowball(data)
  unless snowball_records(user: data.user.id, type: :check_snowball)
    data.edit_response(content: RESPONSE[14])
    return
  end

  if rand(1..10) >= 5
    snowball_records(user: data.user.id, type: :remove_snowball, balance: 1)
    data.edit_response(content: "<@#{data.options['member']}>") do |builder|
      builder.add_embed do |embed|
        embed.color = UI[6]
        embed.title = '**HIT**'
        embed.image = Discordrb::Webhooks::EmbedImage.new(url: gif(:THROW))
        embed.description = format(EMBED[33], data.user.display_name, data.options['member'])
      end
    end

  else
    data.edit_response do |builder|
      builder.add_embed do |embed|
        embed.color = UI[6]
        embed.title = '**MISS**'
        embed.description = EMBED[32] % data.user.display_name
        embed.image = Discordrb::Webhooks::EmbedImage.new(url: gif(:MISS))
      end
    end
  end
end
