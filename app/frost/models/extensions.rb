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
    #   @param reason [String] The reason the for defining the overwrite.
    #   @overload define_overwrite(thing, allow, deny)
    #   @param thing [User, Role] What to define an overwrite for.
    #   @param allow [#bits, Permissions, Integer] The permission sets that should receive an `allow` override.
    #   @param deny [#bits, Permissions, Integer] The permission sets that should receive a `deny` override.
    #   @param reason [String] The reason the for defining the overwrite.
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
        deny_bits = current_bits.deny.bits & ~(allow)

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

module Discordrb::Events
  # Monkey patch for application commands.
  class ApplicationCommandEvent
    # @param name [String] The name of the option.
    # @return [Emoji] Emojis sent in this interaction.
    def emojis(name)
      return nil unless @options[name]

      @bot.parse_mentions(@content).select { |e| e.is_a? Discordrb::Emoji }.first
    end

    # @param name [String] The name of the option.
    # @return [Member]
    def member(name)
      @resolved[:members][@options[name].to_i] || @resolved[:users][@options[name].to_i]
    end
  end
end

module Discordrb::Events
  # Monkey patch for select menus.
  class StringSelectEvent
    # @return [Emoji] Emojis sent in this interaction.
    def emoji
      return nil if @values.first.nil?

      @bot.parse_mentions(@values.first).select { |e| e.is_a? Discordrb::Emoji }.first
    end
  end
end
