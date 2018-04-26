class MateRuntimeError < RuntimeError
  attr_reader :msg, :function
  def initialize(msg, function)
    @msg = msg
    @function = function
  end

  def self.index_out_of_bounds(function)
    MateRuntimeError.new 'Índice fuera de los límites', function
  end

  def self.invalid_operand_type(operand, type, function)
    MateRuntimeError.new "Se esperaba un operando del tipo #{type} y se obtuvo uno tipo #{operand.type}", function
  end

  def self.invalid_operation(left, right, operator, function)
    MateRuntimeError.new "Operación inválida: #{left} #{operator} #{right}", function
  end

  def self.insufficient_memory(function)
    MateRuntimeError.new 'Memoria insuficiente', function
  end

  def self.inexistent_var(function)
    MateRuntimeError.new 'Variable inexistente', function
  end
end