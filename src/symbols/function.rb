require 'byebug'
require 'constants/reserved_words'
require 'validators/mate_error'
require 'validators/validate'
require_relative 'scope'
require_relative 'var'

module Symbols
  # Symbols::Function
  # @name           - Name of the function
  # @current_scope  - A function contains its scope and the scope of its conditional blocks
  # @params         - List of parameters
  # @var_count      - Number of vars (for memory management)
  # @type           - If the function returns anything, it contains a type other than invalid
  class Function
    attr_reader :name, :params, :current_scope, :type, :var_count
    attr_accessor :initial_instruction
    def initialize(name)
      @name = name
      @current_scope = nil
      @params = []
      @var_count = 0
      @type = Type.new Types::INVALID
    end

    def def_param(name)
      symbol = Symbols::Var.new name
      Validate::symbol_is_not_reserved symbol
      Validate::param_is_not_defined self, symbol
      @params << symbol
      @var_count += 1
      symbol
    end

    def def_scope
      @current_scope = Scope.new @current_scope
      @current_scope.def_params @params if @current_scope.parent.nil?
    end

    def def_type
      @type = Type.new Types::UNDEFINED
    end

    def def_var(name)
      symbol = Symbols::Var.new name
      Validate::symbol_is_not_reserved name
      Validate::param_is_not_defined self, name
      Validate::var_is_new self, name
      @current_scope.def_var symbol
      @var_count += 1
      symbol
    end

    def del_scope
      Validate::can_delete_scope @current_scope
      @current_scope = @current_scope.parent
    end

    def params_err(param_count)
      MateError.new "#{Base.message_detail @name}"\
      "Error de semántica: el número de parámetros no "\
      "coincide. Se esperaban #{@params.length}, se "\
      "recibieron #{param_count}"
    end

    def self.undefined_err(program_name, name)
      MateError.new "#{Base.message_detail program_name}"\
      "Error de semántica: la función '#{name}' "\
      "no está definida en el programa."
    end

    def duplicate_err(program_name)
      MateError.new "#{Base.message_detail program_name}"\
      "Error de semántica: la función '#{@name}' "\
      "ya está definida."
    end

    def to_s
      "***#{@name}***\nPARAMS: #{@params.length}\nLOCAL VAR COUNT: #{@var_count}\n"
    end
  end
end