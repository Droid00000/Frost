# frozen_string_literal: true

module Owner
  # Log statistics for raw events.
  def self.raw(data)
    @count ||= Hash.new(0)

    @count[data.type] += 1
  end

  # A tracker of the total events reccieved so far.
  def self.statistics(data)
    # Permission check to make this owner only.
    unless data.user.id == CONFIG[:Discord][:OWNER]&.to_i
      data.edit_response(content: RESPONSE[2])
      return
    end

    # Sort our stats in descending order by count.
    stats = @count.sort_by { |_, size| -size }

    # Calculate the total amount of stats we have.
    total = stats.map(&:last).sum.delimit

    # format everything in our desired form.
    stats.map! do |type, count|
      "#{type} —— #{count.delimit}\n"
    end

    # Manually enable the `IS_COMPONENTS_V2 (1 << 15)`
    # flags so we can use the new interaction components.
    data.edit_response(has_components: true) do |_, builder|
      # Create a container in order to simulate the old look and
      # feel of an embed. This looks okay on mobile, but not so
      # good on desktop.
      builder.container do |container|
        # Add our main title heading here.
        container.text_display(text: RESPONSE[3])

        # Add our main content markdown here.
        container.text_display(text: format(RESPONSE[6], stats.join))

        # Add a divider for a bit of visual seperation.
        container.seperator(divider: true, spacing: :small)

        # Add a little bit of footer text for total count.
        container.text_display(text: format(RESPONSE[1], total, @uptime))
      end
    end
  end
end
