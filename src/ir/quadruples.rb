#'IR' is short for 'Intermediate Representation'
require 'constants/operators'
require 'constants/semantic_cube'
require 'constants/types'
require 'memory/entry'
require 'memory/value'
require 'validators/validate'
require_relative 'quadruple'

module IR
  class Quadruples
    attr_accessor :operators, :operands
    def initialize
      @operands = []
      @operators = []
      @quadruples = []
    end

    def new_operator(operator)
      @operators.push(operator)
    end

    def new_operand(operand)
      @operands.push(operand)
    end

    def get_operand(memory)
      op = operands.pop
      return op if op.is_a?(Memory::Value) || op.is_a?(Memory::Entry)
      memory.get op
    end

    def assign_var(name, memory)
      operand = get_operand memory
      operator = operators.pop
      Validate::operator_type operator, Operators::ASSIGN
      memory.update name, operand.type
      @quadruples.push Quadruple.new operator, operand, nil, memory.get(name)
    end

    def eval_binary_op(memory)
      right = get_operand memory
      left = get_operand memory
      operator = operators.pop

      result_type = SemanticCube.resolve(left.type, right.type, operator)
      Validate::operation_type left.type, right.type, operator, result_type
      result = memory.alloc_temp(result_type)
      @quadruples.push Quadruple.new operator, left, right, result

      memory.dealloc right if right.is_a? Memory::Entry
      memory.dealloc left if left.is_a? Memory::Entry
      new_operand result
    end

    def eval_negation(memory)
      operand = get_operand memory
      Validate::operand_type operand, Types::BOOL
      result = memory.alloc_temp(Types::BOOL)
      @quadruples.push Quadruple.new(Operator.new(Operators::NOT), operand, nil, result)

      memory.dealloc operand if operand.is_a? Memory::Entry
      new_operand result
    end

    def to_s
      @quadruples.join("\n")
    end

    private

    def test_print(name, value)
      puts "#{name}:\n#{value} \n"
    end
  end
end