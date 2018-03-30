#'IR' is short for 'Intermediate Representation'
require 'constants/semantic_cube'
require 'constants/types'
require 'memory/entry'
require 'memory/value'
require 'validators/validate'
require_relative 'instructions'
require_relative 'quadruple'

module IR
  class Quadruples
    attr_accessor :operators, :operands
    def initialize
      @operands = []
      @operators = []
      @quadruples = []
      @gotos = []
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
      @quadruples.push Quadruple.new(Instruction.new(operator.id), operand, nil, memory.get(name))
    end

    def eval_binary_op(memory)
      right = get_operand memory
      left = get_operand memory
      operator = operators.pop

      result_type = SemanticCube.resolve(left.type, right.type, operator)
      Validate::operation_type left.type, right.type, operator, result_type
      result = memory.alloc_temp(result_type)
      @quadruples.push Quadruple.new(Instruction.new(operator.id), left, right, result)

      memory.dealloc right if right.is_a? Memory::Entry
      memory.dealloc left if left.is_a? Memory::Entry
      new_operand result
    end

    def eval_negation(memory)
      operand = get_operand memory
      Validate::operand_type operand, Types::BOOL
      result = memory.alloc_temp(Types::BOOL)
      @quadruples.push Quadruple.new(Instruction.new(Instructions::NOT), operand, nil, result)

      memory.dealloc operand if operand.is_a? Memory::Entry
      new_operand result
    end

    def if_condition(memory)
      operand = get_operand memory
      Validate::operand_type operand, Types::BOOL
      @quadruples.push Quadruple.new(Instruction.new(Instructions::GOTOF), operand, nil, nil)
      @gotos << @quadruples.length - 1
    end

    def else_start
      @quadruples.push Quadruple.new(Instruction.new(Instructions::GOTO), nil, nil, nil)
      pending_goto = @gotos.pop
      @quadruples[pending_goto].result = @quadruples.length
      @gotos << @quadruples.length - 1
    end

    def if_end
      pending_goto = @gotos.pop
      @quadruples[pending_goto].result = @quadruples.length
    end

    def loop_condition_start
      @gotos << @quadruples.length
    end

    def loop_condition_end(memory)
      operand = get_operand memory
      Validate::operand_type operand, Types::BOOL
      @quadruples.push Quadruple.new(Instruction.new(Instructions::GOTOF), operand, nil, nil)
      @gotos << @quadruples.length - 1
    end

    def loop_end
      @quadruples.push Quadruple.new(Instruction.new(Instructions::GOTO), nil, nil, nil)
      pending_goto = @gotos.pop
      @quadruples[pending_goto].result = @quadruples.length
      pending_goto = @gotos.pop
      @quadruples[@quadruples.length - 1].result = pending_goto
    end

    def program_end
      @quadruples.push Quadruple.new(Instruction.new(Instructions::EOP), nil, nil, nil)
    end

    def to_s
      s = ''
      @quadruples.each_with_index { |q, index| s += "#{index}.\t#{q}\n" }
      s
    end

    private

    def test_print(name, value)
      puts "#{name}:\n#{value} \n"
    end
  end
end