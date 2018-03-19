module Types
  STRING    = 0
  INT       = 1
  FLOAT     = 2
  BOOL      = 3
  ARRAY     = 4
  UNDEFINED = 5
  
  class Instance
    include Types
  
    def initialize(num)
      @type = num
    end
  
    def to_s
      case @type
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
      @type == STRING
    end
  
    def int?
      @type == INT
    end
  
    def float?
      @type == FLOAT
    end
  
    def bool?
      @type == BOOL
    end
  
    def array?
      @type == ARRAY
    end
  
    def undefined?
      @type == UNDEFINED
    end
  end
end