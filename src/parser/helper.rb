require 'byebug'
require 'constants/operators'
require 'constants/reserved_words'
require 'ir/quadruples'
require 'memory/manager'
require 'symbols/program'
require 'virtual_machine/vm'
require_relative 'function_call'

# Parser/Helper
# This class contains the methods that the parser calls
# while parsing the program.

# @program - Contains the current function being compiled.
#  Manages adding scopes, variables, and functions.

# @ir - Contains the current state of the quadruples.
#  Manages adding new instructions.

# @function_calls - A stack of function calls
#  Manages param validations.

# @memory - Contains the current state of the memory.
#  Manages allocation and deallocation.

module Parser
  class Helper
    def initialize
      @function_calls = []
      @ir = IR::Quadruples.new #'ir' is short for 'intermediate representation'
      @memory = Memory::Manager.new
      @program = nil
    end

    def ass_var(name:, index: nil)
      Utility::execute_safely -> () {
        Validate::var_exists @program.current_function, name
        @ir.assign_var name, index, @memory
      }
    end

    def call_func
      @ir.func_call @memory, @function_calls.pop.func, @program.current_function
    end

    def def_func(name)
      Utility::execute_safely -> () {
        @program.def_func name, @ir
      }
    end

    def def_origin
      Utility::execute_safely -> () {
        @program.def_origin @ir
      }
    end

    def def_param(name)
      Utility::execute_safely -> () {
        param_entry = @program.def_param name
        @memory.alloc param_entry
      }
    end

    def def_program(name)
      Utility::execute_safely -> () {
          program = Symbols::Program.new name
          Validate::symbol_is_not_reserved program
          @program = program
      }
    end

    def def_scope
      @program.def_scope
    end

    def def_var(name, assigning)
      Utility::execute_safely -> () {
        new_var = @program.def_var name
        @memory.alloc new_var
        ass_var({ name: name }) if assigning
      }
    end

    def del_scope
      scope_vars = @program.current_function.current_scope.vars
      scope_vars.each_value {
        |var_value|
        @memory.dealloc var_value
      }
      @program.del_scope
    end

    def else_start
      Utility::execute_safely -> () { @ir.else_start }
    end

    def eval_binary_op
      Utility::execute_safely -> () { @ir.eval_binary_op @memory, @program.current_function }
    end

    def eval_negation
      Utility::execute_safely -> () { @ir.eval_negation @memory, @program.current_function }
    end

    def finished_statement_function_call
      @ir.finished_statement_function_call
    end

    def func_end
      @ir.func_end @program.current_function
    end

    def func_return
      @ir.func_return @memory, @program.current_function
    end

    def handle_var_value(name, is_accessing_an_array)
      index = nil
      Utility::execute_safely -> () {
        Validate::var_exists @program.current_function, name
        index = @ir.get_operand @memory if is_accessing_an_array
      }
      { name: name, index: index }
    end

    def if_condition
      Utility::execute_safely -> () { @ir.if_condition @memory }
    end

    def if_end
      Utility::execute_safely -> () { @ir.if_end }
    end

    def loop_condition_end
      Utility::execute_safely -> () { @ir.loop_condition_end @memory }
    end

    def loop_condition_start
      Utility::execute_safely -> () { @ir.loop_condition_start }
    end

    def loop_end
      Utility::execute_safely -> () { @ir.loop_end }
    end

    def program_complete(name)
      Utility::execute_safely -> () {
        Validate::function_exists @program, ReservedWords::ORIGIN
      }
      @ir.program_end
      if $debug
        puts @ir
        puts "Programa '#{name}' compilado.\n\n"
      end
      vm = VM::Runner.new @ir.quadruples, @program.functions
      vm.start
    end

    def new_call(name)
      Utility::execute_safely -> () {
        func = @program.get_func name
        @function_calls << FunctionCall.new(func)
        @ir.func_prep func
      }
    end

    def new_call_param
      @ir.param @memory, @function_calls.last
      @function_calls.last.increase_param_counter
    end

    def new_operand(operand, has_sign = false)
      unless operand.nil?
        Utility::execute_safely -> () {
          Validate::var_exists(@program.current_function, operand) if operand.is_a? Symbols::Var
          if has_sign
            sign = @ir.get_operator
            if sign.subtract?
              operand.value = -operand.value
            end
          end
        }
        @ir.new_operand operand
      end
    end

    def new_operator(operator)
      @ir.new_operator Operator.new operator
    end

    def element_size
      @ir.element_size @memory
    end

    def read
      @ir.read @memory, @program.current_function
    end

    def verify_params
      Utility::execute_safely -> () {
        @function_calls.last.verify_params
      }
    end

    def write
      @ir.write @memory
    end
  end
end