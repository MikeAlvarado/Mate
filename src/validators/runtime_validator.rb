require 'byebug'
require 'constants/limits'
require 'constants/semantic_cube'
require 'constants/types'
require_relative 'mate_runtime_error'

module RuntimeValidator

  module_function

  def frame_memory_available(local_size, function)
    raise MateRuntimeError.insufficient_memory(function) if local_size > Limits::MAX_FRAME_COUNT
  end

  def index_within_bounds(index, array_size, function)
    raise MateRuntimeError.index_out_of_bounds(function) if index.abs >= array_size
  end

  def operand_type(operand, type, function)
    raise MateRuntimeError.invalid_operand_type(operand, Type.new(type), function) if operand.type.id != type
  end

  def operation_is_valid(left, right, operator, result, function)
    raise MateRuntimeError.invalid_operation(left, right, operator, function) if result == Types::INVALID || result == Types::UNDEFINED
  end

  def var_memory_available(local_size, function)
    raise MateRuntimeError.insufficient_memory(function) if local_size > Limits::MAX_VAR_COUNT
  end

  def var_exists(var, function)
    raise MateRuntimeError.inexistent_var(function) if var.nil?
  end

  def var_is_valid(var, function)
    raise MateRuntimeError.invalid_var(function) if var.type.undefined? || var.type.invalid?
  end
end