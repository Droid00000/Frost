# frozen_string_literal: true

module Vanity
  # Responses and fields for vanity roles.
  RESPONSE = {
    1 => "The role couldn't be edited. The bot's highest role is below the provided role.",
    2 => "The role has been successfully edited! <a:LoidClap_Maomao:1276327798104920175>",
    3 => "The bot needs to have the `manage roles` permission to do this.",
    4 => "Please provide a start **and** end color for the gradient.",
    5 => "Please provide a start **or** end color for the gradient.",
    6 => "The role name contains a word that cannot be used.",
    7 => "Please provide a start color for the gradient.",
    8 => "Please provide an end color for the gradient."
  }.freeze

  # TODO: find a better solution later down the road.
  def self.overwrite(data)
    return false if data.user.owner? || data.user.roles.any? do |role|
      role.permissions.bits.anybits?(268_435_464)
    end

    return true if data.channel.overwrites[data.user.id]&.allow&.bits&.anybits?(268_435_456)

    data.user.roles.sort_by(&:permission).each do |role|
      return true if data.channel.overwrites[role.id]&.allow&.bits&.anybits?(268_435_456)
    end
  end

  # Produce an audit reason string to show when operating on the current role.
  # @param interaction [Interaction] The current interaction the entry is for.
  # @return [String] A string that denotes the action type and current user ID.
  def self.reason(interaction) = "Vanity Roles (ID: #{interaction.user.id})"
end
