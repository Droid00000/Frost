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

    if choices.is_a?(Hash)
      choices = choices.map do |key, zone|
        { name: key.to_s, value: zone.to_s }
      end
    end

    unless choices.is_a?(Array)
      choices = choices.map do |result|
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

  # Create autocomplete choices for a date.
  def self.date(data)
    return unless data.focused?("date")

    option, choices = data.option["date"], []

    begin
      first = Time.parse(option)
    rescue StandardError
      first = nil
    end

    begin
      second = Time.strptime(option, "%d/%m")
    rescue StandardError
      second = nil
    end

    view = ->(time) { time.strftime("%B #{time.day.ordinal}") }

    if first
      choices << { name: view.call(first), value: first.strftime("%m/%d") }
    end

    if second
      choices << { name: view.call(second), value: second.strftime("%m/%d") }
    end

    return if choices.empty?

    data.interaction.create_autocomplete_response(choices.uniq)
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
