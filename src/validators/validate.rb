require 'constants/types'
require 'symbols/base'
require_relative 'mate_error'

module Validate
  def self.symbol_is_new(scope, symbol, type = Symbols::Base)
    raise type.duplicate_err scope.name if scope.symbol? symbol.name, type
  end

  def self.symbol_exists(scope, name, type = Symbols::Base)
    raise type.undefined scope.name unless scope.symbol? name, type
  end

  def self.can_delete_scope(scope)
    if scope.nil?
      raise MateError.new 'Cannot delete global scope'
    end
  end

  def self.operator_type(operator, type)
    raise MateError.invalid_operator operator unless operator.id == type
  end

  def self.operation_type(left, right, operator, result)
    raise MateError.invalid_operation left, right, operator if result == Types::UNDEFINED
  end

  def self.operand_type(operand, type)
    raise MateError.invalid_operand(operand, Type.new(type)) unless operand.type.id == type
  end
end