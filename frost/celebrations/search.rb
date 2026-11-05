# frozen_string_literal: true

module Celebrations
  # Search for a timezone.
  def self.search_timezone(event)
    option = event.options[:timezone] || ""

    if option.empty? || !option.match?(/[[:alpha:]]/)
      event.choices.merge!(DEFAULT_ZONES)
    else
      query = "SELECT * FROM search_timezones(?);"

      BOT.db.fetch(query, option).each do |value|
        event.choices[value[:name]] = value[:timezone]
      end
    end

    event.respond(choices: event.choices)
  end
end
