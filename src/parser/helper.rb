require 'constants/operators'
require 'constants/reserved_words'
require 'ir/quadruples'
require 'memory/manager'
require 'symbols/function'
require 'symbols/program'
require 'symbols/scope'
require 'symbols/var'

module Parser
  class Helper
    def initialize
      @current_scope = Scope.new nil
      @lookahead_scope = nil
      @ir = IR::Quadruples.new #'ir' is short for 'intermediate representation'
      @memory = Memory::Manager.new
    end

    def def_program(name)
      Utility::execute_safely -> () {
        @current_scope.new_symbol Symbols::Program.new name
      }
      @lookahead_scope = Scope.new name
    end

    def def_origin
      Utility::execute_safely -> () {
        @current_scope.def_origin
      }
      @lookahead_scope = Scope.new ReservedWords::ORIGIN, @current_scope
    end

    def def_func(name)
      Utility::execute_safely -> () {
        @current_scope.new_symbol Symbols::Function.new name
      }
      @lookahead_scope = Scope.new name, @current_scope
    end

    def def_var(name, assigning)
      new_var @current_scope, name
      ass_var name if assigning
    end

    def def_param(name)
      new_var @lookahead_scope, name
    end

    def def_scope
      @current_scope = @lookahead_scope.nil? ?
        Scope.new(@current_scope.name, @current_scope) : @lookahead_scope
      @lookahead_scope = nil
    end

    def del_scope
      Utility::execute_safely -> () { Validate::can_delete_scope @current_scope }
      @current_scope = @current_scope.parent
    end

    def ass_var(name)
      Utility::execute_safely -> () { @ir.assign_var name, @memory }
    end

    def new_operator(operator)
      @ir.new_operator Operator.new operator
    end

    def new_operand(operand)
      @ir.new_operand operand
    end

    def eval_binary_op
      Utility::execute_safely -> () { @ir.eval_binary_op @memory }
    end

    def eval_negation
      Utility::execute_safely -> () { @ir.eval_negation @memory }
    end

    def call_function(name)
      Utility::execute_safely -> () { 
        Validate::symbol_exists @current_scope, Symbols::Function.new(name)
      }
    end

    def loop_condition_start
      Utility::execute_safely -> () { @ir.loop_condition_start }
    end

    def loop_condition_end
      Utility::execute_safely -> () { @ir.loop_condition_end @memory }
    end

    def loop_end
      Utility::execute_safely -> () { @ir.loop_end }
    end

    def if_condition
      Utility::execute_safely -> () { @ir.if_condition @memory }
    end

    def if_end
      Utility::execute_safely -> () { @ir.if_end }
    end

    def else_start
      Utility::execute_safely -> () { @ir.else_start }
    end

    def program_complete(name)
      Utility::execute_safely -> () {
        Validate::symbol_exists @current_scope, Symbols::Function.new(ReservedWords::ORIGIN)
      }
      @ir.program_end
      puts "Programa '#{name}' compilado.\n\n"
      puts @ir
    end

    private

    def new_var(scope, name)
      Utility::execute_safely -> () {
        scope.new_symbol Symbols::Var.new name
        @memory.alloc name
      }
    end
  end
end