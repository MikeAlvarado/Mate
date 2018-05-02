require 'constants/limits'
require 'constants/reserved_words'
require 'constants/types'
require_relative 'mate_error'

module Validate
  module_function

  def can_delete_scope(scope)
    raise MateError.new "There's no scope to delete" if scope.nil?
  end

  def function_is_new(program, function)
    raise function.duplicate_err program.name if program.functions.key? function.name
  end

  def function_exists(program, name)
    raise Symbols::Function.undefined_err program.name, name unless program.functions.key? name
  end

  def param_is_not_defined(function, name)
    raise Symbols::Var.duplicate_err(function.name, name) if function.params.include? name
  end

  def params_match(function, param_count)
    raise function.params_err(param_count) if param_count != function.params.length
  end

  def operand_is_valid(operand)
    raise MateError.invalid_operand(operand) if operand.type.invalid?
  end

  def operand_type(operand, type)
    raise MateError.invalid_operand_type(operand, Type.new(type)) unless operand.type.id == type || operand.type.undefined?
  end

  def operand_types(operand, types)
    raise MateError.invalid_operand_types(operand, types) unless types.include? operand.type.id || operand.type.undefined?
  end

  def operation_type(left, right, operator, result)
    raise MateError.invalid_operation left, right, operator if result == Types::INVALID
  end

  def operator_type(operator, type)
    raise MateError.invalid_operator operator unless operator.id == type
  end

  def symbol_is_not_reserved(name)
    raise MateError.reserved_word name if ReservedWords::include? name
  end

  def var_exists(function, name)
    raise Symbols::Var.undefined_err function.name, name unless function.current_scope.var? name
  end

  def var_is_new(function, name)
    raise Symbols::Var.duplicate_err function.name, name if function.current_scope.var? name
  end
end