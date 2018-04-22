require 'constants/semantic_cube'
require 'constants/types'
require 'memory/value'
require 'validators/runtime_validator'

module VM

  module_function

  def execute_logical_operation(left_operand, right_operand, operator, result_metadata, memory)
    unless left_operand.nil? || right_operand.nil?
      result_type = SemanticCube::resolve left_operand, right_operand, operator
      RuntimeValidator::operation_is_valid result_type, memory.current_frame_name
    end
    case operator.id
      when Instructions::EQUAL
        result_value = left_operand.value == right_operand.value
      when Instructions::NOT_EQUAL
        result_value = left_operand.value != right_operand.value
      when Instructions::LESS_EQUAL
        result_value = left_operand.value <= right_operand.value
      when Instructions::GREATER_EQUAL
        result_value = left_operand.value >= right_operand.value
      when Instructions::LESS
        result_value = left_operand.value < right_operand.value
      when Instructions::GREATER
        result_value = left_operand.value > right_operand.value
      when Instructions::AND
        result_value = left_operand.value && right_operand.value
      when Instructions::OR
        result_value = left_operand.value || right_operand.value
      when Instructions::NOT
        RuntimeValidator::operand_type left_operand, Types::BOOL, memory.current_frame_name
        result_value = !left_operand.value
        result_type = left_operand.type
    end
    memory.set_value result_metadata, Memory::Value.new(result_value, result_type)
  end
end