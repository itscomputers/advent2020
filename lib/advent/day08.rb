require 'advent/day'

module Advent
  class Day08 < Advent::Day
    DAY = "08"

    def self.sanitized_input
      raw_input.split("\n").map { |string| Instruction.new *instruction_args_from(string) }
    end

    def self.instruction_args_from(string)
      match = instruction_regex.match string
      [match[:operation], match[:argument]]
    end

    def self.instruction_regex
      @instruction_regex ||= /^(?<operation>\w+) (?<argument>[\+\-]\d+)$/
    end

    def initialize(input)
      @instructions = input
      @console = GameConsole.new @instructions
    end

    def solve(part:)
      case part
      when 1 then @console.run.accumulator
      when 2 then hacked_console.accumulator
      end
    end

    def hacked_console
      multiverse_instructions.each do |instructions|
        console = GameConsole.new instructions
        unless console.run.loop_found?
          return console
        end
      end
    end

    def multiverse_instructions
      @instructions.map.with_index do |instruction, index|
        unless instruction.operation == 'acc'
          alt_universe_instructions_at index
        end
      end.compact
    end

    def alt_universe_instructions_at(index)
      head = @instructions.take index
      tail = @instructions.drop index + 1
      new_op = case @instructions[index].operation
               when 'jmp' then 'nop'
               when 'nop' then 'jmp'
               when 'acc' then 'acc'
               end
      new_instruction = Instruction.new new_op, @instructions[index].argument
      [*head, new_instruction, *tail]
    end

    class GameConsole
      attr_reader :accumulator

      def initialize(instructions)
        @instructions = instructions
        @accumulator = 0
        @pointer = 0
        @visited = Set.new
      end

      def instruction
        @instructions[@pointer]
      end

      def run
        advance until loop_found? || completed?
        self
      end

      def loop_found?
        @visited.include? @pointer
      end

      def completed?
        instruction.nil?
      end

      def advance
        @visited.add @pointer
        @accumulator, @pointer = instruction.execute @accumulator, @pointer
      end
    end

    class Instruction
      attr_reader :operation, :argument

      def initialize(operation, argument)
        @operation = operation
        @argument = argument.to_i
      end

      def execute(accumulator, pointer)
        case @operation
        when 'acc' then [accumulator + @argument, pointer + 1]
        when 'jmp' then [accumulator, pointer + @argument]
        when 'nop' then [accumulator, pointer + 1]
        end
      end
    end
  end
end

