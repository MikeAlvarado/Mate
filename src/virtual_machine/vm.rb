require 'byebug'
require 'constants/reserved_words'
require_relative 'operation_handlers/binary_operation'
require_relative 'operation_handlers/jump_operation'
require_relative 'operation_handlers/unary_operation'
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
        until @current_instruction.nil? ||
          @current_instruction == @instructions.length ||
          @instructions[@current_instruction].operator.eop? do
          @current_instruction = run(@instructions[@current_instruction])
        end
      }
    end

    def get_value operand, memory
      Utility::get_value operand, @memory
    end

    def run(instruction)
      operator = instruction.operator
      left_value = get_value instruction.left_operand, @memory
      right_value = get_value instruction.right_operand, @memory
      result_operand = instruction.result

      if operator.binary_operation?
        operation = BinaryOperation.new left_value, right_value, result_operand
        operation.execute operator, @memory

      elsif operator.jump_operation?
        operation = JumpOperation.new left_value, right_value, result_operand
        return operation.execute operator, @current_instruction, @memory

      elsif operator.unary_operation?
        operation = UnaryOperation.new left_value, nil, result_operand
        operation.execute operator, @memory

      elsif operator.era?
        @memory.new_frame @functions[left_value]

      elsif operator.param?
        @memory.set_param left_value, right_value

      elsif operator.sof?
        @memory.start_frame

      elsif operator.return?
        @memory.set_return left_value
      end

      @current_instruction + 1
    end
  end
end