# frozen_string_literal: true

module Birthday
  # Search for timezones.
  def self.search(data)
    return unless data.resolve_options["timezone"]

    zones = ::ZONES.select do |key, value|
      key.to_s.include?(data.resolve_options["timezone"].upcase)
    end

    if zones.empty?
      zones = TZInfo::Timezone.all.select do |zone|
        zone.identifier.include?(Birthday.parser(data.resolve_options["timezone"]).join("/"))
      end
    end

    if zones.empty?
      zones = ::ZONES.filter_map do |key, value|
        value.each do |identifier|
          identifier.include?(data.resolve_options["timezone"])
        end
      end
    end

    choices = if zones.is_a?(Hash)
                zones.values.flatten.map! do |zone|
                  { name: zone, value: zone }
                end
              else
                zones.map! do |zone|
                  { name: zone, value: zone.identifier }
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
