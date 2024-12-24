# frozen_string_literal: true

module Discordrb
  # Monkey patches to the server class.
  class Server
    # If a server has hit the max role limit.
    def role_limit?
      roles.count == 250
    end

    # Creates a role on this server which can then be modified. It will be initialized
    # with the regular role defaults the client uses unless specified, i.e. name is "new role",
    # permissions are the default, colour is the default etc.
    # @param name [String] Name of the role to create
    # @param colour [Integer, ColourRGB, #combined] The roles colour
    # @param hoist [true, false]
    # @param mentionable [true, false]
    # @param permissions [Integer, Array<Symbol>, Permissions, #bits] The permissions to write to the new role.
    # @param icon [String, #read] A role icon for this role.
    # @param reason [String] The reason the for the creation of this role.
    # @return [Role] the created role.
    def create_role(name: 'new role', colour: 0, hoist: false, mentionable: false, permissions: 0, icon: nil,
                    reason: nil)
      colour = colour.combined if colour.respond_to?(:combined)

      begin
        response = API::Server.create_role(@bot.token, @id, name, colour, hoist, mentionable, permissions, icon, reason)
        role = Role.new(JSON.parse(response), @bot, self)
        @roles << role
        role
      rescue StandardError
        response = API::Server.create_role(@bot.token, @id, name, colour, hoist, mentionable, permissions, nil, reason)
        role = Role.new(JSON.parse(response), @bot, self)
        @roles << role
        role
      end
    end

    # Updates a role on this server.
    # @param name [String] New name of the role.
    # @param colour [Integer, ColourRGB, #combined] The roles colour.
    # @param icon [String, #read] A role icon for this role.
    # @param reason [String] The reason for updating this role.
    def update_role(role:, name:, colour:, icon:, reason:)
      return nil if self.role(role).nil?

      colour = colour.combined if colour.respond_to?(:combined)

      API::Server.update_role(@bot.token, @id, role, name, colour, nil, nil, nil, icon, reason)
    rescue StandardError
      API::Server.update_role(@bot.token, @id, role, name, colour, nil, nil, nil, nil, reason)
    end

    # Bans multiple users at once.
    # @param users [Array<Integer>] An array of snowflake ID's to ban.
    # @param message_seconds [Integer] The number of seconds to delete messages from.
    # @param reason [String] The reason for banning these users.
    def bulk_ban(users, message_seconds, reason)
      messages = message_seconds ? message_seconds * 86_400 : 0
      users = users.map { |user| user&.to_i }
      response = JSON.parse(API::Server.bulk_ban(@bot.token, @id, users, messages, reason))
      response['banned_users']
    end
  end
end

module Discordrb
  # Monkey patches to the channel class.
  class Channel
    # The same as define overwrite except it modifies the overwrites in place.
    # @param thing [Overwrite] an Overwrite object to apply to this channel
    # @param reason [String] The reason the for defining the overwrite.
    # @overload define_overwrite(thing, allow, deny)
    # @param thing [User, Role] What to define an overwrite for.
    # @param allow [#bits, Permissions, Integer] The permission sets that should receive an `allow` override.
    # @param deny [#bits, Permissions, Integer] The permission sets that should receive a `deny` override.
    # @param reason [String] The reason the for defining the overwrite.
    def produce_overwrite(thing, allow: 0, deny: 0, reason: nil)
      unless thing.is_a? Overwrite
        allow_bits = allow.respond_to?(:bits) ? allow.bits : allow
        deny_bits = deny.respond_to?(:bits) ? deny.bits : deny

        thing = Overwrite.new thing, allow: allow_bits, deny: deny_bits
      end

      current_bits = overwrites(:role).find { |o| o.id == @server_id }

      computed_allow = thing.allow.bits | current_bits.allow.bits
      computed_deny = thing.deny.bits | current_bits.deny.bits

      API::Channel.update_permission(@bot.token, @id, thing.id, computed_allow, computed_deny, thing.type, reason)
    end

    # The same as define overwrite except it modifies the overwrites in place.
    # @param thing [Overwrite] an Overwrite object to apply to this channel
    # @param reason [String] The reason the for defining the overwrite.
    # @overload define_overwrite(thing, allow, deny)
    # @param thing [User, Role] What to define an overwrite for.
    # @param allow [#bits, Permissions, Integer] The permission sets that should receive an `allow` override.
    # @param deny [#bits, Permissions, Integer] The permission sets that should receive a `deny` override.
    # @param reason [String] The reason the for defining the overwrite.
    def destroy_overwrite(thing, allow: 0, deny: 0, reason: nil)
      current_bits = overwrites(:role).find { |o| o.id == @server_id }
      unless thing.is_a? Overwrite
        allow_bits = allow.respond_to?(:bits) ? allow.bits : allow
        deny_bits = current_bits.deny.bits & ~allow

        thing = Overwrite.new thing, allow: allow_bits, deny: deny_bits
      end

      computed_allow = current_bits.allow.bits

      API::Channel.update_permission(@bot.token, @id, thing.id, computed_allow, thing.deny.bits, thing.type, reason)
    end
  end
