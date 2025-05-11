# frozen_string_literal: true

module Affections
  # Bonk a member.
  def self.bonk(data)
    # Set the ephemeral flag to false here.
    data.respond(ephemeral: false) do |builder|
      # Add our content which contains our user mention.
      builder.content = data.member("target").mention

      # Add an embed here. The plan was to migrate this specific module
      # entirely to components V2, but container look a little massive on
      # desktop currently, so that plan already managed to fall through.
      builder.add_embed do |embed|
        # Add our main header text here which denotes the type of action we're
        # performing on the target user. Using `###` triple heading makes for
        # a nice header like display.
        embed.title = HEADERS[2]

        # Set an accent color for the embed we're currently operating on.
        # I was going to originally swap this embed over to CV2, but, on
        # desktop, V2 components look super large with images for some reason.
        embed.color = data.user.respond_to?(:color) ? user.color : 0

        # Add a bit of text explaining the type of action we're doing, including
        # the target user and the initiating user. E.g. "Droid punches Hermit!"
        embed.description = format(RESPOSNE[5], data.member("target").display_name,
                                   data.member("target").display_name)

        # Finally we can add a media gallery in order to contain our randomized
        # embed that we're using to provide a visual and fun representation of the action.
        embed.image = Discordrb::Webhooks::EmbedImage.new(url: BONK.sample)
      end
    end
  end
end
