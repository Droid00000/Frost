# frozen_string_literal: true

module Moderation
  # Purge messages.
  def self.purge(data)
    unless data.server.bot.permission?(:manage_messages, data.channel)
      data.edit_response(content: RESPONSE[67])
      return
    end

    count, pass, limit = 0, [], data.options["after"]

    ([1] * data.options["amount"]).each_slice(100) do |chunk|
      count += data.channel.prune(chunk.sum, limit) do |logic|
        pass.clear unless pass.empty?

        if data.options["contains"]
          pass << logic.content&.include?(data.options["contains"])
        end

        if data.options["prefix"]
          pass << logic.text&.start_with?(data.options["prefix"])
        end

        if data.options["suffix"]
          pass << logic.text&.end_with?(data.options["suffix"])
        end

        if data.options["member"]
          pass << logic.user.id == data.member("member").id
        end

        if data.options["files"]
          pass << logic.attachments.any?
        end

        if data.options["reactions"]
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

    data.edit_response(content: format(RESPONSE[68], count))
  end
end
