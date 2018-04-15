require 'validators/mate_error'
require_relative 'base'
require_relative 'function'

module Symbols
  class Program < Base
    attr_reader :functions, :current_function
    def initialize(name)
      super(name)
      @current_function = nil
      @functions = Hash.new
    end

    def def_func(name, ir)
      new_function = Function.new name
      Validate::function_is_new self, new_function
      Validate::symbol_is_not_reserved new_function
      ir.func_start new_function
      new_function.initial_instruction = ir.get_instruction_number
      @functions[new_function.name] = new_function
      @current_function = new_function
    end

    def def_origin(ir)
      new_function = Function.new ReservedWords::ORIGIN
      Validate::function_is_new self, new_function
      ir.func_start new_function
      new_function.initial_instruction = ir.get_instruction_number
      @functions[new_function.name] = new_function
      @current_function = new_function
    end

    def def_param(name)
      @current_function.def_param name
    end

    def def_scope
      @current_function.def_scope
    end

    def def_var(name)
      @current_function.def_var name
    end

    def del_scope
      @current_function.del_scope
    end

    def get_func(name)
      Validate::function_exists self, name
      @functions[name]
    end

    def duplicate_err(scope_name)
      MateError.new "#{Base.message_detail scope_name}"\
      "Error de semántica: el programa '#{@name}' "\
      "ya está definido."
    end

    def undefined_err(scope_name)
      MateError.new "#{Base.message_detail scope_name}"\
      "Error de semántica: el programa '#{@name}' "\
      "no está definido."
    end
  end
end