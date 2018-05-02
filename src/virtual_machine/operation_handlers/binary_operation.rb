require 'byebug'
require 'constants/semantic_cube'
require 'constants/types'
require 'ir/var_access'
require 'memory/value'
require 'validators/runtime_validator'
require_relative 'base'

module VM
  # BinaryOperation < OperationHandler
  # Executes all binary operations
  # All results are stored in memory
  class BinaryOperation < OperationHandler
    def execute(operator, memory)
      result_type_id = SemanticCube::resolve @left_operand, @right_operand, operator

      result_type = Type.new result_type_id
      # Validate the result is valid
      RuntimeValidator::operation_is_valid(@left_operand,
        @right_operand,
        operator,
        result_type,
        memory.current_frame_name,
        @line_number)

      # Adding strings always concatenates strings
      if operator.add? && result_type.string?
        result_value = "#{@left_operand.to_s}#{@right_operand.to_s}"
      elsif operator.and?
        result_value = @left_operand.value && @right_operand.value
      elsif operator.or?
        result_value = @left_operand.value || @right_operand.value

      # Ruby is beautiful and allows meta-programming, therefore we
      # don't need a huge switch for handling each operation
      else
        result_value = @left_operand.value.send operator.to_s, @right_operand.value
      end
      memory.set_value @result_metadata, Memory::Value.new(result_value, result_type_id), @line_number
    end

    def operation_to_s(operator, result)
      "#{operator.to_s.ljust(4, ' ')}\t#{@left_operand.to_s.ljust(20, ' ')}\t#{@right_operand.to_s.ljust(20, ' ')}\t#{result.to_s.ljust(20, ' ')}"
    end
  end
end