end

module Discordrb
  # Monkey patches to the emoji class.
  class Emoji
    # Returns a tempfile object of the emoji.
    # @return [File] a file.
    def file
      gif_url = "#{API.cdn_url}/emojis/#{@id}.gif"
      png_url = "#{API.cdn_url}/emojis/#{@id}.png"
      response = Faraday.get(gif_url)
      chosen_url = response.status == 415 ? png_url : gif_url
      file = Tempfile.new(Time.now.to_s)
      file.binmode
      file.write(Faraday.get(chosen_url).body)
      file.rewind
      file
    end

    # Returns a tempfile object of the emoji.
    # @return [File] a file.
    def static_file
      file = Tempfile.new(Time.now.to_s)
      file.binmode
      file.write(Faraday.get("#{API.cdn_url}/emojis/#{@id}.png").body)
      file.rewind
      file
    end
  end
end

module Discordrb
  # Monkey patch for member class.
  class Member
    # @return [Integer] Position of the highest role this member has.
    def hierarchy
      roles.max_by(&:position).position
    end
  end
end

module Discordrb
  # Monkey patch for message class.
  class Message
    # @return [Array<Emoji>] the emotes that were used/mentioned in this message.
    def emoji
      return nil if @content.nil?
      return @emoji unless @emoji.empty?

      @emoji = @bot.parse_mentions(@content).select { |el| el.is_a? Discordrb::Emoji }
    end

    # Check if any emoji were used in this message.
    # @return [true, false] whether or not any emoji were used.
    def emoji?
      !emoji&.empty?
    end
  end
end

module Discordrb
  module Events
    # Monkey patch for application commands.
    class ApplicationCommandEvent
      # @param name [String] The name of the option.
      # @return [Emoji] Emojis sent in this interaction.
      def emojis(name)
        return nil unless @options[name]

        @bot.parse_mentions(@content).find { |e| e.is_a? Discordrb::Emoji }
      end

      # @param name [String] The name of the option.
      # @return [Member]
      def member(name)
        @resolved[:members][@options[name].to_i] || @resolved[:users][@options[name].to_i]
      end
    end
  end
end

module Discordrb
  module Events
    # Monkey patch for select menus.
    class StringSelectEvent
      # @return [Emoji] Emojis sent in this interaction.
      def emoji
        return nil if @values.first.nil?

        @bot.parse_mentions(@values.first).find { |e| e.is_a? Discordrb::Emoji }
      end
    end
  end
end

