# frozen_string_literal: true

module Birthdays
  # Primary manager that calls events for birthdays.
  module Orchestrator
    # The rufus scheduler instance called internally.
    @workers = Rufus::Scheduler.singleton

    # Mapping of actions that happen on publication.
    @actions = Hash.new { |hash, key| hash[key] = [] }

    # Register an action that should occur on publication.
    def self.listen(type, &block) = @actions[type] << block

    # Trigger the actions for each kind of task.
    def self.publish(member)
      @actions[:ON_PUBLISH].each { it.call(member) }

      @workers.in("24h") do
        @actions[:AFTER_PUBLISH].each { it.call(member) }
      end
    end

    # A login hook that's called once `:READY` is raised.
    def self.login
      @login ||= POSTGRES[:user_birthdays].all.each do |user|
        user[:pending] ? pending_user(user) : schedule(user)
      end
    end

    # Schedule a member from a given data hash or a user ID.
    # @param member [Integer, Hash] the ID of the member to schedule or a data hash.
    def self.schedule(member)
      # Fetch the special member we use.
      member = serialize_member(member)

      # Remove any pre-existing birthday jobs.
      @workers.jobs(tag: member.resolve_id).map(&:unschedule)

      # Create the birthday job here for the member.
      @workers.at(member.next_birthday, tag: member.resolve_id) { publish(member) }
    end

    # Handle a member that's already pending, e.g. was already scheduled.
    # @param member [Hash] the member to resolve from the data hash.
    def self.pending_user(member)
      member = User.new(member)

      # Re-schedule the removal for the day after.
      @workers.at(member.this_birthdate + 86_400, discard_past: false) do
        @actions[:AFTER_PUBLISH].each { it.call(member) }
      end
    end

    # un-schedule a member from a given data hash or a user ID.
    # @param member [Integer, Hash] the ID of the member to un-schedule or a data hash.
    def self.unschedule(member)
      @workers.jobs(tag: member.resolve_id).map(&:unschedule)
    end

    # Convert a member from a given data hash or user ID into a backened member.
    # @param member [Integer, Hash] the ID of the member to resolve or a data hash.
    # @return [Birthdays::Backend::Member] the member as a backend user model.
    def self.serialize_member(member)
      return User.new(member) unless member.respond_to?(:resolve_id)

      User.new(POSTGRES[:user_birthdays].where(user_id: member.resolve_id).first)
    end

    # The tasks that are peformed on the member's birthday.
    listen(:ON_PUBLISH) do |member|
      # Set the marker in the DB.
      member.pending = true

      # Add the birthday role and send a message for each server.
      member.guilds.each do |guild|
        [member.add_role(guild), member.send_message(guild)]
      end
    end

    # The tasks that are performed 24h after the member's birthday.
    listen(:AFTER_PUBLISH) do |member|
      # Reset the marker in the DB and recursively schedule the next birthday.
      [member.pending = false, schedule(member)]

      # Remove the birthday role from the member for each server.
      member.guilds.each { |guild| member.remove_role(guild) }
    end
  end
end
