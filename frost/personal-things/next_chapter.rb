# frozen_string_literal: true

module PersonalThings
  # Show the release date for the next chapter of a manga series.
  def self.next_chapter_when(event)
    time = Time.parse(BOT.config.chapter_info.channel.name)

    # Move to the next year because the date has already passed.
    time += 31_536_000 if time.month == 1 && [11, 12].any?(Time.now.month)

    event.edit_response(content: Discordrb.timestamp(time, :short_datetime))
  end
end
