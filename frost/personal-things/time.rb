# frozen_string_literal: true

module PersonalThings
  # View the time in a specific timezone.
  def self.time(event)
    unless (zone = Celebrations.parse_timezone(event.options[:timezone]))
      event.respond(content: REPLY.INVALID_TIMEZONE, ephemeral: true)
      return
    end

    time = zone.now.to_time
    day = Frost::Utilities.ordinal(time.day)

    event.respond(
      content: time.strftime("%B #{day}, %Y at %I:%M %p"), ephemeral: true
    )
  end
end
