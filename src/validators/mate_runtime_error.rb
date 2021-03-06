# MateRuntimeError < RuntimeError
# Errors thrown during run time
# @msg          - Error message
# @function     - Function name that contains the error
# @line_number  - Line number of the instruction that threw the error
class MateRuntimeError < RuntimeError
  attr_reader :msg, :function, :line_number
  def initialize(msg, function, line_number = nil)
    @msg = msg
    @function = function
    @line_number = line_number
  end

  def self.cannot_get_size(operand, function, line_number)
    MateRuntimeError.new 'No se puede obtener la talla del operando #{operand}', function, line_number
  end

  def self.index_out_of_bounds(function, line_number)
    MateRuntimeError.new 'Índice fuera de los límites', function, line_number
  end

  def self.invalid_operand_type(operand, type, function, line_number)
    MateRuntimeError.new "Se esperaba un operando del tipo #{type} y se obtuvo uno tipo #{operand.type}", function, line_number
  end

  def self.invalid_operation(left, right, operator, function, line_number)
    MateRuntimeError.new "Operación inválida: #{left} #{operator} #{right}", function, line_number
  end

  def self.insufficient_memory(function, line_number = nil)
    MateRuntimeError.new 'Memoria insuficiente', function, line_number
  end

  def self.inexistent_var(function, line_number)
    MateRuntimeError.new 'Variable inexistente', function, line_number
  end
end