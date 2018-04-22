require 'constants/reserved_words'
require 'constants/semantic_cube'
require 'constants/types'
require 'memory/entry'
require 'memory/value'
require 'validators/validate'
require_relative 'instructions'
require_relative 'quadruple'

#'IR' is short for 'Intermediate Representation'
module IR
  class Quadruples
    attr_reader :quadruples
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
      op = @operands.pop
      Validate::operand_is_valid op if op.is_a? Memory::Entry
      return op if op.is_a?(Memory::Value) || op.is_a?(Memory::Entry)
      memory.get op
    end

    def assign_var(var, memory)
      operand = get_operand memory
      operator = @operators.pop
      Validate::operator_type operator, Operators::ASSIGN
      memory.update var, operand.type
      @quadruples.push Quadruple.new(Instruction.new(operator.id), operand, nil, memory.get(var))
    end

    def eval_binary_op(memory, current_func)
      right = get_operand memory
      left = get_operand memory
      operator = @operators.pop
      result_type = SemanticCube.resolve(left, right, operator)
      Validate::operation_type left.type, right.type, operator, result_type
      result = memory.alloc_temp(result_type)
      @quadruples.push Quadruple.new(Instruction.new(operator.id), left, right, result)

      memory.dealloc right if right.is_a? Memory::Entry
      memory.dealloc left if left.is_a? Memory::Entry
      new_operand result
    end

    def eval_negation(memory, current_func)
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

    def finished_statement_function_call
      @operands.pop
    end

    def func_end(func)
      @quadruples.push Quadruple.new(Instruction.new(Instructions::EOF), nil, nil, func.name)
    end

    def func_prep(func)
      @quadruples.push Quadruple.new(Instruction.new(Instructions::ERA), nil, nil, func.name)
    end

    def func_call(memory, func, current_func)
      result = memory.alloc_temp func.type.id
      call_result = func.type.invalid? ? nil : result
      @quadruples.push Quadruple.new(Instruction.new(Instructions::GOSUB), func.name, func.initial_instruction, call_result)
      new_operand result
    end

    def func_return(memory, func)
      operand = get_operand memory
      Validate::operand_is_valid operand
      func.def_type operand.type.id
      @quadruples.push Quadruple.new(Instruction.new(Instructions::RETURN), nil, nil, operand)
    end

    def func_start(func)
      @quadruples.push Quadruple.new(Instruction.new(Instructions::SOF), nil, nil, func.name)
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

    def param(memory, function_call)
      operand = get_operand memory
      @quadruples.push Quadruple.new(Instruction.new(Instructions::PARAM), operand, nil, function_call.current_param)
    end

    def program_end
      @quadruples.push Quadruple.new(Instruction.new(Instructions::EOP), nil, nil, nil)
    end

    def read(memory, current_func)
      result = memory.alloc_temp
      @quadruples.push Quadruple.new(Instruction.new(Instructions::READ), nil, nil, result)
      new_operand result
    end

    def write(memory)
      operand = get_operand memory
      @quadruples.push Quadruple.new(Instruction.new(Instructions::WRITE), operand, nil, nil)
    end

    def to_s
      s = ''
      @quadruples.each_with_index { |q, index| s += "#{index}.\t#{q}\n" }
      s
    end

    def get_instruction_number
      @quadruples.length - 1
    end

    private

    def test_print(name, value)
      puts "#{name}:\n#{value} \n"
    end
  end
end