module Types
  STRING    = 0
  INT       = 1
  FLOAT     = 2
  BOOL      = 3
  ARRAY     = 4
  UNDEFINED = 5
end

class Type
  include Types
  attr_reader :id
  def initialize(num)
    @id = num
  end

  def to_s
    case @id
    when STRING
      'string'
    when INT
      'int'
    when FLOAT
      'float'
    when BOOL
      'bool'
    when ARRAY
      'array'
    when UNDEFINED
      'undefined'
    end
  end

  def string?
    @id == STRING
  end

  def int?
    @id == INT
  end

  def float?
    @id == FLOAT
  end

  def bool?
    @id == BOOL
  end

  def array?
    @id == ARRAY
  end

  def undefined?
    @id == UNDEFINED
  end
end