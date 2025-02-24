# frozen_string_literal: true

module Birthday
  # Search for timezones.
  def self.search(data)
    return unless data.option["timezone"]

    choices = if data.option["timezone"]&.empty?
                Frost::Birthdays.generic
              else
                Frost::Birthdays.search(data.option["timezone"])
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

  # Create autocomplete choices for a date.
  def self.date(data)
    return unless data.option["date"]

    option, choices = data.option["date"], []

    begin
      time_1 = Time.parse(option)
    rescue StandardError
      time_1 = nil
    end

    begin
      time_2 = Time.strptime(option, "%d/%m")
    rescue StandardError
      time_2 = nil
    end

    view = lambda { |time| time.strftime("%B #{time.day.ordinal}") }

    if time_1
      choices << { name: view.call(time_1), value: time_1.strftime("%m/%d") }
    end

    if time_2
      choices << { name: view.call(time_2), value: time_2.strftime("%m/%d") }
    end

    data.interaction.create_autocomplete_response(choices.uniq) unless choices.empty?
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
