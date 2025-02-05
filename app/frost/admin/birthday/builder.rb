# frozen_string_literal: true

def add_role(guild, user)
  @bot.member(guild, user).add_role(Frost::Birthdays::Settings.fetch_role(guild))
end

def remove_user_role(guild, user)
  Frost::Birthdays.unmark(guild, user)

  @bot.member(guild, user).remove_role(Frost::Birthdays::Settings.fetch_role(guild))
end

def birthday_message(guild, user)
  message = format(RESPONSE[114], user, EMOJI[8])

  return unless Frost::Birthdays::Settings.channel(guild)

  @bot.channel(Frost::Birthdays::Settings.channel(guild))&.send_message(message)
end

def schedule_removal(guild, user)
  Frost::Birthdays.mark(guild, user)

  Rufus::Scheduler.new.in "24h" do
    remove_user_role(guild, user)
  end
end
