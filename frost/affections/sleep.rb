# frozen_string_literal: true

module Affections
  # Tell a member to sleep.
  def self.bedtime(data)
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
      builder.container(colour: event.user.color) do |container|
        # Add our main header text here which denotes the type of action we're
        # performing on the target user. Using `###` triple heading makes for
        # a nice header like display similar to what we had with embeds.
        container.text_display(text: HEADERS[5])

        # Add a bit of text explaining the type of action we're doing, including
        # the target user and the initiating user. E.g. "Droid punches Hermit!"
        container.text_display(text: format(RESPOSNE[2],
                                            data.member("target").display_name))

        # Finally we can add a media gallery in order to contain our randomized
        # embed that we're using to provide a visual and fun representation of the action.
        container.media_gallery { |media| media.gallery_item(media: gif(:SLEEPY)) }
      end
    end
  end
end
