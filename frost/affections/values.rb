# frozen_string_literal: true

module Affections
  # Responses and fields for affections.
  RESPONSE = {
    angered: "**Watch out %s! Someone seems to be angry today!**",
    punch: "**%s punches %s!**",
    poke: "**%s pokes %s!**",
    bonk: "**%s bonks %s!**",
    hug: "**%s hugs %s!**",
    nom: "**%s noms %s!**"
  }.freeze

  # The main text header that states the action.
  HEADERS = {
    hug: "**HUGS**",
    nom: "**NOMS**",
    bonk: "**BONKS**",
    poke: "**POKES**",
    punch: "**PUNCH**",
    angered: "**ANGER**"
  }.freeze
end
