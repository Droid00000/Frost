# frozen_string_literal: true

module Frost
  # Easy way to handle pagination.
  class Paginator
    # Easy way to get index.
    attr_reader :index

    # Easy way to get buttons.
    attr_reader :buttons

    # Easy way to get house role.
    attr_reader :house_role
    alias role house_role

    # Easy way to get row count.
    attr_reader :second_row
    alias second_row? second_row

    # @param postgres [Sequel::Dataset]
    # @param data [Discordrb::Interaction]
    def initialize(data, postgres = nil)
      @hash = {}
      @index = []
      @mapped = []
      @buttons = []
      @second_row = []
      @house_role = postgres.cult(data)
      @custom_id = JSON.parse(data.custom_id)
      @total_pages = JSON.parse(data.custom_id)["chunk"][1]
      @current_page = JSON.parse(data.custom_id)["chunk"][0]
    end

    def house_forward
      make_pages

      @mapped = @hash[@current_page + 1]

      @second_row = @mapped.size > 15

      @custom_id["chunk"] = [@current_page + 1, @total_pages]

      @index = "Page #{@current_page + 1} of #{@total_pages}"

      @buttons = Discordrb::Webhooks::View.new do |components|
        components.row do |builder|
          @custom_id["type"] = "H-DOWN"
          builder.button(style: 4, label: EMBED[182], emoji: EMBED[189], custom_id: @custom_id.to_json)

          unless @current_page + 1 == @total_pages
            @custom_id["type"] = "H-UP"
            builder.button(style: 1, label: EMBED[183], emoji: EMBED[190], custom_id: @custom_id.to_json)
          end
        end
      end
    end

    def house_backward
      make_pages

      @mapped = @hash[@current_page - 1] unless @current_page == 1

      @custom_id["chunk"] = [@current_page - 1, @total_pages]

      @second_row = @mapped.size > 15

      @index = "Page #{@current_page - 1} of #{@total_pages}"

      @buttons = Discordrb::Webhooks::View.new do |components|
        components.row do |builder|
          unless @custom_id["chunk"][0] == 1
            @custom_id["type"] = "H-DOWN"
            builder.button(style: 4, label: EMBED[182], emoji: EMBED[189], custom_id: @custom_id.to_json)
          end

          unless @current_page - 1 == @total_pages
            @custom_id["type"] = "H-UP"
            builder.button(style: 1, label: EMBED[183], emoji: EMBED[190], custom_id: @custom_id.to_json)
          end
        end
      end
    end

    # Determine the chunk type.
    def paginate(*data)
      case @custom_id["type"]
      when "H-UP"
        house_forward; self
      when "M-UP"
        music_forward; self
      when "H-DOWN"
        house_backward; self
      when "M-DOWN"
        music_backward; self
      end
    end

    # Get the values to return.
    def map(index)
      return @mapped.first(15).join if index == 1

      return @mapped.last(15).join if index == 2
    end

    private

    # Convert members into their own hash.
    def make_pages
      house_role.members.each_with_index.map do |member, count|
        "**#{(count + 1).delimit}** — *#{member.display_name}*\n"
      end.each_slice(30).to_a.each_with_index do |members, count|
        @hash[count + 1] = members
      end
    end

    # Make a new ID.
    def self.id(*data)
      { type: data[0], chunk: [1, data[1].count] }.to_json
    end
  end
end
