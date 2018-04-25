require 'byebug'
require 'constants/limits'
require 'constants/reserved_words'
require 'ir/instructions'
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
        until @current_instruction.nil? ||
          @current_instruction == @instructions.length ||
          @instructions[@current_instruction].operator.eop? do
          @current_instruction = run(@instructions[@current_instruction])
        end
      }
    end

    def run(instruction)
      case(instruction.operator.id)
        when Instructions::ERA
          @memory.new_frame @functions[instruction.result]
        when Instructions::PARAM
          result = Utility::get_value instruction.result, @memory
          @memory.set_param instruction.left_operand, result
        when Instructions::GOSUB
          @memory.set_return_addr instruction.result, @current_instruction
          return instruction.right_operand
        when Instructions::GOTO
          return instruction.result
        when Instructions::GOTOF
          left_operand = Utility::get_value instruction.left_operand, @memory
          return instruction.result unless left_operand.value
        when Instructions::EOF
          return @memory.end_frame
        when Instructions::EOP
        when Instructions::SOF
          @memory.start_frame
        when Instructions::RETURN
          unless instruction.result.nil?
            return_value = Utility::get_value instruction.result, @memory
            @memory.set_return return_value
          end
        when Instructions::UNARY_OPERATIONS, Instructions::BINARY_OPERATIONS
          left_operand = Utility::get_value instruction.left_operand, @memory
          right_operand = Utility::get_value instruction.right_operand, @memory
          operation = OperationHandler.new left_operand, right_operand, instruction.result
          operation.execute_operation instruction.operator, @memory
      end
      @current_instruction + 1
    end
  end
end