# frozen_string_literal: true

module Celebrations
  # Birthday settings for a guild.
  class Guild
    # @return [Integer] the ID of the guild on Discord.
    attr_reader :id

    # @return [Integer] the ID of the birthday role in the guild.
    attr_reader :role_id

    # @return [Integer] the ID of the user who enabled birthday perks.
    attr_reader :setup_by

    # @return [Integer] the unix time at when birthday perks were enanbled.
    attr_reader :setup_at

    # @return [Integer] the ID of the birthday announcement channel in the guild.
    attr_reader :channel_id

    # @!visibility private
    def initialize(new_state)
      update_state(new_state)
    end

    #  ####  ###   ## ######## ######## ########  ##    ##    ###    ##        ######
    #   ##   ###   ##    ##    ##       ##     ## ###   ##   ## ##   ##       ##    ##
    #   ##   ####  ##    ##    ##       ##     ## ####  ##  ##   ##  ##       ##
    #   ##   ## ## ##    ##    ######   ########  ## ## ## ##     ## ##        ######
    #   ##   ##  ####    ##    ##       ##   ##   ##  #### ######### ##             ##
    #   ##   ##   ###    ##    ##       ##    ##  ##   ### ##     ## ##       ##    ##
    #  ####  ##    ##    ##    ######## ##     ## ##    ## ##     ## ########  ######

    # @!visibility private
    def update_state(new_state)
      @id = new_state[:guild_id]
      @role_id = new_state[:role_id]
      @setup_by = new_state[:setup_by]
      @setup_at = new_state[:setup_at]
      @channel_id = new_state[:channel_id]
    end
  end

  # A user who has registered their birthdate.
  class User
    # @return [Integer] the ID of the user on Discord.
    attr_reader :id

    # @!visibility private
    def initialize(new_state)
      update_state(new_state)
    end

    # Modify the properties of the user.
    # @param pending [true, false] Whether or not the user's
    #   birthday is ongoing and should be checked when recovering
    #   from a crash or unexpected shutdown.
    def modify(pending:)
      USER.where(user_id: @id).update(pending: pending)
    end

    # Get the birthdate of a user in the current year.
    # @return [Time] The birthdate of the user in the current year.
    #   This may point to a date that has already passed.
    def birthdate
      Time.utc(*@birthdate.to_a.tap { it[5] = Time.now.utc.year })
    end

    # Get the next occurence of the user's birthdate.
    # @return [Time] The next occurence of the user's birthdate. This
    #   should almost always point to a date in the future.
    def next_birthdate
      Time.now.utc > birthdate ? (birthdate + 31_536_000) : birthdate
    end

    # Get the guilds that a user has synced themselves to.
    # @return [Array<Celebrations::Guild>] The synced guilds for the user.
    def guilds
      ids = USERS.where(user_id: @id).first&.[](:guilds)&.tap(&:uniq!)

      ids&.filter_map { BOT.celebrations_cache.fetch_guild(it) } || []
    end

    # @!visibility private
    def update_state(new_state)
      @id = new_state[:user_id]
      @birthdate = new_state[:birthdate]
    end
  end
end
