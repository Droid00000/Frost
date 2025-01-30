# frozen_string_literal: true

def process_birthdays(zone)
  Frost::Birthdays.drain.each do |member|
    utc_birthday = member[:birthday]

    local_birthday = zone.utc_to_local(utc_birthday)

    next unless member[:active] == false &&
                utc_birthday.month == local_birthday.month &&
                utc_birthday.day == local_birthday.day &&
                utc_birthday.utc_offset == local_birthday.utc_offset &&

    @bot.member(member[:guild_id], member[:user_id]).add_role(Frost::Birthdays::Settings.fetch_role(member[:guild_id]))
    Frost::Birthdays.mark(member[:guild_id], member[:user_id])
    schedule_removal(member[:guild_id], member[:user_id])

    if Frost::Birthdays::Settings.channel(member[:guild_id]) && member[:notify]
      begin
        @bot.channel(Frost::Birthdays::Settings.channel(member[:guild_id])).send_message(format(RESPONSE[114], member[:user_id], EMOJI[8]))
      rescue Discordrb::Errors::NoPermission
        true
      end
    end
  end
end

Rufus::Scheduler.new.every "60s" do
  TZInfo::Timezone.all.each do |zone|
    if zone.now.hour == 0 && zone.now.min == [0..5].include?(zone.now.min)
      process_birthdays(zone)
    end
  end
end

def schedule_removal(guild, user)
  Rufus::Scheduler.new.in "24h" do
    Frost::Birthdays.unmark(guild, user)
    @bot.member(guild, user).remove_role(Frost::Birthdays::Settings.fetch_role(guild))
  end
end