module Discordrb
  module API
    module Server
      module_function

      # Gets the premium status of a booster.
      # @param token [String] bot token to make the request.
      # @param server_id [Integer] ID of the guild to request.
      # @param user_id [Integer] ID od the member to request.
      def resolve_booster(token, server_id, user_id)
        !JSON.parse(Discordrb::API.request(
                      :guilds_sid_members_uid,
                      server_id,
                      :get,
                      "#{Discordrb::API.api_base}/guilds/#{server_id}/members/#{user_id}",
                      Authorization: token
                    ))['premium_since'].nil?
      rescue StandardError
        false
      end

      # Create a role (parameters such as name and colour if not set can be set by update_role afterwards)
      # Permissions are the Discord defaults; allowed: invite creation, reading/sending messages,
      # sending TTS messages, embedding links, sending files, reading the history, mentioning everybody,
      # connecting to voice, speaking and voice activity (push-to-talk isn't mandatory)
      # https://discord.com/developers/docs/resources/guild#get-guild-roles
      def create_role(token, server_id, name, colour, hoist, mentionable, packed_permissions, icon, reason = nil)
        if icon
          path_method = %i[original_filename path local_path].find { |meth| icon.respond_to?(meth) }

          unless path_method
            raise ArgumentError,
                  'File object must respond to original_filename, path, or local path.'
          end
          raise ArgumentError, 'File must respond to read' unless icon.respond_to? :read

          mime_type = MIME::Types.type_for(icon.__send__(path_method)).first&.to_s || 'image/jpeg'
          image = "data:#{mime_type};base64,#{Base64.encode64(icon.read).strip}"
        else
          image = nil
        end

        Discordrb::API.request(
          :guilds_sid_roles,
          server_id,
          :post,
          "#{Discordrb::API.api_base}/guilds/#{server_id}/roles",
          { color: colour, name: name, hoist: hoist, mentionable: mentionable, permissions: packed_permissions,
            icon: image }.compact.to_json,
          Authorization: token,
          content_type: :json,
          'X-Audit-Log-Reason': reason
        )
      end

      # Update a role
      # Permissions are the Discord defaults; allowed: invite creation, reading/sending messages,
      # sending TTS messages, embedding links, sending files, reading the history, mentioning everybody,
      # connecting to voice, speaking and voice activity (push-to-talk isn't mandatory)
      # https://discord.com/developers/docs/resources/guild#batch-modify-guild-role
      # @param icon [:undef, File]
      def update_role(token, server_id, role_id, name, colour, hoist, mentionable, packed_permissions, icon = :undef,
                      reason = nil)
        data = { color: colour, name: name, hoist: hoist, mentionable: mentionable,
                 permissions: packed_permissions }

        if icon != :undef && icon
          path_method = %i[original_filename path local_path].find { |meth| icon.respond_to?(meth) }

          unless path_method
            raise ArgumentError,
                  'File object must respond to original_filename, path, or local path.'
          end
          raise ArgumentError, 'File must respond to read' unless icon.respond_to? :read

          mime_type = MIME::Types.type_for(icon.__send__(path_method)).first&.to_s || 'image/jpeg'
          data[:icon] = "data:#{mime_type};base64,#{Base64.encode64(icon.read).strip}"
        elsif icon.nil?
          data[:icon] = nil
        end

        Discordrb::API.request(
          :guilds_sid_roles_rid,
          server_id,
          :patch,
          "#{Discordrb::API.api_base}/guilds/#{server_id}/roles/#{role_id}",
          data.compact.to_json,
          Authorization: token,
          content_type: :json,
          'X-Audit-Log-Reason': reason
        )
      end

      # Bans multiple users in a guild at once.
      # https://discord.com/developers/docs/resources/guild#bulk-guild-ban
      def bulk_ban(token, server_id, user_ids, delete_message_seconds, reason)
        Discordrb::API.request(
          :guilds_sid_bans_uids,
          server_id,
          :post,
          "#{Discordrb::API.api_base}/guilds/#{server_id}/bulk-ban",
          { user_ids: user_ids, delete_message_seconds: delete_message_seconds }.to_json,
          content_type: :json,
          Authorization: token,
          'X-Audit-Log-Reason': reason
        )
      end
    end
  end
end

module Discordrb
  # Monkey patches to the bot class.
  class Bot
    # Calculates the intents payload.
    def calculate_intents(intents)
      intents = [intents] unless intents.is_a? Array

      intents.reduce(0) do |sum, intent|
        case intent
        when Symbol
          if INTENTS[intent]
            sum | INTENTS[intent]
          else
            LOGGER.warn("Unknown intent: #{intent}")
            sum
          end
        when Integer
          sum | intent
        else
          LOGGER.warn("Invalid intent: #{intent}")
          sum
        end
      end
    end

    # Updates presence status.
    # @param status [String] The status the bot should show up as. Can be `online`, `dnd`, `idle`, or `invisible`
    # @param activity [String, nil] The name of the activity to be played/watched/listened to/stream name on the stream.
    # @param url [String, nil] The Twitch URL to display as a stream. nil for no stream.
    # @param since [Integer] When this status was set.
    # @param afk [true, false] Whether the bot is AFK.
    # @param activity_type [Integer] The type of activity status to display.
    # Can be 0 (Playing), 1 (Streaming), 2 (Listening), 3 (Watching), or 5 (Competing).
    # @see Gateway#send_status_update
    def update_status(status, name, url = nil, since = 0, activity_type = 0)
      data = { name: name, type: 4, state: name }.compact

      @status = status&.downcase if status

      @gateway.send_status_update(@status, since, data, false)
    end
  end
end
