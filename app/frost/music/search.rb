# frozen_string_literal: true

def music_search(data)
  return if data.resolve_options["song"].empty?

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
