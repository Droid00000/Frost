# frozen_string_literal: true

module Discordrb
  module API
    module FrostEndpoints
      # @!discord_api https://discord.com/developers/docs/resources/channel#modify-channel
      # @return [Hash<Symbol, Object>]
      def modify_channel(channel_id, name: :undef, reason: :undef)
        request Route[:PATCH, "/channels/#{channel_id}", channel_id],
                body: filter_undef({ name: name }),
                reason: reason
      end

      # @!discord_api https://discord.com/developers/docs/resources/guild#modify-guild-role
      # @return [Hash<Symbol, Object>]
      def modify_guild_role(guild_id, role_id, name: :undef, color: :undef, icon: :undef, reason: :undef)
        request Route[:PATCH, "/guilds/#{guild_id}/roles/#{role_id}", guild_id],
                body: filter_undef({ name: name, color: color, icon: icon }),
                reason: reason
      end

      # @!discord_api https://discord.com/developers/docs/resources/guild#delete-guild-role
      # @return [nil]
      def delete_guild_role(guild_id, role_id, reason: :undef)
        request Route[:DELETE, "/guilds/#{guild_id}/roles/#{role_id}", guild_id],
                reason: reason
      end

      # @!discord_api https://discord.com/developers/docs/resources/guild#get-guild-member
      # @return [Hash<Symbol, Object>]
      def get_guild_member(guild_id, user_id)
        request Route[:GET, "/guilds/#{guild_id}/members/#{user_id}", guild_id],
                params: :params
      end
    end
  end
end
