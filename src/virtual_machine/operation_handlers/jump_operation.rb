require 'byebug'
require 'constants/types'
require 'validators/runtime_validator'
require_relative 'base'

module VM
  # JumpOperation < OperationHandler
  # Handles GOSUB, GOTO, GOTOF, and end of function
  class JumpOperation < OperationHandler
    def execute(operator, current_instruction, memory)
      if operator.gosub?
        memory.set_return_metadata @result_metadata, current_instruction
        @right_operand

      elsif operator.goto?
        @right_operand

      elsif operator.gotof?
        if @left_operand.value
          current_instruction + 1
        else
          @right_operand
        end

      elsif operator.eof?
        memory.end_frame
      end
    end
  end
end