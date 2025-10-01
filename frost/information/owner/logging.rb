# frozen_string_literal: true

module Owner
  # This is how we can handle logging.
  def self.logs(_)
    # Log the time at which we first got a ready event.
    @uptime ||= Time.now.to_i

    # Initialize all of our birthdays once we're ready.
    Birthdays::Orchestrator.login

    # Return unless we were called in an actual runtime.
    return unless ENV.fetch("PRODUCTION", nil)

    # Tell rufus to output any log info to our log file.
    Rufus::Scheduler.s.stderr = File.open("logs.rb", "ab")

    # Tell discordrb to output any log info to our log file.
    Discordrb::LOGGER.streams = [File.open("logs.rb", "ab")]
  end
end
