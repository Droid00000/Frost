# frozen_string_literal: true

module Birthdays
  # Schedule birthday tasks.
  class Scheduler
    # @return [Sequel::Dataset]
    DB = POSTGRES[:user_birthdays]

    # @return [Rufus::Scheduler]
    TASKS = Rufus::Scheduler.singleton

    # A login hook that schedules all the birthday tasks for all
    # of the members that are stored in the database.
    def self.on_login
      # Don't make a new thread if one already exists.
      return unless @thread.nil?

      @thread = Thread.new do
        begin
          DB.where(pending: false).each do |user|
            TASKS.at(now(user[:birthdate]), tag: user[:user_id]) do
              handle_birthday_task(user)
            end
          end

          DB.where(pending: true).each { |user| handle_pending_task(user) }
        rescue StandardError => e
          Discordrb::LOGGER.log_exception(e)
        end
      end
    end

    # Unschedle a job based off of the task (user) ID.
    # this doesn't kill any actively running jobs.
    def self.delete(snowflake)
      TASKS.jobs(tag: snowflake).map(&:unschedule)
    end

    # Schedule a new job based off of a singular user ID.
    # @param snowflake [Integer] The user ID to schedule for.
    def self.schedule(snowflake)
      DB.where(user_id: snowflake).each do |user|
        TASKS.at(now(user[:birthdate]), tags: snowflake) do
          handle_birthday_task(user)
        end
      end
    end

    # The actions take on a member's birthday.
    # @param user [Integer] The ID for the user the actions are for.
    def self.handle_birthday_task(user)
      # Request the user at runtime, instead of upfront.
      user = DB.where(user_id: user).first

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
      DB.where(user_id: user[:user_id]).update(pending: true)

      TASKS.in("24h", tag: user[:user_id]) do
        DB.where(user_id: user[:user_id]).update(pending: false)
      end

      # Re-schedule the task recursively.
      TASKS.in("24h", tag: user[:user_id]) { schedule(user[:user_id]) }
    end

    # Remove the birthday role from a member after their birthday.
    # @param guild [Integer] ID of the guild the role removal is for.
    # @param user [Integer] ID of the user the role removal is for.
    # @param time [nil, Symbol] Whether to compute the role removal time.
    def self.schedule_role_removal(guild, user, time: nil)
      # Define a lambda to contain the actual removal logic.
      handler = lambda do |user|
        BOT.member(user, guild.id)&.remove_role(guild.role)
      end

      begin
        case time
        # Immediately removes the role from the user.
        when :NOW
          handler.call(user)
        # Waits twenty-four hours before removing the role.
        when nil
          TASKS.in("24h") { handler.call(user) }
          # Waits until the day after the birthday to remove the role.
        when :OLD
          TASKS.at(user[:birthdate].utc + 86_400) { handler.call(user[:user_id]) }
        end
      rescue StandardError => e
        Discordrb::LOGGER.log_exception(e)
      end
    end

    # Send a birthday message to a channel.
    # @param guild [Integer] ID of the guild to get the channel for.
    # @param user [Integer] The ID of the user to mention in the message.
    def self.send_birthday_message(guild, user)
      channel = BOT.channel(guild.channel)

      begin
        channel&.send_message(RESPONSE[1] % user)
      rescue StandardError => e
        Discordrb::LOGGER.log_exception(e)
      end
    end

    # Add the birthday role to a member during their birthday.
    # @param guild [Integer] ID of the guild the role addition is for.
    # @param user [Integer] ID of the user the role addition is for.
    def self.add_birthday_role(guild, user)
      BOT.member(user, guild.id)&.add_role(guild.role)
    rescue StandardError => e
      Discordrb::LOGGER.log_exception(e)
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
          TASKS.at(now(user_[:birthdate], increment: false) + 86_400) do
            DB.where(user_id: user_[:user_id]).update(pending: false)
          end
        end

        # Check if the current date is no longer the birthdate.
        if Time.now.utc >= user[:birthdate].utc
          # Remove the role immediately if this is the case.
          schedule_role_removal(guild, user, time: :NOW)

          # Immediately set pending to false to avoid repeats.
          DB.where(user_id: user[:user_id]).update(pending: false)
        end
      end

      # loop through each guild for the user.
      user[:guilds].each do |guild|
        # Perform the actual check here.
        date_checker.call(Backend::Guild.new(guild), user)
      end

      # Schedule the task again recursively.
      schedule(user[:user_id]) if Time.now.utc >= user[:birthdate].utc
    end

    # Convert a birthdate to it's next occurance.
    def self.now(birthdate, increment: true)
      # Convert this to an array of values, e.g. [47, 20, 14, 9, 6, 2025, 1, 160, false, "UTC"]
      birthdate = birthdate.utc.to_a

      # Set the fifth index to the current year we're operating on.
      birthdate[5] = Time.now.year

      if increment
        # Increment the current year to the next one if desired.
        birthdate[5] += 1 if Time.utc(*birthdate) < Time.now.utc
      end

      # Create the new time with the current year.
      Time.utc(*birthdate)
    end
  end
end
