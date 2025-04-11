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
    def update_role(role:, name: nil, colour: nil, icon: nil, primary: nil, secondary: nil, terneray: nil, reason: nil)
      return nil if self.role(role).nil?

      colour = colour.combined if colour.respond_to?(:combined)

      colors = if primary || secondary || ternerary
                 self.role(role).colors.to_h.merge({
                   primary: primary,
                   secondary: secondary,
                   terneray: terneray
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
      id = id&.resolve_id
      @roles.find { |e| e.id == id }
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
    def prune(amount, limit, strict = false, reason = nil, &block)
      raise ArgumentError, "Can only delete between 1 and 100 messages!" unless amount.between?(1, 100)

      before = limit.options["before"].strip.to_i unless limit.options["before"]&.to_i&.zero?

      after = limit.options["after"].strip.to_i unless limit.options["after"]&.to_i&.zero?

      messages =
        if block && limit
          history(amount, before, after).select(&block).map(&:id)
        elsif block && !limit
          history(amount).select(&block).map(&:id)
        else
          history_ids(amount)
        end

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

    # Deletes a list of messages on this channel using bulk delete.
    def bulk_delete(ids, strict = false, reason = nil)
      min_snowflake = IDObject.synthesise(Time.now - TWO_WEEKS)

      ids.reject! do |e|
        next unless e < min_snowflake

        message = "Attempted to bulk_delete message #{e} which is too old (min = #{min_snowflake})"
        raise ArgumentError, message if strict

        true
      end

      API::Channel.bulk_delete_messages(@bot.token, @id, ids, reason) if ids >= 2
      ids.size
    end
  end
end

module Discordrb
  # Monkey patches to the emoji class.
  class Emoji
    # Returns a tempfile object of the emoji.
    # @return [File] a file.
    def file(static: false)
      gif_url = "#{API.cdn_url}/emojis/#{@id}.gif"
      png_url = "#{API.cdn_url}/emojis/#{@id}.png"
      response = Faraday.get(gif_url)
      chosen_url = response.status == 415 ? png_url : gif_url
      chosen_url = png_url if static == true
      file = Tempfile.new(Time.now.to_s)
      file.binmode
      file.write(Faraday.get(chosen_url).body)
      file.rewind
      file
    end
  end
end

module Discordrb
  # Monkey patch for message class.
  class Message
    # @return [Array<Emoji>] the emotes that were used/mentioned in this message.
    def emoji
      @content.nil? ? nil : @bot.parse_mentions(@content).select { |el| el.is_a? Discordrb::Emoji }
    end

    # Check if any emoji were used in this message.
    # @return [true, false] whether or not any emoji were used.
    def emoji?
      !emoji&.empty?
    end

    # Check if someone was mentioned in a message.
    # @param [User, Role, Integer, String, #to_i]
    def mentions?(mention)
      mentions = (@role_mentions + @user_mentions)

      mentions << @server if @mention_everyone

      mentions.map(&:resolve_id).any?(mention.resolve_id)
    end

    def poll?
      !@poll.nil?
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
        @options[name] ? @bot.parse_mentions(@options[name]).find { |e| e.is_a? Discordrb::Emoji } : nil
      end

      # @param name [String] The name of the option.
      # @return [Member]
      def member(name)
        @resolved[:members][@options[name].to_i] || @resolved[:users][@options[name].to_i]
      end

      def channels(name)
        @resolved[:channels][@options[name].to_i]
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

        @bot.parse_mentions(@values[0]).find { |e| e.is_a? Discordrb::Emoji }
      end
    end
  end
end

module Discordrb
  module API
    module Server
      module_function

      def channel_name(token, id, name, reason)
        Discordrb::API.request(
          :channels_cid,
          :channel_id,
          :patch,
          "#{Discordrb::API.api_base}/channels/#{id}",
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
      def create_role(token, server_id, name, colour, _hoist, _mentionable, packed_permissions, icon, reason = nil, emoji: nil)
        if !icon.is_a?(String) && icon
          path_method = %i[original_filename path local_path].find { |meth| icon.respond_to?(meth) }

          mime = MIME::Types.type_for(icon.__send__(path_method)).first&.to_s || "image/jpeg"
          icon = "data:#{mime};base64,#{Base64.encode64(icon.read).strip}"
        elsif icon.is_a?(String)
          emoji = icon
        else
          icon = nil
        end

        Discordrb::API.request(
          :guilds_sid_roles,
          server_id,
          :post,
          "#{Discordrb::API.api_base}/guilds/#{server_id}/roles",
          { color: colour, name: name, hoist: false, mentionable: nil, permissions: packed_permissions, icon: icon, unicode_emoji: emoji }.compact.to_json,
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
      def update_role(token, server_id, role_id, name, colour, _hoist, _mentionable, _packed_permissions, icon = :undef, reason = nil, colors = nil, emoji: nil)
        if !icon.is_a?(String) && icon != :undef && icon
          path_method = %i[original_filename path local_path].find { |meth| icon.respond_to?(meth) }

          mime = MIME::Types.type_for(icon.__send__(path_method)).first&.to_s || "image/jpeg"
          icon = "data:#{mime};base64,#{Base64.encode64(icon.read).strip}"
        elsif icon.is_a?(String)
          emoji = icon
        else
          icon = nil
        end

        Discordrb::API.request(
          :guilds_sid_roles_rid,
          server_id,
          :patch,
          "#{Discordrb::API.api_base}/guilds/#{server_id}/roles/#{role_id}",
          { color: colour, name: name, icon: icon, unicode_emoji: emoji, colors: colors }.compact.to_json,
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
    def remove_guild_role(guild, id)
      Discordrb::API::Server.delete_role(@token, guild, id)
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
      if members.size == 1
        data = {
          guild_id: server_id,
          user_ids: members.first
        }.compact
        sleep(1)
        send_packet(Opcodes::REQUEST_MEMBERS, data)
      else
        members.each_slice(100).to_a.each do |chunk|
          data = {
            guild_id: server_id,
            user_ids: chunk
          }.compact
          sleep(1)
          send_packet(Opcodes::REQUEST_MEMBERS, data)
        end
      end
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
    self[(data.gsub(/([a-z0-9])([A-Z])/, '\1_\2')&.downcase&.to_sym)] unless data
  end
end
