# frozen_string_literal: true

module Frost
  # Easy way to handle pagination.
  class Paginator
    # Easy way to get members.
    attr_reader :set
    alias members set

    # Easy way to access the DB.
    attr_reader :postgres
    alias pg postgres

    # Easy way to get buttons.
    attr_reader :components

    # Easy way to access the interaction.
    attr_reader :interation

    # Easy way to get row count.
    attr_reader :second_row
    alias second_row? second_row

    # @param postgres [Sequel::Dataset]
    # @param data [Discordrb::Interaction]
    def initialize(data, postgres = nil)
      @set = nil
      @mapped = [[], []]
      @components = nil
      @second_row = nil
      @interaction = data
      @postgres = postgres
      paginate((@id = JSON.parse(data.custom_id, symbolize_names: true)))
    end

    def house_forward
      if @id[:chunk][0] == @id[:chunk][1] && (@id[:chunk][0] != 0 && @id[:chunk][1] != 0)
        @id = { type: "H-DOWN", chunk: @id[:chunk] }
      end

      if count_chunks(@postgres.cult(@interaction)) != @id[:chunk][1]
        @id[:chunk] = [@id[:chunk][0], count_chunks(@postgres.cult(@interaction))]
      end

      if count_chunks(@postgres.cult(@interaction)) >= @id[:chunk][1]
        @id = { type: "H-DOWN", chunk: @id[:chunk] }
      end

      chunks = make_chunks(@postgres.cult(@interaction))

      @set = [chunks[@id[:chunk][0]], chunks.index(@id[:chunk][0] + 1)]

      @second = chunks.index([@id[:chunk][0]]) != chunks.length - 1

      @id[:chunk] = [@id[:chunk][0] + 1, count_chunks(@postgres.cult(@interaction))]

      if (@id[:chunk][0] == @id[:chunk][1]) && (@id[:chunk][0] != 1)
        @id = { type: "H-DOWN", chunk: @id[:chunk] }
      end

      return if @id[:chunk][0] == 0 && @id[:chunk][0] == @id[:chunk][1]

      @components = Discordrb::Webhooks::View.new do |consumer|
        consumer.row do |builder|
          if @id[:chunk][0] != 0
            builder.button(style: 4, label: EMBED[182], emoji: EMBED[189], custom_id: "1 #{@id}")
          end

          if @id[:chunk][0] != @id[:chunk][1]
            builder.button(style: 1, label: EMBED[183], emoji: EMBED[190], custom_id: "2 #{@id}")
          end
        end
      end
    end

    # Determine the chunk type.
    def paginate(*data)
      case @id[:type]
      when "H-UP"
        house_forward
      when "M-UP"
        music_forward
      when "H-DOWN"
        house_backward
      when "M-DOWN"
        music_backward
      end
    end

    def map_first
      @set[0].each_with_index do |user, count|
        @mapped[0] << "**#{count + 1}** — *#{user.display_name}*\n"
      end

      @mapped[0].join
    end

    def map_second
      @set[1].each_with_index do |user, count|
        @mapped[1] << "**#{count + 1}** — *#{user.display_name}*\n"
      end

      @mapped[1].join
    end

    private

    # Count the total number of chunks.
    def count_chunks(data)
      data.members.each_slice(15).to_a.count
    end

    # Make members into their own little chunks.
    def make_chunks(data)
      data.members.each_slice(15).to_a
    end

    def self.consume(*data)
      { type: data[0], chunk: [data[1], data[2]] }
    end
  end
end
