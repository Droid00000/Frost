# frozen_string_literal: true

module Birthday
  # Search for timezones.
  def self.search(data)
    return unless data.focused?("timezone")

    choices = if data.option["timezone"] && data.option["timezone"].empty?
                Frost::Birthdays::DEFAULT_ZONES
              else
                Frost::Birthdays.search(data.option["timezone"])
              end

    choices = if choices.is_a?(Hash)
                choices.map do |key, zone|
                  { name: key.to_s, value: zone.to_s }
                end
              else
                choices.map do |result|
                  { name: result[:name], value: result[:timezone] }
                end
              end

    return if choices.empty?

    data.interaction.create_autocomplete_response(choices)
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

  # Parse a date given to us.
  def self.date(data)
    data = data.options.except("timezone").values

    begin
      Date.parse(data.join("/")).iso8601
    rescue StandardError
      nil
    end
  end

  # Modify an existing date given to us.
  def self.change_date(data)
    old = Frost::Birthdays.fetch(data)

    month = data.options["month"] || old.month

    day = data.options["day"] || old.month

    begin
      Date.new(old.year, month, day)
    rescue StandardError
      nil
    end
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
