require 'constants/types'
class MateError < RuntimeError
  attr_reader :msg
  def initialize(msg)
    @msg = msg
  end

  def self.reserved_word(symbol)
    MateError.new "Error de semántica: '#{symbol}' es una palabra reservada."
  end

  def self.invalid_operator(operator)
    MateError.new "Operador inválido: #{operator}."
  end

  def self.invalid_operation(left, right, operator)
    MateError.new "Operación inválida: #{left} #{operator} #{right}."
  end

  def self.invalid_operand_type(operand, type)
    MateError.new "Operando inválido: #{operand}. Se esperaba un tipo #{type}."
  end

  def self.invalid_operand_types(operand, types)
    MateError.new "Operando inválido: #{operand}. Se esparaba un tipo [#{types.map{|t| Type.new(t)}.join(', ')}]"
  end

  def self.invalid_operand(operand)
    MateError.new "Operando inválido."
  end
end