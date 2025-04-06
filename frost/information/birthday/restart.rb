# frozen_string_literal: true

def past_birthday?(member, timezone)
  Birthday.zone(timezone).day != member[:birthday].day
end

def compute_midnight(timezone)
  Time.new(timezone.year, timezone.month, timezone.day + 1)
end

def reschedule_removal(member, timezone)
  seconds = compute_midnight(timezone) - timezone

  Rufus::Scheduler.new.in "#{seconds}s" do
    remove_user_role(member[:guild_id], member[:user_id])
  end
end

Rufus::Scheduler.new.in "10s" do
  Frost::Birthdays.marked.each do |member|
    if past_birthday?(member, member[:timezone])
      remove_user_role(member[:guild_id], member[:user_id])
    end

    unless past_birthday?(member, member[:timezone])
      reschedule_removal(member, Birthday.zone(member[:timezone]).to_time)
    end
  end
end
