# frozen_string_literal: true

def collect_snowball(data)
  snowball_records(user: data.user.id, type: :add_user) unless snowball_records(user: data.user.id, type: :check_user)

  snowball_records(user: data.user.id, type: :add_snowball, balance: 1)

  data.edit_response do |builder|
    builder.add_embed do |embed|
      embed.color = UI[6]
      embed.title = '**GATHER**'
      embed.description = EMBED[43] % data.user.display_name
      embed.image = Discordrb::Webhooks::EmbedImage.new(url: gif(:COLLECT))
    end
  end
end
