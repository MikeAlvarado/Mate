require 'byebug'
require 'constants/semantic_cube'
require 'memory/value'
require 'validators/runtime_validator'

module VM

  module_function

  class OperationHandler
    def initialize(left_operand, right_operand, result_metadata)
      @left_operand = left_operand
      @right_operand = right_operand
      @result_metadata = result_metadata
    end

    def execute_operation(operator, memory)
      case operator.id
        when Instructions::ASSIGN
          result_value = Memory::Value.new @left_operand.value, @left_operand.type.id
        when Instructions::NOT
          RuntimeValidator::operand_type @left_operand, Types::BOOL, memory.current_frame_name
          result_value = Memory::Value.new !@left_operand.value, @left_operand.type.id
        when Instructions::READ
          result_value = Memory::Value.string gets.chomp
        when 0..7, 9..13
          result_value = execute_binary_operation operator, memory
      end
      memory.set_value @result_metadata, result_value
    end

    def execute_binary_operation(operator, memory)
      result_type = SemanticCube::resolve @left_operand, @right_operand, operator
      RuntimeValidator::operation_is_valid result_type, memory.current_frame_name
      case operator.id
        when Instructions::EQUAL
          result_value = @left_operand.value == @right_operand.value

        when Instructions::NOT_EQUAL
          result_value = @left_operand.value != @right_operand.value

        when Instructions::LESS_EQUAL
          result_value = @left_operand.value <= @right_operand.value

        when Instructions::GREATER_EQUAL
          result_value = @left_operand.value >= @right_operand.value

        when Instructions::LESS
          result_value = @left_operand.value < @right_operand.value

        when Instructions::GREATER
          result_value = @left_operand.value > @right_operand.value

        when Instructions::AND
          result_value = @left_operand.value && @right_operand.value

        when Instructions::OR
          result_value = @left_operand.value || @right_operand.value

        when Instructions::MOD
          result_value = @left_operand.value % @right_operand.value

        when Instructions::MULTIPLY
          result_value = @left_operand.value * @right_operand.value

        when Instructions::DIVIDE
          result_value = @left_operand.value / @right_operand.value

        when Instructions::ADD
          if @left_operand.type.string? || @right_operand.type.string?
            result_value = "#{@left_operand}#{@right_operand}"
          else
            result_value = @left_operand.value + @right_operand.value
          end

        when Instructions::SUBTRACT
          result_value = @left_operand.value - @right_operand.value

      end
      Memory::Value.new result_value, result_type
    end
  end
end