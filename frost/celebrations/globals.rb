# frozen_string_literal: true

module Celebrations
  # Interaction responses.
  REPLY = Frost::Utilities.table(
    USER_MISSING_CONFIGURE_PERMISSIONS: "You need to have the `administrator` permission to do this.",
    USER_MAX_ROLE_BELOW_CONFIGURE_TARGET: "Your top role is below the selected birthday role.",
    CONFIGURE_SUCCESS: "Successfully configured birthday perks for this server.",
    INVALID_CONFIGURE_TARGET_EVERYONE_ROLE: "The `@everyone` role cannot be the birthday role.",
    INVALID_CONFIGURE_TARGET_MANAGED_ROLE: "A role managed by an integration cannot be the birthday role.",
    GUILD_UNCONFIGURED: "This server hasn't enabled birthday perks.",
    DELETE_CONFIGURE_SUCCESS: "Successfully disabled birthday perks for this server."
  )

  # Default timezones for autocomplete.
  DEFAULT_ZONES = {
    "New York, United States": "America/New_York",
    "Los Angeles, United States": "America/Los_Angeles",
    "Chicago, United States": "America/Chicago",
    "Denver, United States": "America/Denver",
    "Kolkata, India": "Asia/Kolkata",
    "Istanbul, Turkiye": "Europe/Istanbul",
    "Moscow, Russia": "Europe/Moscow",
    "London, United Kingdom": "Europe/London",
    "Paris, France": "Europe/Paris",
    "Madrid, Spain": "Europe/Madrid",
    "Berlin, Germany": "Europe/Berlin",
    "Athens, Greece": "Europe/Athens",
    "Kyiv, Ukraine": "Europe/Kyiv",
    "Rome, Italy": "Europe/Rome",
    "Amsterdam, Netherlands": "Europe/Amsterdam",
    "Warsaw, Poland": "Europe/Warsaw",
    "Toronto, Canada": "America/Toronto",
    "Brisbane, Australia": "Australia/Brisbane",
    "Sydney, Australia": "Australia/Sydney",
    "Melbourne, Australia": "Australia/Melbourne",
    "Sao Paulo, Brazil": "America/Sao_Paulo",
    "Tokyo, Japan": "Asia/Tokyo",
    "Shanghai, China": "Asia/Shanghai",
    "Lagos, Nigeria": "Africa/Lagos"
  }.freeze

  # Parse an IANA timezone from a given string.
  def self.parse_timezone(input)
    return nil unless input&.include?("/")

    processed = input.split("/").map do |piece|
      piece.split(/[\s_]+/).map(&:capitalize).join("_")
    end

    TZInfo::Timezone.get(processed.join("/")) rescue nil
  end
end
