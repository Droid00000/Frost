# frozen_string_literal: true

module Settings
  # A view that returns garbage collection stats.
  def self.stats(data)
    # Return early unless I'm the one using the command.
    unless data.user.id == owner
      data.edit_response(content: RESPONSE[1])
      return
    end

    # Manually enable the `IS_COMPONENTS_V2 (1 << 15)`
    # flags so we can use the new interaction components.
    data.send_message(new_components: true, flags: 64) do |_, builder|
      # Create a container in order to simulate the old look and
      # feel of an embed. This looks okay on mobile, but not so
      # good on desktop.
      builder.container do |container|
        # Create a section to contain all of our main content, since
        # if we attempt to only wrap our main heading text into a section
        # we get some very weird spacing due to the fact that the thumbnail
        # does not resize the spacing. This is a weird limitation that I hope
        # gets addressed sometime in the future. For now, this will do though.
        container.text_display(text: RESPONSE[3])

        # We have a basic lambda defined here that transforms
        # our garbage collection view. First we filter out the
        # the keys we don't want, then we remove the `T_` prefix
        # from them. After that we convert back into a hash and map
        # our keys into an array of strings (transformed implicitly).
        count = lambda do |view|
          view = view.dup.map do |key, value|
            view[key] = nil if TYPES[key]

            [key.downcase[2..].to_s, value&.delimit]
          end

          view.to_h.compact.map do |key, value|
            format(RESPONSE[1], key.capitalize, value, key.plural)
          end
        end

        # here lies another basic lambda that fetches the time when
        # our system last started up. There's probably a better way
        # to do this, but I couldn't get anything else to work inside
        # of my docker container. Find out why busybox errors out there.
        date = lambda do
          stat = File.read("/proc/#{Process.pid}/stat")
          time = File.read("/proc/uptime").split[0].to_f
          Time.now - (time - (stat.split[21].to_i / 100.0)).to_i
        end

        # Request all of our channel data up front in order
        # to avoid making duplicate requested to the DB.
        view = ObjectSpace.count_objects

        # Count all of our remaining objects in the view
        # hash we just fetched.
        container.text_display(text: count.call(view).join)

        # Add some spacing between the section content of our
        # container and the remaining content we're adding.
        container.seperator(divider: true, spacing: :small)

        # Add some spacing between the content of our container
        # and the footer text that we're adding.
        container.text_display(text: format(RESPONSE[1], view[:TOTAL].delimit, date.call))
      end
    end
  end
end
