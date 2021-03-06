# Types
# Constants of the types supported in Mate
module Types
  STRING    = 0
  INT       = 1
  FLOAT     = 2
  BOOL      = 3
  ARRAY     = 4
  INVALID   = 5
  UNDEFINED = 6
end

# Type Class
# Helpful for printing nicely and identifying the value of a type
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
    when INVALID
      'invalid'
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

  def invalid?
    @id == INVALID
  end
end