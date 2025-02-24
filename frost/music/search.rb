# frozen_string_literal: true

module Music
  # Search for tracks.
  def self.search(data)
    return unless data.option["song"]

    if CALLIOPE.send(:url?, data.option["song"])
      search = CALLIOPE.search(data.option["song"])
    end

    unless CALLIOPE.send(:url?, data.option["song"])
      search = CALLIOPE.search(data.option["song"], :spotify)
    end

    choices = search.tracks&.take(25)&.map! do |track|
      { name: track.name, value: track.source }
    end

    data.interaction.create_autocomplete_response(choices) unless choices&.empty?
  end
end
