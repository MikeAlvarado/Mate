class MateError < RuntimeError
  attr_reader :msg
  def initialize(msg)
    @msg = msg
  end

  def self.invalid_operator(operator)
    MateError.new "Operador inválido: #{operator}."
  end

  def self.invalid_operation(left, right, operator)
    MateError.new "Operación inválida: #{left} #{operator} #{right}."
  end

  def self.invalid_operand(operand, type)
    MateError.new "Operando inválido: #{operand}. Se esperaba un tipo #{type}"
  end
end