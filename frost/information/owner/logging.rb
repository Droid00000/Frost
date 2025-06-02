# frozen_string_literal: true

module Owner
  # This is how we can handle logging.
  def self.logs(_)
    # Log the first time we got a ready event.
    @@uptime ||= Time.now.to_i

    # Tell rufus to output any log info to our log file.
    Rufus::Scheduler.s.stderr = File.open("logs.txt", "ab")

    # Tell discordrb to output any log info to our log file.
    Discordrb::LOGGER.streams = [File.open("logs.txt", "ab")]
  end
end
