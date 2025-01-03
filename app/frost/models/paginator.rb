# frozen_string_literal: true

module Frost
  # Easy way to handle pagination.
  class Paginator
    # Easy way to access the DB.
    attr_reader :postgres
    alias pg postgres

    # Easy way to access the interaction.
    attr_reader :interation

    # @param postgres [Sequel::Dataset]
    # @param data [Discordrb::Interaction]
    def initialize(postgres, data)
      @interaction = data
      @postgres = postgres
      @id = JSON.parse(data.custom_id)
    end

    # Determine the chunk type.
    def paginate
      case @id["type"]
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
  end
end

# { type: "H-UP", chunk: [20, 2500] }
