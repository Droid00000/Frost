# frozen_string_literal: true

module Moderation
  # RoboMod for a guild.
  class Guild
    # @return [Integer] the ID of the guild on Discord.
    attr_reader :id

    # @return [Integer] the ID of the alert channel in the guild.
    attr_reader :channel_id

    # @return [Array<Integer>] the IDs of the exempt roles in the guild.
    attr_reader :exempt_roles

    # @return [Array<Integer>] the IDs of the exempt channels in the guild.
    attr_reader :exempt_channels

    # @return [Integer] the timeout duration (in seconds) for flagged members.
    attr_reader :timeout_duration

    # @!visibility private
    def initialize(new_state)
      @inner_flags = 0
      @users_lock = Mutex.new

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
      @channel_id = new_state[:channel_id]
      @exempt_roles = new_state[:exempt_roles]
      @exempt_channels = new_state[:exempt_channels]
      @timeout_duration = new_state[:timeout_seconds]
    end
  end
end
