# frozen_string_literal: true

module Birthday
  # Search for timezones.
  def self.search(data)
    return unless data.resolve_options["timezone"]

    choices = TZInfo::Country.all.map do |country|
      next if country.name == "Antarctica"

      country.zone_names.map do |zone|
        split = zone.split("/").last.gsub("_", " ")

        { name: "#{split}, #{country.name}", value: zone }
      end
    end

    choices = choices.flatten.compact.reject! do |hash|
      hash[:value].include?("Antarctica")
    end

    choices = choices.uniq.select do |hash|
      option = data.resolve_options["timezone"]

      hash.values.map(&:downcase).any? do |word|
        word.include?(option.downcase)
      end
    end

    data.interaction.create_autocomplete_response(choices.take(25)) unless choices&.empty?
  end

  # Parse the timezone.
  def self.parser(data)
    data.split("/").map do |part|
      part.split(/[\s_]+/).map(&:capitalize).join("_")
    end
  end

  # Get a timezone without any validation.
  def self.zone(zone)
    TZInfo::Timezone.get(zone)&.now
  end

  # Get a timezone including error handling.
  def self.timezone(data)
    return nil unless data.options["timezone"]

    return CODES[data.options["timezone"]] if CODES[data.options["timezone"]]

    split = data.options["timezone"].split("/").map do |part|
      part.split(/[\s_]+/).map(&:capitalize).join("_")
    end

    TZInfo::Timezone.get(split.join("/")).identifier
  rescue StandardError
    nil
  end
end
