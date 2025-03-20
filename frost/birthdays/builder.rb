# frozen_string_literal: true

module Birthdays
  # Search for timezones.
  def self.search(data)
    choices = if data.options["timezone"].empty?
                data.choices.merge!(DEFAULT_ZONES)
              else
                Frost::Birthdays.search(data.options["timezone"])
              end

    unless choices.is_a?(Hash)
      choices.map do |result|
        data.choices[result[:name]] = result[:timezone]
      end
    end

    data.respond unless data.choices.empty?
  end

  # Validate a timezone given to us.
  def self.invalid_timezone?(data)
    return false unless data.options["timezone"]

    timezone(data.options["timezone"]).nil?
  end

  # Validate a birthday given to us.
  def self.invalid_birthday?(data)
    return false if data.options.except("timezone").empty?

    change_date(data).nil?
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
      Date.new(old.year, month, day).iso8601
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
