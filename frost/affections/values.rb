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
    7 => "**%s noms %s!**",
  }.freeze

  # The main header of text showing the action.
  HEADERS = {
    1 => "### ANGER",
    2 => "### BONKS",
    3 => "### POKES",
    4 => "### PUNCH",
    5 => "### SLEEP",
    6 => "### HUGS",
    7 => "### NOMS"
  }.freeze

  # Application commands for affections.
  COMMANDS = {
    1 => "`/angered`",
    2 => "`/sleep`",
    3 => "`/punch`",
    4 => "`/bonk`",
    5 => "`/poke`",
    6 => "`/nom`",
    7 => "`/hug`"
  }.freeze

  # Returns a random GIF link for use by the affection and snowball commands.
  # @param [Integer] An integer from 1-7 representing the type of action.
  # @return [String] The appropriate GIF for the action.
  def gif(type)
    case type
    when :ANGRY
      ANGRY.sample
    when :HUGS
      HUGS.sample
    when :NOMS
      NOMS.sample
    when :POKES
      POKES.sample
    when :SLEEPY
      SLEEPY.sample
    when :COLLECT
      COLLECT.sample
    when :THROW
      THROW.sample
    when :MISS
      MISS.sample
    when :BONK
      BONK.sample
    when :PUNCH
      PUNCH.sample
    else
      UI[21]
    end
  end
end
