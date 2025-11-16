# frozen_string_literal: true

module Birthdays
  # Search for a timezone.
  def self.search(data)
    if (zone = data.options["timezone"]).empty?
      data.choices.merge!(DEFAULT_ZONES)
    else
      POSTGRES.fetch(SEARCH_QUERY, zone).each do |row|
        data.choices[row[:name]] = row[:timezone]
      end
    end

    data.respond(choices: data.choices)
  end
end
