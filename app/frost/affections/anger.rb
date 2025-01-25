# frozen_string_literal: true

module Affections
  # Get med at a member.
  def self.anger(data)
    data.respond(content: data.member("target").mention) do |builder|
      builder.add_embed do |embed|
        embed.title = EMBED[36]
        embed.colour = data.user.highest_role.color
        embed.image = Discordrb::Webhooks::EmbedImage.new(url: gif(:ANGRY))
        embed.description = format(EMBED[29], data.member("target").display_name)
      end
    end
  end
end
