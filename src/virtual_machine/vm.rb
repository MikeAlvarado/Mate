require 'byebug'
require 'constants/reserved_words'
require 'validators/runtime_validator'
require_relative 'operation_handler'
require_relative 'runtime_memory'
require_relative 'utility'

module VM
  class Runner
    def initialize(instructions, functions)
      @current_instruction = functions[ReservedWords::ORIGIN].initial_instruction
      @instructions = instructions
      @functions = functions
      @memory = RuntimeMemory.new(functions[ReservedWords::ORIGIN])
    end

    def start
      Utility::execute_safely -> () {
        until @current_instruction == @instructions.length ||
          @instructions[@current_instruction].operator.eop? do
          @current_instruction = run(@instructions[@current_instruction])
        end
      }
    end

    def run(instruction)
      left_operand = Utility::get_value instruction.left_operand, @memory
      right_operand = Utility::get_value instruction.right_operand, @memory
      case(instruction.operator.id)
        when Instructions::GOSUB

        when Instructions::GOTO
          return instruction.result
        when Instructions::GOTOF
          return instruction.result unless left_operand.value
        when Instructions::EOF

        when Instructions::EOP

        when Instructions::ERA

        when Instructions::PARAM

        when Instructions::RETURN

        when Instructions::SOF

        when Instructions::WRITE
          puts left_operand
        else
          operation = OperationHandler.new left_operand, right_operand, instruction.result
          operation.execute_operation instruction.operator, @memory
      end
      @current_instruction + 1
    end
  end
end