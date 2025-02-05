# frozen_string_literal: true

def past_birthday?(member, timezone)
  Birthday.timezone(timezone).now.day != member[:birthday].day
end

def compute_midnight(timezone)
  Time.parse(timezone.strftime("%m/%d/#{Time.now.year}")) + 86400
end

def reschedule_removal(member, timezone)
  seconds = compute_midnight(timezone) - timezone

  Rufus::Scheduler.new.in "#{seconds}s" do
    remove_user_role(meber[:guild_id], member[:user_id])
  end
end

Rufus::Scheduler.new.in "40s" do
  Frost::Birthdays.marked.each do |member|
    next if past_birthday?(member, member[:timezone])

    remove_user_role(member[:guild_id], member[:user_id])

    next unless past_birthday?(member, member[:timezone])

    reschedule_removal(member, Birthday.timezone(member[:timezone]).to_time.now)
  end
end
