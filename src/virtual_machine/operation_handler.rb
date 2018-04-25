require 'byebug'
require 'constants/reserved_words'
require 'constants/semantic_cube'
require 'ir/instructions'
require 'memory/value'
require 'parser/current'
require 'validators/runtime_validator'

module VM

  class OperationHandler
    def initialize(left_operand, right_operand, result_metadata)
      @left_operand = left_operand
      @right_operand = right_operand
      @result_metadata = result_metadata
    end

    def execute_operation(operator, memory)
      case operator.id
        when Instructions::UNARY_OPERATIONS
          if operator.write?
            puts @left_operand
          else
            result_value = execute_unary_operation operator, memory
          end
        when Instructions::BINARY_OPERATIONS
          result_value = execute_binary_operation operator, memory
      end
      memory.set_value @result_metadata, result_value unless result_value.nil?
    end

    def execute_unary_operation(operator, memory)
      case operator.id
        when Instructions::ASSIGN
          Memory::Value.new @left_operand.value, @left_operand.type.id
        when Instructions::NOT
          RuntimeValidator::operand_type @left_operand, Types::BOOL, memory.current_frame_name
          Memory::Value.bool !@left_operand.value
        when Instructions::READ
          input = Parser::CurrentRuby.parse gets.chomp
          input_value = input.children.last
          case input.type
            when :str
              if input_value == ReservedWords::TRUE
                Memory::Value.bool true
              elsif input_value == ReservedWords::FALSE
                Memory::Value.bool false
              else
                Memory::Value.string input_value
              end
            when :float
              Memory::Value.float input_value
            when :int
              Memory::Value.int input_value
            else
              Memory::Value.undefined input_value
          end
      end
    end

    def execute_binary_operation(operator, memory)
      result_type = SemanticCube::resolve @left_operand, @right_operand, operator
      RuntimeValidator::operation_is_valid result_type, memory.current_frame_name
      result_value = @left_operand.value.send operator.to_s, @right_operand.value
      Memory::Value.new result_value, result_type
    end
  end
end
