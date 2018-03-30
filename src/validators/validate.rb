require 'constants/reserved_words'
require 'constants/types'
require 'symbols/base'
require_relative 'mate_error'

module Validate
  module_function

  def symbol_is_not_reserved(symbol)
    raise MateError.reserved_word symbol.name if ReservedWords::include? symbol.name
  end

  def symbol_is_new(scope, symbol = Symbols::Base.new('undefined'))
    raise symbol.duplicate_err scope.name if scope.symbol? symbol
  end

  def symbol_exists(scope, symbol = Symbols::Base.new('undefined'))
    raise symbol.undefined_err scope.name unless scope.symbol? symbol
  end

  def can_delete_scope(scope)
    if scope.nil?
      raise MateError.new 'Cannot delete global scope'
    end
  end

  def operator_type(operator, type)
    raise MateError.invalid_operator operator unless operator.id == type
  end

  def operation_type(left, right, operator, result)
    raise MateError.invalid_operation left, right, operator if result == Types::UNDEFINED
  end

  def operand_type(operand, type)
    raise MateError.invalid_operand(operand, Type.new(type)) unless operand.type.id == type
  end
end