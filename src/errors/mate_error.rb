class MateError < RuntimeError
  attr_reader :msg
  def initialize(msg)
    @msg = msg
  end

  def self.invalid_operation(left, right, operator)
    MateError.new "Operación inválida: #{left} #{operator} #{right}"
  end

  def self.undefined_function(name)
    MateError.new "Error de semántica: la función '#{name}' "\
    "no está definida en el programa."
  end

  def self.undefined_var(name, function)
    MateError.new "Error de semántica: la variable '#{name}' "\
    "no está definida en el contexto actual en la función '#{function}'."
  end

  def self.duplicate_id(name)
    MateError.new "Error de semántica: identificador duplicado '#{name}'."
  end

  def self.duplicate_var(name, function)
    MateError.new "Error de semántica: la variable '#{name}' "\
      "ya está definida en la función '#{function}'."
  end

  def self.duplicate_function(name)
    MateError.new "Error de semántica: la función '#{name}' "\
      "ya está definida."
  end

end