# frozen_string_literal: true

module Birthday
  # Search for timezones.
  def self.search(data)
    return unless data.resolve_options["timezone"]

    choices = if data.resolve_options["timezone"]&.empty?
                Frost::Birthdays.generic
              else
                Frost::Birthdays.search(data.resolve_options["timezone"])
              end

    data.interaction.create_autocomplete_response(choices) unless choices&.empty?
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

    zones = TZInfo::Timezone.all.map(&:identifier)

    if zones.include?(data.options["timezone"])
      return data.options["timezone"]
    end

    split = data.options["timezone"].split("/").map do |part|
      part.split(/[\s_]+/).map(&:capitalize).join("_")
    end

    begin
      TZInfo::Timezone.get(split.join("/")).identifier
    rescue StandardError
      nil
    end
  end
end
