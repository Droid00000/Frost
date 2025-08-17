# frozen_string_literal: true

module Affections
  # Poke a member.
  def self.poke(data)
    # Ephemeral has to be false here, otherwise mentions don't work.
    data.respond(ephemeral: false) do |builder|
      # Add our content which contains our user mention.
      builder.content = data.member("target").mention

      # Add an embed here. The plan was to migrate this specific module
      # entirely to components V2, but containers look a little massive on
      # desktop currently, so that plan already managed to fall through.
      builder.add_embed do |embed|
        # Trick, making the title bold makes it pop out just a bit more.
        embed.title = HEADERS[3]

        # We have to check if the user has a instance method called `#color`
        # since color isn't provided on the base user object, e.g. user apps.
        embed.color = data.user.respond_to?(:color) ? data.user.color : 0

        # This is where our main body text is going to go. E.g. Hermit punches Droid!
        embed.description = format(RESPONSE[4], data.user.display_name,
                                   data.member("target").display_name)

        # This is going to be the random GIF of the action we're performing.
        embed.image = Discordrb::Webhooks::EmbedImage.new(url: POKE.sample)
      end
    end
  end
end
