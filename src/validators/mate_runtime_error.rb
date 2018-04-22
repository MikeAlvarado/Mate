class MateRuntimeError < RuntimeError
  attr_reader :msg, :function
  def initialize(msg, function)
    @msg = msg
    @function = function
  end

  def self.invalid_operand_type(operand, type, function)
    MateRuntimeError.new "Se esperaba un operando del tipo #{type} y se obtuvo uno tipo #{operand.type}", function
  end

  def self.invalid_operation(function)
    MateRuntimeError.new 'Operación inválida', function
  end

  def self.insufficient_memory(function)
    MateRuntimeError.new 'Memoria insuficiente', function
  end

  def self.inexistent_var(function)
    MateRuntimeError.new 'Variable inexistente', function
  end
end