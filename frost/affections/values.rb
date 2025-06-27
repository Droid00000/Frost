# frozen_string_literal: true

module Affections
  # Responses and fields for affections.
  RESPONSE = {
    1 => "**Watch out %s! Someone seems to be angry today!**",
    2 => "**%s should go to bed!**",
    3 => "**%s punches %s!**",
    4 => "**%s pokes %s!**",
    5 => "**%s bonks %s!**",
    6 => "**%s hugs %s!**",
    7 => "**%s noms %s!**"
  }.freeze

  # The main header of text showing the action.
  HEADERS = {
    1 => "**ANGER**",
    2 => "**BONKS**",
    3 => "**POKES**",
    4 => "**PUNCH**",
    5 => "**SLEEP**",
    6 => "**HUGS**",
    7 => "**NOMS**"
  }.freeze
end
