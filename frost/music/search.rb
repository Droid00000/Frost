# frozen_string_literal: true

module Music
  # Search for tracks.
  def self.search(data)
    return unless data.resolve_options["song"]

    if CALLIOPE.send(:url?, data.resolve_options["song"])
      search = CALLIOPE.search(data.resolve_options["song"])
    end

    unless CALLIOPE.send(:url?, data.resolve_options["song"])
      search = CALLIOPE.search(data.resolve_options["song"], :spotify)
    end

    choices = search.tracks&.take(25)&.map! do |track|
      { name: track.name, value: track.source }
    end

    data.interaction.create_autocomplete_response(choices) if choices
  end
end
