# frozen_string_literal: true

module Owner
  # This is how we can handle logging.
  def self.logs(_)
    return if File.file?("logs.txt")

    Rufus::Scheduler.s.stderr = File.open("logs.txt", "ab")

    Discordrb::LOGGER.streams = [File.open("logs.txt", "ab")]
  end
end
