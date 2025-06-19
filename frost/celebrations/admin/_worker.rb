# frozen_string_literal: true

module Birthdays
  # Primary manager that calls events for birthdays.
  module Orchestrator
    # Mapping of actions that happen on publication.
    @actions = Hash.new { |hash, key| hash[key] = [] }

    # Register an action that should occur on publication.
    def self.listen(type, &block) = @actions[type] << block

    # Trigger the actions for each kind of task.
    def self.publish(member)
      @actions[:ON_PUBLISH].each { |sub| sub.call(member) }

      Rufus::Scheduler.singleton.in("24h") do
        @actions[:AFTER_PUBLISH].each { |sub| sub.call(member) }
      end
    end

    # Handles all scheduling related tasks for birthdays.
    class Scheduler
      # @return [Rufus::Scheduler]
      JOBS = Rufus::Scheduler.singleton

      # A login hook that's called once `:READY` is raised.
      def self.login
        @on ||= POSTGRES[:user_birthdays].all.each do |user|
          user[:pending] ? pending_user(user) : schedule(user)
        end
      end

      # Schedule a member from a given data hash or a user ID.
      # @param member [Integer, Hash] the ID of the member to schedule or a data hash.
      def self.schedule(member)
        # Fetch the special member we use.
        member = serialize_member(member)

        # Remove any pre-existing birthday jobs.
        JOBS.jobs(tag: member.resolve_id).map(&:unschedule)

        # Create the birthday job here for the member.
        JOBS.at(member.next_birthday, tag: member.resolve_id) { publish(member) }
      end

      # Convert a member from a given data hash or user ID into a backened member.
      # @param member [Integer, Hash] the ID of the member to resolve or a data hash.
      # @return [Birthdays::Backend::Member] the member as a backend user model.
      def self.serialize_member(member)
        return Backend::Member.new(member) unless member.is_a?(Integer)

        Backend::Member.new(POSTGRES[:user_birthdays].where(user_id: member).first)
      end
    end
  end
end
