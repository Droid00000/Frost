# frozen_string_literal: true

module Birthdays
  # Search for timezones.
  def self.search(data)
    choices = if data.options["timezone"].empty?
                data.choices.merge!(DEFAULT_ZONES)
              else
                query = "SELECT * FROM search_timezones(?);"
                POSTGRES[query, data.options["timezone"]].all
              end

    unless choices.is_a?(Hash)
      choices.map do |result|
        data.choices[result[:name]] = result[:timezone]
      end
    end

    data.respond(choices: event.choices)
  end

  # Validate a timezone given to us.
  def self.invalid_timezone?(data)
    data.options["timezone"] ? timezone(data.options["timezone"]).nil? : false
  end

  # Validate a birthday given to us.
  def self.invalid_birthday?(data)
    data.options.except("timezone").empty? ? false : change_date(data).nil?
  end

  # Change a birthday given to us.
  def self.change(data)
    date = change_date(data)

    timezone = timezone(data)

    return date.iso861 unless timezone

    TZInfo::Timezone.get(timezone).to_local(date).utc.iso8601
  end

  # Get a timezone without any validation.
  def self.zone(zone)
    TZInfo::Timezone.get(zone)&.now
  end

  # Parse a date given to us.
  def self.date(data)
    data = data.options.except("timezone").values

    begin
      Date.parse(data.join("/"))
    rescue StandardError
      nil
    end
  end

  # Create a date from the time given to us.
  def self.build_date(data)
    timezone = TZInfo::Timezone.get(timezone(data))

    date = data.options.except("timezone").values.reverse

    timezone.local_to_utc(Time.now.year, *date, 0, 0, 0)
  end

  # Modify an existing date given to us.
  def self.change_date(data)
    old = Frost::Birthdays.fetch(data)

    if data.options.except("timezone").empty?
      return old.utc
    end

    day = data.options["day"] || old.month

    month = data.options["month"] || old.month

    info = [old.hour, old.minute, old.second, old.zone]

    begin
      Date.new(old.year, month, day, *info).utc
    rescue StandardError
      nil
    end
  end

  # Get a timezone including error handling.
  def self.timezone(data)
    return nil unless data && data.options["timezone"]

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
