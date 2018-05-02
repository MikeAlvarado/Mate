require 'byebug'
require 'constants/limits'
require 'constants/semantic_cube'
require 'constants/types'
require_relative 'mate_runtime_error'

module RuntimeValidator
  # RuntimeValidator
  # Functions for throwing errors in case an error should be thrown
  # during run time
  module_function

  def frame_memory_available(local_size, function)
    raise MateRuntimeError.insufficient_memory(function) if local_size > Limits::MAX_FRAME_COUNT
  end

  def index_within_bounds(index, array_size, function, line_number)
    raise MateRuntimeError.index_out_of_bounds(function, line_number) if index.abs >= array_size
  end

  def operand_type(operand, type, function, line_number)
    raise MateRuntimeError.invalid_operand_type(operand, Type.new(type), function, line_number) if operand.type.id != type
  end

  def can_get_size(operand, function, line_number)
    raise MateRuntimeError.cannot_get_size(operand, function, line_number) if !(operand.array? || operand.string?)
  end

  def operation_is_valid(left, right, operator, result, function, line_number)
    raise MateRuntimeError.invalid_operation(left, right, operator, function, line_number) if result.invalid? || result.undefined?
  end

  def var_memory_available(local_size, function, line_number)
    raise MateRuntimeError.insufficient_memory(function, line_number) if local_size > Limits::MAX_VAR_COUNT
  end

  def var_exists(var, function, line_number)
    raise MateRuntimeError.inexistent_var(function, line_number) if var.nil?
  end

  def var_is_valid(var, function, line_number)
    raise MateRuntimeError.invalid_var(function, line_number) if var.type.undefined? || var.type.invalid?
  end
end