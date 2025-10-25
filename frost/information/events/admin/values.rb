# frozen_string_literal: true

module AdminCommands
  # namespace for event admins.
  module Events
    # Responses and fields for event admins.
    RESPONSE = {
      1 => "You need to have the `manage roles` permission to do this.",
      2 => "Successfully disabled event perks for the <@&%s> role.",
      3 => "Successfully enabled event perks for the <@&%s> role.",
      4 => "You cannot enable event perks for this role.",
      5 => "Successfully removed the target member.",
      6 => "Successfully added the target member.",
      7 => "The target role is not an event role."
    }.freeze

    # Suppress mentions for event roles.
    MENTIONS = { allowed_mentions: { parse: [] } }.freeze
  end
end
