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

  # Set no color for the container if the user has no color.
  # @param [Discordrb::User] The user to check the color for.
  # @return [Discordrb::ColorRGB, nil] The color or nil.
  def self.to_color(user)
    return unless user.respond_to?(:color)

    user.color unless user.color.to_i.zero?
  end
end
