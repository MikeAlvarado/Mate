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
  ASSIGN        = 13

  class Instance
    include Operators
    def initialize(type)
      @type = type
    end
  
    def equal?
      @type == EQUAL
    end
  
    def not_equal?
      @type == NOT_EQUAL
    end
  
    def less_equal?
      @type == LESS_EQUAL
    end
  
    def greater_equal?
      @type == GREATER_EQUAL
    end
  
    def less?
      @type == LESS
    end
  
    def greater?
      @type == GREATER
    end
  
    def or?
      @type == OR
    end
  
    def and?
      @type == AND
    end
  
    def mod?
      @type == MOD
    end
  
    def multiply?
      @type == MULTIPLY
    end
  
    def divide?
      @type == DIVIDE
    end
  
    def add?
      @type == ADD
    end
  
    def subtract?
      @type == SUBTRACT
    end
  
    def assign?
      @type == ASSIGN
    end
  end
end