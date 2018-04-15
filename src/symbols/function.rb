require 'constants/reserved_words'
require 'validators/mate_error'
require 'validators/validate'
require_relative 'base'
require_relative 'scope'
require_relative 'var'

module Symbols
  class Function < Base
    attr_reader :params, :current_scope, :type
    attr_accessor :initial_instruction
    def initialize(name)
      super(name)
      @current_scope = nil
      @params = []
      @var_count = 0
      @type = Type.new Types::INVALID
    end

    def def_param(name)
      symbol = Symbols::Var.new name, true
      Validate::symbol_is_not_reserved symbol
      Validate::param_is_not_defined self, symbol
      @params << symbol
    end

    def def_scope
      @current_scope = Scope.new @current_scope
      @current_scope.def_params @params
    end

    def def_type(type)
      if @type.invalid? || @type.id == type
        @type = Type.new type
      else
        @type = Type.new Types::UNDEFINED
      end
    end

    def def_var(name)
      symbol = Symbols::Var.new name
      Validate::symbol_is_not_reserved symbol
      Validate::param_is_not_defined self, symbol
      Validate::var_is_new self, symbol
      @current_scope.def_var symbol
      @var_count += 1
      symbol
    end

    def del_scope
      Validate::can_delete_scope @current_scope
      @current_scope = @current_scope.parent
    end

    def size
      @var_count + @params.length
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
      "***#{@name}***\nPARAMS: #{@params.length}\nVARS: #{@var_count}\nSIZE: #{size}"
    end
  end
end