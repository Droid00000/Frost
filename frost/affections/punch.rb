# frozen_string_literal: true

module Affections
  # Punch a member.
  def self.punch(data)
    # Since this command was a request by one of our contributors,
    # we have to validate the permissions of the user attempting
    # to use this command. We return an error message if the user
    # isn't a contributor, and thus cannot use this app command.
    unless CONFIG[:Discord][:CONTRIBUTORS].include?(data.user.id)
      data.respond(content: PERMISSION[1], ephemeral: true)
      return
    end

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
      builder.container(color: to_color(data.user)) do |container|
        # Add our main header text here which denotes the type of action we're
        # performing on the target user. Using `###` triple heading makes for
        # a nice header like display similar to what we had with embeds.
        container.text_display(text: HEADERS[4])

        # Add a bit of text explaining the type of action we're doing, including
        # the target user and the initiating user. E.g. "Droid punches Hermit!"
        container.text_display(text: format(RESPONSE[3], data.user.display_name,
                                            data.member("target").display_name))

        # Finally we can add a media gallery in order to contain our randomized
        # embed that we're using to provide a visual and fun representation of the action.
        container.media_gallery { |media| media.gallery_item(media: gif(:PUNCH)) }
      end
    end
  end
end
