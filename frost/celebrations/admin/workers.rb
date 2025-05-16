# frozen_string_literal: true

module Birthdays
  # Schedule birthday tasks.
  class Scheduler
    # @return [Discordrb::Bot]
    @@bot = @bot

    # @return [Sequel::Dataset]
    @@pg = POSTGRES[:guild_birthdays]

    # @return [Rufus::Scheduler]
    @@scheduler = Rufus::Scheduler.singleton

    # A login hook that schedules all the birthday tasks for all
    # of the members that are stored in the database.
    def self.on_login
      @@pg.all.each do |user|
        @@scheduler.at(birthday(user), tags: user[:user_id]) do
          [schedule_birthday_task(user), track_birthday_task(user)]
        end
      end
    end

    # Unschedle a job based off of the task (user) ID.
    # this doesn't kill any actively running jobs.
    def self.delete(snowflake)
      @@scheduler.job(tag: snowflake)&.unschedule

      @@scheduler.job(tag: "_#{snowflake}")&.unschedule
    end

    # Schedule a new job based off of a singular user ID.
    # @param snowflake [Integer] The user ID to schedule for.
    def self.schedule(snowflake)
      @@pg.where(user_id: snowflake).each do |user|
        @@scheduler.at(birthday(user), tags: user[:user_id]) do
          [schedule_birthday_task(user), track_birthday_task(user)]
        end
      end
    end

    private

    # @!visibility priivate
    def self.schedule_birthday_task(user)
      user[:guilds].each do |guild|
        # Seperate class for backend guilds.
        guild = Backend::Guild.new(guild)

        add_birthday_role(guild, user[:user_id])

        send_birthday_message(guild, user[:user_id])

        schedule_role_removal(guild, user[:user_id])
      end

      @@pg.where(user_id: user).update(active: true)
    end

    # @!visibility private
    def self.schedule_role_removal(guild, user)
      @@scheduler.in("24h", tag: "_#{user}") do
        @@pg.where(user_id: user).update(active: false)

        begin
          @@bot.member(user, guild.id).remove_role(guild.role)
        rescue StandardError
          nil
        end
      end
    end

    # @!visibility private
    def self.send_birthday_message(guild, user)
      channel = @@bot.channel(guild.channel)

      begin
        channel&.send_message(RESPONSE[1] % user[:user_id])
      rescue StandardError
        nil
      end
    end

    # @!visibility private
    def self.add_birthday_role(guild, user)
      begin
        @@bot.member(user, guild.id).add_role(guild.role)
      rescue StandardError
        nil
      end
    end
  end
end
