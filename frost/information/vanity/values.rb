# frozen_string_literal: true

module Vanity
  # Responses and fields for vanity roles.
  RESPONSE = {
    1 => "The role couldn't be edited. The bot's highest role is below the provided role.",
    2 => "The role has been successfully edited! <a:LoidClap_Maomao:1276327798104920175>",
    3 => "The bot needs to have the `manage roles` permission to do this.",
    4 => "Please provide a start **and** end color for the gradient.",
    5 => "Please provide a start **or** end color for the gradient.",
    6 => "Please provide a start color for the gradient.",
    7 => "Please provide an end color for the gradient."
  }.freeze

  # Produce an audit reason string to show when operating on the current role.
  # @param interaction [Interaction] The current interaction the entry is for.
  # @return [String] A string that denotes the action type and current user ID.
  def self.reason(interaction) = "Vanity Roles (ID: #{interaction.user.id})"

  # Convert an interaction object into usable role icon for the current role.
  # @param interaction [Interaction] The current interaction the role is for.
  # @return [String, File, nil] The icon from the role that was extracted or `nil`.
  def self.to_icon(interaction)
    return nil unless interaction.server.features.include?(:role_icons)

    interaction.emoji("icon")&.file || interaction.options["icon"]&.scan(Unicode::Emoji::REGEX)&.first
  end
end
