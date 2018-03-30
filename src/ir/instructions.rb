require 'constants/operators'
module Instructions
  include Operators
  GOTO          = 15
  GOTOF         = 16
  EOP           = 17 # End of program
end

class Instruction
  include Instructions
  attr_reader :id
  def initialize(id)
    @id = id
  end

  def to_s
    case @id
      when EOP
        'eop'
      when GOTO
        'goto'
      when GOTOF
        'gotof'
      when EQUAL
        '=='
      when NOT_EQUAL
        '!='
      when LESS_EQUAL
        '<='
      when GREATER_EQUAL
        '>='
      when LESS
        '<'
      when GREATER
        '>'
      when AND
        '&&'
      when OR
        '||'
      when MOD
        '%'
      when MULTIPLY
        '*'
      when DIVIDE
        '/'
      when ADD
        '+'
      when SUBTRACT
        '-'
      when ASSIGN
        '='
      when NOT
        '!'
    end
  end

  def eop?
    @id == EOP
  end

  def goto?
    @id == GOTO
  end

  def gotof?
    @id == GOTOF
  end

  def equal?
    @id == EQUAL
  end

  def not_equal?
    @id == NOT_EQUAL
  end

  def less_equal?
    @id == LESS_EQUAL
  end

  def greater_equal?
    @id == GREATER_EQUAL
  end

  def less?
    @id == LESS
  end

  def greater?
    @id == GREATER
  end

  def or?
    @id == OR
  end

  def and?
    @id == AND
  end

  def mod?
    @id == MOD
  end

  def multiply?
    @id == MULTIPLY
  end

  def divide?
    @id == DIVIDE
  end

  def add?
    @id == ADD
  end

  def subtract?
    @id == SUBTRACT
  end

  def assign?
    @id == ASSIGN
  end

  def not?
    @id == NOT
  end
end