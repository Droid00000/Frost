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
      @inner_flags = 0

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
end
