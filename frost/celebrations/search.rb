# frozen_string_literal: true

module Birthdays
  # Search for a timezone.
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

    data.respond(choices: data.choices)
  end
end
