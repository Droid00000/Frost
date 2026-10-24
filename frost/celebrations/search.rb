# frozen_string_literal: true

module Celebrations
  # Search for a timezone.
  def self.search_timezone(data)
    if (zone = data.options[:timezone]).empty?
      data.choices.merge!(DEFAULT_ZONES)
    else
      query = "SELECT * FROM search_timezones(?);"

      BOT.db.fetch(query, zone).each do |row|
        data.choices[row[:name]] = row[:timezone]
      end
    end

    data.respond(choices: data.choices)
  end
end
