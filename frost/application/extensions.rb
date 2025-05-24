# frozen_string_literal: true

module Discordrb
  # Monkey patches to the server class.
  class Server
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
    def create_role(name: "new role", colour: 0, hoist: false, mentionable: false, permissions: 0, icon: nil, reason: nil)
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
    def update_role(role:, name: nil, colour: nil, icon: nil, secondary: nil, tertiary: nil, reason: nil)
      return nil if self.role(role).nil?

      colour = colour.combined if colour.respond_to?(:combined)

      colors = if colour || secondary || tertiary
                 self.role(role).colors.to_h.merge({
                   primary_color: colour&.to_i,
                   tertiary_color: tertiary&.to_i,
                   secondary_color: secondary&.to_i
                 }.compact)
               end

      API::Server.update_role(@bot.token, @id, role, name, colour, nil, nil, nil, icon, reason, colors)
    rescue StandardError
      API::Server.update_role(@bot.token, @id, role, name, colour, nil, nil, nil, nil, reason)
    end

    # Gets a role on this server based on its ID.
    # @param id [String, Integer] The role ID to look for.
    # @return [Role, nil] The role identified by the ID, or `nil` if it couldn't be found.
    def role(id)
      @roles.find { |e| e.id == id&.resolve_id }
    end
  end
end

module Discordrb
  # Monkey patches to the channel class.
  class Channel
    # Delete the last N messages on this channel.
    # @param amount [Integer] The amount of message history to consider for pruning. Must be a value between 2 and 100 (Discord limitation)
    # @param strict [true, false] Whether an error should be raised when a message is reached that is too old to be bulk
    #   deleted. If this is false only a warning message will be output to the console.
    # @param reason [String, nil] The reason for pruning
    # @raise [ArgumentError] if the amount of messages is not a value between 2 and 100
    # @yield [message] Yields each message in this channels history for filtering the messages to delete
    # @example Pruning messages from a specific user ID
    #   channel.prune(100) { |m| m.author.id == 83283213010599936 }
    # @return [Integer] The amount of messages that were successfully deleted
    # rubocop:disable Style/OptionalBooleanParameter
    def prune(amount, limit, strict = false, reason = nil, &)
      # rubocop:enable Style/OptionalBooleanParameter
      raise ArgumentError, "Can only delete between 1 and 100 messages!" unless amount.between?(1, 100)

      before = limit.options["before"]&.strip&.to_i unless limit.options["before"]&.to_i&.zero?

      after = limit.options["after"]&.strip&.to_i unless limit.options["after"]&.to_i&.zero?

      messages = history(amount, before, after).select(&).map(&:id)

      case messages.size
      when 0
        0
      when 1
        API::Channel.delete_message(@bot.token, @id, messages.first, reason)
        1
      else
        bulk_delete(messages, strict, reason)
      end
    end

    # rubocop:disable Style/OptionalBooleanParameter
    # Deletes a list of messages on this channel using bulk delete.
    def bulk_delete(ids, strict = false, reason = nil)
      # rubocop:enable Style/OptionalBooleanParameter
      min_snowflake = IDObject.synthesise(Time.now - TWO_WEEKS)

      ids.reject! do |e|
        next unless e < min_snowflake

        message = "Attempted to bulk_delete message #{e} which is too old (min = #{min_snowflake})"
        raise ArgumentError, message if strict

        true
      end

      API::Channel.bulk_delete_messages(@bot.token, @id, ids, reason) if ids.size >= 2
      ids.size
    end
  end
end

module Discordrb
  # Monkey patches to the emoji class.
  class Emoji
    # Returns a tempfile object of the emoji.
    # @return [File] a file.
    def file(static: true)
      link = if static || !animated
               API.emoji_icon_url(id, "png")
             else
               API.emoji_icon_url(id, "gif")
             end

      data = {
        url: link,
        method: :get,
        raw_response: true
      }

      RestClient::Request.execute(data).file
    rescue StandardError
      nil
    end
  end
end

module Discordrb
  # Monkey patch for message class.
  class Message
    # Check if any emoji were used in this message.
    # @return [true, false] whether or not any emoji were used.
    def emoji?
      !emoji&.empty?
    end

    # Check if this message contains a poll or not.
    # @return [true, false] whether this message has a poll or not.
    def poll?
      !@poll.nil?
    end

    # Check if this message contains any stickers or not.
    # @return [true, false] whether this message has any sticker or not.
    def stickers?
      !@stickers.empty?
    end

    # Check if someone was mentioned in a message.
    # @param [User, Role, Integer, String, #to_i]
    def mentions?(mention)
      mentions = (@role_mentions + @user_mentions)

      mentions.push(@server) if @mention_everyone

      mentions.map(&:resolve_id).include?(mention.resolve_id)
    end
  end
end

module Discordrb
  module Events
    # Monkey patch for application commands.
    class ApplicationCommandEvent
      # @param name [String] The name of the option.
      # @return [Emoji] Emojis sent in this interaction.
      def emoji(name)
        @options[name] ? @bot.parse_mentions(@options[name]).find { |e| e.is_a? Discordrb::Emoji } : nil
      end

      # @param name [String] The name of the option.
      # @return [Member]
      def member(name = nil)
        return @interaction.user if name.nil?

        @resolved[:members][@options[name].to_i] || @resolved[:users][@options[name].to_i]
      end

      def channels(name)
        @resolved[:channels][@options[name].to_i] || @bot.channel(@options[name].to_i)
      end
    end
  end
end

module Discordrb
  module Events
    # Monkey patch for select menus.
    class StringSelectEvent
      # @return [Emoji] Emojis sent in this interaction.
      def emoji(_ = nil)
        return nil if @values.first.nil?

        @bot.parse_mentions(@values[0]).find { |e| e.is_a? Discordrb::Emoji }
      end
    end
  end
