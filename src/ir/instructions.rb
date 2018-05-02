require 'constants/operators'
module Instructions
  include Operators
  READ          = 15
  WRITE         = 16
  ELEMENT_SIZE  = 17
  GOSUB         = 18
  GOTO          = 19
  GOTOF         = 20
  EOF           = 21 # End of function
  EOP           = 22 # End of program
  ERA           = 23 # Activation record expansion
  PARAM         = 24
  RETURN        = 25
  SOF           = 26

  BINARY_OPERATIONS = (0..12)
  UNARY_OPERATIONS = (13..17)
  JUMP_OPERATIONS = (18..21)
end

class Instruction
  include Instructions
  attr_reader :id
  def initialize(id)
    @id = id
  end

  def binary_operation?
    BINARY_OPERATIONS.cover? @id
  end

  def unary_operation?
    UNARY_OPERATIONS.cover? @id
  end

  def jump_operation?
    JUMP_OPERATIONS.cover? @id
  end

  def return?
    @id == RETURN
  end

  def sof?
    @id == SOF
  end

  def element_size?
    @id == ELEMENT_SIZE
  end

  def write?
    @id == WRITE
  end

  def read?
    @id == READ
  end

  def gosub?
    @id == GOSUB
  end

  def param?
    @id == PARAM
  end

  def era?
    @id == ERA
  end

  def eof?
    @id == EOF
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

  def to_s
    case @id
      when RETURN
        'return'
      when SOF
        'sof'
      when WRITE
        'write'
      when READ
        'read'
      when GOSUB
        'gosub'
      when PARAM
        'param'
      when ERA
        'era'
      when EOF
        'eof'
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
end