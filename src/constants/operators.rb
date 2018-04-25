module Operators
  EQUAL         = 0
  NOT_EQUAL     = 1
  LESS_EQUAL    = 2
  GREATER_EQUAL = 3
  LESS          = 4
  GREATER       = 5
  AND           = 6
  OR            = 7
  MOD           = 8
  MULTIPLY      = 9
  DIVIDE        = 10
  ADD           = 11
  SUBTRACT      = 12
  NOT           = 13
  ASSIGN        = 14
end

class Operator
  include Operators
  attr_reader :id
  def initialize(id)
    @id = id
  end

  def to_s
    case @id
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