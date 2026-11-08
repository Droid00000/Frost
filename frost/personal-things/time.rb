# frozen_string_literal: true

module PersonalThings
  # View the time in a specific timezone.
  def self.timezone_time(event)
    unless (zone = Celebrations.parse_timezone(event.options[:timezone]))
      event.edit_response(content: "Invalid timezone.")
      return
    end

    time = zone.now.to_time
    date = time.strftime(Frost::Utilities.ordinal(time.day))

    event.edit_response(content: time.strftime("%B #{date}, %Y at %I:%M %p"))
  end
end
