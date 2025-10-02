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

  # Log statistics for application command usage.
  def self.slash(data)
    hash = data.interaction.data

    # Filter through the options hash.
    if hash["options"]&.any?
      case hash["options"][0]["type"]
      when 1
        subcommand = hash["options"][0]["name"].to_sym
      when 2
        group = hash["options"][0]["name"].to_sym
        subcommand = hash["options"][0]["options"][0]["name"].to_sym
      end
    end

    # Build out the database record.
    record = {
      command_user: data.user.id,
      command_epoch: Time.now.to_i,
      command_channels: data.channel_id,
      # rubocop:disable Lint/UselessAssignment
      name: "#{hash['name']} #{group ||= ''}" << " #{subcommand ||= ''}"
      # rubocop:enable Lint/UselessAssignment
    }

    # Add the final result to the cache.
    Storage.add(record.tap { it[:name] = it[:name].gsub(/\s+/, " ").strip })
  end
end
