# frozen_string_literal: true

def process_birthdays(zone)
  Frost::Birthdays.drain.each do |member|
    utc_birthday = Time.iso8601(member[:birthday])

    local_birthday = zone.utc_to_local(utc_birthday)

    next unless utc_birthday.month == local_birthday.month &&
                utc_birthday.day == local_birthday.day &&
                utc_birthday.utc_offset == local_birthday.utc_offset &&
                member[:active] == false

    @bot.member(member[:guild_id], member[:user_id]).add_role(Frost::Birthdays::Settings.fetch_role(member[:guild_id]))
    Frost::Birthdays.mark(member[:guild_id], member[:user_id])

    if Frost::Birthdays::Settings.channel(member[:guild_id]) && member[:notify]
      begin
        @bot.channel(Frost::Birthdays::Settings.channel(member[:guild_id])).send_message(format(RESPONSE[115], member[:user_id], EMOJI[8]))
      rescue StandardError
        true
      end
    end
  end
end

Rufus::Scheduler.new.every "60s" do
  TZInfo::Timezone.all.each do |zone|
    if zone.now.hour == 0 && zone.now.min.between(0, 5)
      process_birthdays(zone)
    end
  end
end

Rufus::Scheduler.new.every "29h" do
  Frost::Birthdays.drain.each do |member|
    next unless member[:active]

    Frost::Birthdays.unmark(member[:guild_id], member[:user_id])
    @bot.member(member[:guild_id], member[:user_id]).remove_role(Frost::Birthdays::Settings.fetch_role(member[:guild_id]))
  end
end
