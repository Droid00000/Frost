# frozen_string_literal: true

def process_birthdays(zone)
  Frost::Birthdays.drain.each do |member|
    next if currently_birthday?(member, zone) == false

    remove_user_role(member[:guild_id], member[:user_id])

    schedule_removal(member[:guild_id], member[:user_id])

    birthday_message(member[:guild_id], member[:user_id])
  end
end

Rufus::Scheduler.new.every "60s" do
  TZInfo::Timezone.all.each do |zone|
    process_birthdays(zone) if currently_midnight?(zone)
  end
end

def currently_midnight?(zone)
  zone.now.hour.zero? && (0..5).to_a.include?(zone.now.min)
end

def currently_birthday?(member, timezone)
  return false unless member[:active] == false

  return false unless timezone.identifier == member[:timezone]

  return false unless member[:birthday].day == timezone.now.to_time.day

  return false unless member[:birthday].month == timezone.now.to_time.month
end
