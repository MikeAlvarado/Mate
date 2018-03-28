require 'constants/operators'
require 'constants/reserved_words'
require 'ir/quadruples'
require 'memory/manager'
require 'symbols/function'
require 'symbols/program'
require 'symbols/scope'
require 'symbols/var'
require 'validators/mate_error'

module Parser
  class Helper
    def initialize
      @current_scope = Scope.new nil
      @lookahead_scope = nil
      @ir = IR::Quadruples.new #'ir' is short for 'intermediate representation'
      @memory = Memory::Manager.new
    end

    def def_program(name)
      self.class.execute_safely -> () {
        @current_scope.new_symbol Symbols::Program.new name
      }
      @lookahead_scope = Scope.new name
    end

    def def_func(name)
      self.class.execute_safely -> () {
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
        Scope.new(@current_scope.name, @current_scope)
        : @lookahead_scope
      @lookahead_scope = nil
    end

    def del_scope
      self.class.execute_safely -> () { Validate::can_delete_scope @current_scope }
      @current_scope = @current_scope.parent
    end

    def ass_var(name)
      self.class.execute_safely -> () { @ir.assign_var name, @memory }
    end

    def new_operator(operator)
      @ir.new_operator Operator.new operator
    end

    def new_operand(operand)
      @ir.new_operand operand
    end

    def eval_binary_op
      self.class.execute_safely -> () { @ir.eval_binary_op @memory }
    end

    def eval_negation
      self.class.execute_safely -> () { @ir.eval_negation @memory }
    end

    def call_function(name)
      self.class.execute_safely -> () { 
        Validate::symbol_exists @current_scope, name, Symbols::Function
      }
    end

    def program_complete(name)
      self.class.execute_safely -> () {
        Validate::symbol_exists @current_scope, ReservedWords::ORIGIN, Symbols::Function
      }
      puts @ir
      puts "Programa #{name} compilado."
    end

    private

    def self.execute_safely(process)
      begin
        process.call()
      rescue MateError => err
        abort("#{err.msg} Error en la línea #{$line_number}")
      end
    end

    def new_var(scope, name)
      self.class.execute_safely -> () {
        scope.new_symbol Symbols::Var.new name
        @memory.alloc name
      }
    end
  end
end