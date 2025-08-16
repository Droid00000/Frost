# frozen_string_literal: true

module Moderation
  # Purge messages.
  def self.purge(data)
    unless data.server.bot.permission?(:manage_messages, data.channel)
      data.edit_response(content: RESPONSE[1])
      return
    end

    unless data.server.bot.permission?(:read_messages, data.channel)
      data.edit_response(content: RESPONSE[2])
      return
    end

    count = 0

    ([1] * data.options["amount"]).each_slice(100) do |chunk|
      count += data.channel.prune(chunk.sum, data) do |logic|
        pass = []

        if data.options["contains"]
          pass << logic.content&.include?(data.options["contains"])
        end

        if data.options["member"]
          pass << (logic.author.id == data.options["member"].to_i)
        end

        if data.options["prefix"]
          pass << logic.text&.start_with?(data.options["prefix"])
        end

        if data.options["suffix"]
          pass << logic.text&.end_with?(data.options["suffix"])
        end

        if data.options["mentions"]
          pass << logic.mentions?(data.options["mentions"])
        end

        if data.options["robot"]
          pass << logic.author.bot_account?
        end

        if data.options["files"]
          pass << logic.attachments.any?
        end

        if data.options["reaction"]
          pass << logic.reactions.any?
        end

        if data.options["embeds"]
          pass << logic.embeds.any?
        end

        if data.options["emoji"]
          pass << logic.emoji?
        end

        pass.all?
      end
    end

    data.edit_response(content: plural(RESPONSE[5], count))
  end
end
