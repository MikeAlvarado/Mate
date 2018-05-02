require 'byebug'
require 'constants/reserved_words'
require 'constants/types'

module Memory
  class Value
    attr_accessor :value, :type
    def initialize(value, type)
      @value = value
      @type = Type.new(type)
    end

    def self.string(value)
      string_val = value.tr '"','' 
      Value.new "#{string_val}", 0
    end

    def self.int(value)
      Value.new value, 1
    end

    def self.float(value)
      Value.new value, 2
    end

    def self.bool(value)
      Value.new value, 3
    end

    def self.array(value)
      Value.new value, 4
    end

    def self.invalid
      Value.new nil, 5
    end

    def self.undefined
      Value.new nil, 6
    end

    def array_to_s(array)
      str = "[#{array.first.to_s}"
      array.drop(1).each do |val|
        str += ", #{val.to_s}"
      end
      str += ']'
    end

    def to_s
      if @value == true
        ReservedWords::TRUE
      elsif @value == false
        ReservedWords::FALSE
      elsif @type.undefined?
        ReservedWords::NIL
      elsif @type.array?
        array_to_s @value
      else
        "#{@value}"
      end
    end
  end
end