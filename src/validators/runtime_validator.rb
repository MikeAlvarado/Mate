require 'constants/limits'
require 'constants/semantic_cube'
require 'constants/types'
require_relative 'mate_runtime_error'

module RuntimeValidator

  module_function

  def frame_memory_available(local_size, function)
    raise MateRuntimeError.insufficient_memory(function) if local_size > Limits::MAX_FRAME_COUNT
  end

  def operand_type(operand, type, function)
    raise MateRuntimeError.invalid_operand_type(operand, Type.new(type), function) if operand.type.id != type
  end

  def operation_is_valid(result_type, function)
    raise MateRuntimeError.invalid_operation(function) if result_type == Types::INVALID || result_type == Types::UNDEFINED
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