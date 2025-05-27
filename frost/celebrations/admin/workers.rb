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
      @@pg.where(active: false).each do |user|
        @@scheduler.at(birthday(user), tags: user[:user_id]) do
          [schedule_birthday_task(user[:user_id]), log_task(user)]
        end
      end

      @@pg.where(active: true).each do |user|
        [handle_active_birthday(user[:user_id]), log_active_task(user)]
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
          schedule_birthday_task(user[:user_id])
        end
      end
    end

    # The actions take on a member's birthday.
    # @param user [Integer] The user the actions are for.
    def self.schedule_birthday_task(user)
      # Request the user when the actual code is run
      # since this means we won't have to worry about
      # the feature getting turned off by the time of
      # the member's birthday.
      user = @@pg.where(user_id: user)

      user.first[:guilds].each do |guild|
        # Seperate class for backend guilds.
        guild = Backend::Guild.new(guild)

        add_birthday_role(guild, user[:user_id])

        send_birthday_message(guild, user[:user_id])

        schedule_role_removal(guild, user[:user_id])
      end

      @@pg.where(user_id: user[:user_id]).update(active: true)
    end

    # Remove the birthday role from a member after their birthday.
    # @param guild [Integer] ID of the guild the role removal is for.
    # @param user [Integer] ID of the user the role removal is for.
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

    # Send a birthday message to a channel.
    # @param guild [Integer] ID of the guild to get the channel for.
    # @param user [Integer] The ID of the user to mention in the message.
    def self.send_birthday_message(guild, user)
      channel = @@bot.channel(guild.channel)

      begin
        channel&.send_message(RESPONSE[1] % user)
      rescue StandardError
        nil
      end
    end

    # Add the birthday role to a member during their birthday.
    # @param guild [Integer] ID of the guild the role addition is for.
    # @param user [Integer] ID of the user the role addition is for.
    def self.add_birthday_role(guild, user)
      @@bot.member(user, guild.id).add_role(guild.role)
    rescue StandardError
      nil
    end
  end
end
