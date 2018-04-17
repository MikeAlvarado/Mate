require 'byebug'
require 'constants/reserved_words'
require 'ir/instructions'
require_relative 'logical_operations'

module VM
  class Runner
    def initialize(instructions, functions)
      @current_instruction = functions[ReservedWords::ORIGIN].initial_instruction
      @instructions = instructions
      @functions = functions
    end

    def start
      puts 'Starting runner...'
      until @current_instruction == @instructions.length ||
        @instructions[@current_instruction].operator.eop? do
        @current_instruction = run(@instructions[@current_instruction])
      end
      puts 'Finished runner...'
    end

    def run(instruction)
      case(instruction.operator.id)
        when 0..8
          execute_logical_operation instruction
        when 9..13
          execute_arithmetic_operation instruction
        when Instructions::ASSIGN

        when Instructions::GOSUB

        when Instructions::GOTO

        when Instructions::GOTOF

        when Instructions::EOF

        when Instructions::EOP

        when Instructions::ERA

        when Instructions::PARAM

        when Instructions::READ

        when Instructions::RETURN

        when Instructions::SOF

        when Instructions::WRITE
      end
      @current_instruction + 1
    end
  end
end