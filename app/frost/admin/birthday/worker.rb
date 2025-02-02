# frozen_string_literal: true

def process_birthdays(zone)
  Frost::Birthdays.drain.each do |member|
    next if currently_birthday?(member, zone) == false

    add_guild_role(member[:guild_id], member[:user_id])

    schedule_removal(member[:guild_id], member[:user_id])

    send_birthday_message(member[:guild_id], member[:user_id])
  end
end

Rufus::Scheduler.new.every "60s" do
  TZInfo::Timezone.all.each do |zone|
    process_birthdays(zone) if zone.now.hour.zero? && (0..5).to_a.include?(zone.now.min)
  end
end

def schedule_removal(guild, user)
  Frost::Birthdays.mark(guild, user)

  Rufus::Scheduler.new.in "24h" do
    Frost::Birthdays.unmark(guild, user)
    @bot.member(guild, user).remove_role(Frost::Birthdays::Settings.fetch_role(guild))
  end
end

def currently_birthday?(member, timezone)
  return false unless member[:active] == false

  return false unless timezone.identifier == member[:timezone]

  return false unless Frost::Birthdays.zone(timezone.identifier)

  return false unless member[:birthday].day == timezone.now.to_time.day

  false unless member[:birthday].month == timezone.now.to_time.month
end

def add_guild_role(guild, user)
  @bot.member(guild, user).add_role(Frost::Birthdays::Settings.fetch_role(guild))
end

def send_birthday_message(guild, user)
  message = format(RESPONSE[114], user, EMOJI[8])

  return unless Frost::Birthdays::Settings.channel(guild)

  @bot.channel(Frost::Birthdays::Settings.channel(guild)).send_message(message)
end
