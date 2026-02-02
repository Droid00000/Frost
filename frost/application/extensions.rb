# frozen_string_literal: true

module Discordrb
  # Monkey patches to the server class.
  class Server
    # Updates a role on this server.
    # @param name [String] New name of the role.
    # @param colors [Hash] The roles colour.
    # @param display_icon [String, #read] A role icon for this role.
    # @param reason [String] The audit log reason for updating this role.
    def update_role(role:, name: :undef, colors: :undef, display_icon: :undef, reason: nil)
      return unless (role = self.role(role))

      icon = :undef
      unicode_emoji = :undef
      if display_icon.nil?
        icon = nil
        unicode_emoji = nil
      elsif display_icon.is_a?(String)
        unicode_emoji = display_icon
        icon = nil
      elsif display_icon != :undef
        icon = display_icon
        unicode_emoji = nil
      end
      API::Server.update_role(@bot.token, @id, role.id, name || :undef, :undef, :undef, :undef, :undef, reason, icon, unicode_emoji, colors)
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
  end
end

module Discordrb
  # Monkey patches to the emoji class.
  class Emoji
    # Returns a string IO object of the emoji.
    # @return [StringIO] a temporary string with the file's bytes.
    def file(static: true)
      link = if static || !animated
               API.emoji_icon_url(id, "png")
             else
               API.emoji_icon_url(id, "gif")
             end

      io = StringIO.new(RestClient.get(link).body, 'rb')
      io.tap { it.define_singleton_method(:path) { 'emoji.png' } }
    rescue StandardError
      nil
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
        @options[name] ? @bot.parse_mentions(@options[name]).find { it.is_a?(Discordrb::Emoji) } : nil
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
      return nil unless profile.on(guild)&.permission?(:manage_roles)

      Discordrb::API::Server.delete_role(@token, guild, id, reason) rescue nil
    end
  end
end

# Monkey patches to the Gateway class.
module Discordrb
  # Standard Gateway class for Discordrb.
  class Gateway
    # Request members over the gateway.
    # @param server_id [Integer, String] ID of the server to request members for.
    # @param members [Array<Integer, String>] Array of user IDs to request.
    def members(server_id, members)
      members.each_slice(100).to_a.each do |chunk|
        packet = { guild_id: server_id, user_ids: chunk }

        send_packet(Opcodes::REQUEST_MEMBERS, packet) rescue retry

        # There isn't any rate-limiting built in, so just sleep a fixed time.
        sleep(3)
      end
    end

    # Separate method to wait an ever-increasing amount of time before reconnecting after being disconnected in an
    # unexpected way
    def wait_for_reconnect
      # We disconnected in an unexpected way! Wait before reconnecting so we don't spam Discord's servers.
      LOGGER.debug("Attempting to reconnect in #{@falloff} seconds.")
      sleep @falloff

      # Calculate new falloff
      @falloff *= 1.2
      @falloff = 30 + (rand * 10) if @falloff > 60 # Cap the falloff at 60 seconds and then add some random jitter
    end
  end
end

# Monkey patches for integer.
class Integer
  # Comma delimit numbers.
  def delimit
    to_s.reverse.scan(/\d{3}|.+/).join(',').reverse
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
  def pull(data)
    self[data.downcase.gsub(/[^a-z]+/, '_').gsub(/^_|_$/, '').to_sym] if data
  end
end
