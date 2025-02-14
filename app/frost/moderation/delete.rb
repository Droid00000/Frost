# frozen_string_literal: true

module Moderation
  # Purge messages.
  def self.purge(data)
    unless data.server.bot.permission?(:manage_messages, data.channel)
      data.edit_response(content: RESPONSE[67])
      return
    end

    count, pass = 0, [true]

    ([1] * data.options["amount"]).each_slice(100) do |chunk|
      count += data.channel.prune(chunk.sum) do |logic|
        pass = pass[true] if pass.any? && pass.size > 1

        if data.options["contains"]
          pass << logic.content&.include?(data.options["contains"])
        end

        if data.options["prefix"]
          pass << logic.content&.start_with?(data.options["prefix"])
        end

        if data.options["suffix"]
          pass << logic.content&.end_with?(data.options["suffix"])
        end

        if data.options["member"]
          pass << logic.user == data.member("member")
        end

        if data.options["limit"]
          pass << logic.id <= data.options["limit"]
        end

        if data.options["robot"]
          pass << logic.user.bot_account?
        end

        if data.options["files"]
          pass << logic.attachments.any?
        end

        if data.options["embeds"]
          pass << logic.embeds.any?
        end

        if data.options["emojis"]
          pass << logic.emoji?
        end

        pass.all?
      end
    end

    data.edit_response(content: format(RESPONSE[68], count))
  end
end
