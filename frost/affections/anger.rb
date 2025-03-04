# frozen_string_literal: true

module Affections
  # Get mad at a member.
  def self.anger(data)
    # Manually enable the `IS_COMPONENTS_V2 (1 << 15)`
    # flags so we can use the new interaction components.
    data.respond(new_components: true) do |_, builder|
      # Add a text display container to mention our user
      # outside of the container we're building. This is
      # done in order to emulate the content field, since
      # that gets disabled with these new fancy ass components.
      builder.text_display(text: data.member("target").mention)

      # Create a container in order to simulate the old look and
      # feel of an embed. I'm hoping there's some improvements to
      # how this looks and feels on mobile, since it currently looks
      # like hot garbage. Looks great on the mobile clients though!
      builder.container do |container|
        # Set the accent color of the container to the color of the
        # role, the user is basing their color off of in the client.
        # I believe DRB sets this to null if there isn't a color, since
        # a container isn't required to have an accent color, unlike embeds.
        container.color = event.user.color

        # Add our main header text here which denotes the type of action we're
        # performing on the target user. Using `###` triple heading makes for
        # a nice header like display similar to what we had with embeds.
        container.text_display(text: HEADERS[1])

        # Add a bit of text explaining the type of action we're doing, including
        # the target user and the initiating user. E.g. "Droid punches Hermit!"
        container.text_display(text: format(RESPOSNE[6],
                                            data.member("target").display_name))

        # Finally we can add a media gallery in order to contain our randomized
        # embed that we're using to provide a visual and fun representation of the action.
        container.media_gallery { |media| media.gallery_item(media: gif(:ANGRY)) }
      end
    end
  end
end
