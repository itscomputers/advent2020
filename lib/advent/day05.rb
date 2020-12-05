require 'advent/day'

module Advent
  class Day05 < Advent::Day
    DAY = "05"

    def self.sanitized_input
      raw_input.split("\n")
    end

    def initialize(input)
      @seats = input.map { |string| Seat.new(string) }
    end

    def solve(part:)
      case part
      when 1 then max_seat_id
      when 2 then my_seat_id
      end
    end

    def ordered_seat_ids
      @ordered_seat_ids ||= @seats.map(&:id).sort
    end

    def max_seat_id
      ordered_seat_ids.last
    end

    def my_seat_id
      ordered_seat_ids.each_cons(2).each do |(id, next_id)|
        return id + 1 if next_id - id == 2
      end
    end

    class Seat
      attr_reader :id

      def initialize(string)
        @id = string.gsub(/[BFRL]/, **bitmap).to_i(2)
      end

      def bitmap
        ["B", "F", "R", "L"].zip([1, 0, 1, 0]).to_h
      end
    end
  end
end

