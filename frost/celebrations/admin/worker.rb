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
      @@pg.where(pending: false).each do |user|
        @@scheduler.at(user[:birthdate], tag: user[:user_id]) do
          handle_birthday_task(user)
        end
      end

      @@pg.where(pending: true).each { |user| handle_pending_task(user) }
    end

    # Unschedle a job based off of the task (user) ID.
    # this doesn't kill any actively running jobs.
    def self.delete(snowflake)
      @@scheduler.jobs(tag: snowflake).map(&:unschedule)
    end

    # Schedule a new job based off of a singular user ID.
    # @param snowflake [Integer] The user ID to schedule for.
    def self.schedule(snowflake)
      @@pg.where(user_id: snowflake).each do |user|
        @@scheduler.at(user[:birthdate], tags: snowflake) do
          handle_birthday_task(user)
        end
      end
    end

    # The actions take on a member's birthday.
    # @param user [Integer] The ID for the user the actions are for.
    def self.handle_birthday_task(user)
      # Request the user at runtime, instead of upfront.
      user = @@pg.where(user_id: user).first

      # Make sure the user still exists on their birthday.
      return if user.nil?

      user[:guilds].each do |guild|
        # Use a seperate guild class for backend stuff.
        Backend::Guild.new(guild)

        add_birthday_role(guild, user[:user_id])

        send_birthday_message(guild, user[:user_id])

        schedule_role_removal(guild, user[:user_id])
      end

      # Mark the user as pending for now.
      @@pg.where(user_id: user[:user_id]).update(pending: true)

      @@scheduler.in((user[:birthdate].utc + 86_400), tags: user[:user_id]) do
        @@pg.where(user_id: user[:user_id]).update(pending: false)
      end
    end

    # Remove the birthday role from a member after their birthday.
    # @param guild [Integer] ID of the guild the role removal is for.
    # @param user [Integer] ID of the user the role removal is for.
    # @param time [nil, Symbol] Whether to compute the role removal time.
    def self.schedule_role_removal(guild, user, time: nil)
      # Define a lambda to contain the actual removal logic.
      handler = lambda do |user|
        @@bot.member(user, guild.id)&.remove_role(guild.role)
      end

      begin
        case time
        # Immediately removes the role from the user.
        when :NOW
          handler.call(user)
        # Waits twenty-four hours before removing the role.
        when nil
          @@scheduler.in("24h") { handler.call(user) }
          # Waits until the day after the birthday to remove the role.
        when :OLD
          @@scheduler.at(user[:birthdate].utc + 86_400) { handler.call(user[:user_id]) }
        end
      rescue StandardError
        nil
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
      @@bot.member(user, guild.id)&.add_role(guild.role)
    rescue StandardError
      nil
    end

    # Handle a user with the pending flag set to true.
    # @param user [Hash] The sequel data hash for the given user.
    def self.handle_pending_task(user)
      # Seperate the actual checking logic from the iteration.
      date_checker = lambda do |guild, user_|
        # Check if the current date is still the birthdate.
        if Time.now.utc <= user_[:birthdate].utc
          # Re-schedule a removal when it becomes the next day.
          schedule_role_removal(guild, user_, time: :OLD)

          # Set pending to false at the next day to avoid repeats.
          @@scheduler.at(user_[:birthdate].utc + 86_400) do
            @@pg.where(user_id: user_[:user_id]).update(pending: false)
          end
        end

        # Check if the current date is no longer the birthdate.
        if Time.now.utc >= user[:birthdate].utc
          # Remove the role immediately if this is the case.
          schedule_role_removal(guild, user, time: :NOW)

          # Immediately set pending to false to avoid repeats.
          @@pg.where(user_id: user[:user_id]).update(pending: false)
        end
      end

      # loop through each guild for the user.
      user[:guilds].each do |guild|
        # Perform the actual check here.
        date_checker.call(Backend::Guild.new(guild), user)
      end
    end
  end
end
