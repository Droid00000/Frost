# frozen_string_literal: true

module Events
  # Represents an events user.
  class Member
    # @return [Integer, nil]
    attr_reader :role_id

    # @return [true, false, nil]
    attr_reader :permission
    alias permission? permission

    # @return [Sequel::Dataset]
    @@pg = POSTGRES[:event_users]

    # @!visibility private
    def initialize(data)
      @bot = data.bot
      model = find_user(data)
      @user_id = data.user.id
      @role_id = model[:role_id]
      @guild_id = data.server.id
      @permission = model[:permission]
    end

    # Check whether the role for this member exists.
    # @return [true, false] Whether or not the role for the member exists.
    def role? = !role_id.nil?

    # Check whether the record for this member exists.
    # @return [true, false] Whether or not the record for the member exists.
    def blank? = (permission != true)

    # Get all of the event roles the member has in this server.
    # @return [Array<Integer>] The IDs of all of the roles the member has in the server.
    def roles
      @roles ||= @@pg.where(user_id: @user_id, guild_id: @guild_id).select(:role_id).all.map { it[:role_id] }
    end

    private

    # @!visibility private
    def find_user(options)
      POSTGRES["SELECT * FROM event_user(?, ?)", options.user.resolve_id, options.options["role"]].first || {}
    end
  end
end
