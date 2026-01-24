# frozen_string_literal: true

module Owner
  # This is how we can handle logging.
  def self.logs(_)
    # We're already good to go, so just return.
    return if @time

    # Set the time of when we first got a ready.
    @time ||= Time.now.to_i

    # Initialize all of our events once we're ready.
    Thread.new { Events::Storage.login }

    # Initialize all of our boosters once we're ready.
    Thread.new { Boosters::Storage.login }

    # Initialize all of our birthdays once we're ready.
    Thread.new { Birthdays::Storage.login }

    # Initialize all of our birthdays once we're ready.
    Thread.new { Birthdays::Orchestrator.login }

    # Return unless we were called in an actual runtime.
    return unless ENV.fetch("PRODUCTION_LOGS", nil)

    # Tell rufus to output any log info to our log file.
    Rufus::Scheduler.s.stderr = File.open("logs.rb", "ab")

    # Tell discordrb to output any log info to our log file.
    Discordrb::LOGGER.streams = [File.open("logs.rb", "ab")]
  end
end
