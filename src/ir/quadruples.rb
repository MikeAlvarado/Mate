require 'byebug'
require 'memory/entry'
require 'memory/value'
require 'validators/validate'
require_relative 'instructions'
require_relative 'quadruple'
require_relative 'var_access'

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
      @operands.push(operand) unless operand.nil?
    end

    def get_operand(memory)
      op = @operands.pop
      if op.is_a?(Memory::Value) || op.is_a?(VarAccess)
        op
      elsif op.is_a? Memory::Entry
        VarAccess.new addr: op.addr, is_temp: op.is_temp
      else
        entry = memory.get op[:name]
        VarAccess.new addr: entry.addr, index: op[:index]
      end
    end

    def get_operator
      @operators.pop
    end

    def assign_var(name, index, memory)
      operand = get_operand memory
      operator = get_operator
      Validate::operator_type operator, Operators::ASSIGN
      addr = memory.get(name).addr
      save_operation(
        operator.id,
        operand,
        nil,
        {addr: addr, index: index},
        memory)
    end

    def eval_binary_op(memory, current_func)
      right = get_operand memory
      left = get_operand memory
      operator = get_operator
      result = memory.alloc_temp
      save_operation(
        operator.id,
        left,
        right,
        { addr: result.addr, is_temp: result.is_temp },
        memory)
      new_operand result
    end

    def eval_negation(memory, current_func)
      operand = get_operand memory
      result = memory.alloc_temp
      save_operation(
        Instructions::NOT,
        operand,
        nil,
        {addr: result.addr, is_temp: result.is_temp},
        memory)
      new_operand result
    end

    def if_condition(memory)
      operand = get_operand memory
      @quadruples.push Quadruple.new(
        Instruction.new(Instructions::GOTOF),
        operand,
        nil,
        nil)
      @gotos << @quadruples.length - 1
      memory.dealloc_temp operand if operand.is_a? VarAccess
    end

    def else_start
      @quadruples.push Quadruple.new(
        Instruction.new(Instructions::GOTO),
        nil, nil, nil)
      pending_goto = @gotos.pop
      @quadruples[pending_goto].right_operand = @quadruples.length
      @gotos << @quadruples.length - 1
    end

    def finished_statement_function_call
      @operands.pop
    end

    def func_end(func)
      @quadruples.push Quadruple.new(
        Instruction.new(Instructions::EOF),
        func.name, nil, nil)
    end

    def func_prep(func)
      @quadruples.push Quadruple.new(
        Instruction.new(Instructions::ERA),
        func.name, nil, nil)
    end

    def func_call(memory, func, current_func)
      call_result = memory.alloc_temp
      call_result_access = {
        addr: call_result.addr,
        is_temp: call_result.is_temp
      }
      save_operation(
        Instructions::GOSUB,
        func.name,
        func.initial_instruction,
        call_result_access,
        memory
      )
      new_operand call_result
    end

    def func_return(memory, func)
      operand = get_operand memory
      func.def_type
      @quadruples.push Quadruple.new(
        Instruction.new(Instructions::RETURN),
        operand, nil, nil)
      memory.dealloc_temp operand if operand.is_a? VarAccess
    end

    def func_start(func)
      @quadruples.push Quadruple.new(
        Instruction.new(Instructions::SOF),
        func.name, nil, nil)
    end

    def get_instruction_number
      @quadruples.length - 1
    end

    def if_end
      pending_goto = @gotos.pop
      @quadruples[pending_goto].right_operand = @quadruples.length
    end

    def loop_condition_start
      @gotos << @quadruples.length
    end

    def loop_condition_end(memory)
      operand = get_operand memory
      @quadruples.push Quadruple.new(
        Instruction.new(Instructions::GOTOF),
        operand, nil, nil)
      @gotos << @quadruples.length - 1
      memory.dealloc_temp operand if operand.is_a? VarAccess
    end

    def loop_end
      @quadruples.push Quadruple.new(
        Instruction.new(Instructions::GOTO),
        nil, nil, nil)
      pending_goto = @gotos.pop
      @quadruples[pending_goto].right_operand = @quadruples.length
      pending_goto = @gotos.pop
      @quadruples[@quadruples.length - 1].right_operand = pending_goto
    end

    def param(memory, function_call)
      operand = get_operand memory
      @quadruples.push Quadruple.new(
        Instruction.new(Instructions::PARAM),
        function_call.current_param, operand, nil)
      memory.dealloc_temp operand if operand.is_a? VarAccess
    end

    def program_end
      @quadruples.push Quadruple.new(
        Instruction.new(Instructions::EOP),
        nil, nil, nil)
    end

    def read(memory, current_func)
      result = memory.alloc_temp
      save_operation(
        Instructions::READ,
        nil,
        nil,
        { addr: result.addr, is_temp: result.is_temp },
        memory
      )
      new_operand result
    end

    def save_operation(operator, left, right, result, memory)
      result_access = VarAccess.new(result) unless result.nil?
      @quadruples.push Quadruple.new(
        Instruction.new(operator),
        left,
        right,
        result_access)
      memory.dealloc_temp right if right.is_a? VarAccess
      memory.dealloc_temp left if left.is_a? VarAccess
    end

    def element_size(memory)
      operand = get_operand memory
      result = memory.alloc_temp
      save_operation(
        Instructions::ELEMENT_SIZE,
        operand,
        nil,
        { addr: result.addr, is_temp: result.is_temp },
        memory)
      new_operand result
    end

    def write(memory)
      operand = get_operand memory
      save_operation(
        Instructions::WRITE,
        operand,
        nil,
        nil,
        memory)
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