end

module Discordrb
  module API
    module Server
      module_function

      def channel_name(token, channel_id, name, reason)
        Discordrb::API.request(
          :channels_cid,
          :channel_id,
          :patch,
          "#{Discordrb::API.api_base}/channels/#{channel_id}",
          { name: name }.to_json,
          Authorization: token,
          content_type: :json,
          "X-Audit-Log-Reason": reason
        )
      end

      # Create a role (parameters such as name and colour if not set can be set by update_role afterwards)
      # Permissions are the Discord defaults; allowed: invite creation, reading/sending messages,
      # sending TTS messages, embedding links, sending files, reading the history, mentioning everybody,
      # connecting to voice, speaking and voice activity (push-to-talk isn't mandatory)
      # https://discord.com/developers/docs/resources/guild#get-guild-roles
      def create_role(token, server_id, name, colour, _hoist, _mentionable, packed_permissions, icon = nil, reason = nil)
        data = { color: colour, name: name, hoist: false, mentionable: false, permissions: packed_permissions }

        if icon.respond_to?(:read)
          path_method = %i[original_filename path local_path].find { |meth| icon.respond_to?(meth) }
          mime = MIME::Types.type_for(icon.__send__(path_method)).first&.to_s || "image/jpeg"
          data[:icon] = "data:#{mime};base64,#{Base64.encode64(icon.read).strip}"
        end

        if icon.is_a?(String)
          data[:unicode_emoji] = icon
        end

        Discordrb::API.request(
          :guilds_sid_roles,
          server_id,
          :post,
          "#{Discordrb::API.api_base}/guilds/#{server_id}/roles",
          data.compact.to_json,
          Authorization: token,
          content_type: :json,
          "X-Audit-Log-Reason": reason
        )
      end

      # Update a role
      # Permissions are the Discord defaults; allowed: invite creation, reading/sending messages,
      # sending TTS messages, embedding links, sending files, reading the history, mentioning everybody,
      # connecting to voice, speaking and voice activity (push-to-talk isn't mandatory)
      # https://discord.com/developers/docs/resources/guild#batch-modify-guild-role
      # @param icon [:undef, File]
      def update_role(token, server_id, role_id, name, colour, _hoist, _mentionable, _packed_permissions, icon = :undef, reason = nil, colors = nil)
        data = { color: colour, name: name, colors: colors }.compact

        if icon.respond_to?(:read)
          path_method = %i[original_filename path local_path].find { |meth| icon.respond_to?(meth) }
          mime = MIME::Types.type_for(icon.__send__(path_method)).first&.to_s || "image/jpeg"
          icon_string = "data:#{mime};base64,#{Base64.encode64(icon.read).strip}"
          data.merge!(icon: icon_string, unicode_emoji: nil)
        end

        if icon.is_a?(String)
          data.merge!(icon: nil, unicode_emoji: icon)
        end

        if icon == :NULL
          data.merge!(unicode_emoji: nil, icon: nil)
        end

        if colors&.values&.include?(:NULL)
          data[:colors].each do |key, value|
            data[:colors][key] = nil if value == :NULL
          end
        end

        Discordrb::API.request(
          :guilds_sid_roles_rid,
          server_id,
          :patch,
          "#{Discordrb::API.api_base}/guilds/#{server_id}/roles/#{role_id}",
          data.to_json,
          Authorization: token,
          content_type: :json,
          "X-Audit-Log-Reason": reason
        )
      end
    end
  end
end

module Discordrb
  # Monkey patches to the bot class.
  class Bot
    # Deletes a role in a guild.
    # @param guild [Integer, String] An ID that uniquely identifies a guild.
    # @param id [Integer, String] An ID that uniquely identifies a role.
    def remove_guild_role(guild, id, reason)
      Discordrb::API::Server.delete_role(@token, guild, id, reason)
    rescue StandardError
      nil
    end
  end
end

module Discordrb
  # Monkey patches to the color class.
  class ColourRGB
    # Get the combined value of this color.
    def combined
      @combined.zero? ? 12 : @combined
    end
  end
end

# Monkey patches to the Gateway class.
module Discordrb
  # Standard Gateway class for DRB.
  class Gateway
    def members(server_id, members)
      members.each_slice(100).to_a.each do |chunk|
        packet = { guild_id: server_id, user_ids: chunk }

        sleep(2.5)

        begin
          send_packet(Opcodes::REQUEST_MEMBERS, packet)
        rescue StandardError
          retry
        end
      end
    end

    # Separate method to wait an ever-increasing amount of time before reconnecting after being disconnected in an
    # unexpected way
    def wait_for_reconnect
      # We disconnected in an unexpected way! Wait before reconnecting so we don't spam Discord's servers.
      LOGGER.debug("Attempting to reconnect in #{@falloff} seconds.")
      sleep @falloff

      # Calculate new falloff
      @falloff *= 1.5
      @falloff = 20 + (rand * 10) if @falloff > 30 # Cap the falloff at 30 seconds and then add some random jitter
    end
  end
end

# Monkey patches for integer.
class Integer
  # Comma delimit numbers.
  def delimit
    to_s.reverse.gsub(/(\d{3})(?=\d)/, '\1,').reverse
  end

  # Append an ordinal suffix to a number.
  def ordinal
    case self
    when 1, 21, 31
      "#{self}st"
    when 2, 22
      "#{self}nd"
    when 3, 23
      "#{self}rd"
    else
      "#{self}th"
    end
  end
end

# Monkey patches to the hash.
class Hash
  # Get a given key from a hash.
  def get(data)
    data.nil? ? nil : self[data.strip.downcase.gsub(/(?<=[^\,\.])\s+|\A\s+/, "_")&.to_sym]
  end
end
