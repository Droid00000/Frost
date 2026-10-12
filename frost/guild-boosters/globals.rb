# frozen_string_literal: true

module Boosters
  # Interaction responses.
  REPLY = Frost::Utilities.table(
    USER_MISSING_CONFIGURE_PERMISSIONS: "You need to have the `manage roles` permission to do this."
  )
end
