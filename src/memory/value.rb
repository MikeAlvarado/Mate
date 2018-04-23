require 'byebug'
require 'constants/reserved_words'
require 'constants/types'

module Memory
  class Value
    attr_accessor :value, :type, :is_param
    def initialize(value, type, is_param = false)
      @value = value
      @type = Type.new(type) unless is_param
      @is_param = is_param
    end

    def value_to_s(value)
      if value == true
        ReservedWords::TRUE
      elsif value == false
        ReservedWords::FALSE
      else
        "#{value}"
      end
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

    def self.undefined
      Value.new nil, 5
    end

    def to_s
      str = ''
      if @type.array?
        str += "[#{value_to_s @value.first}"
        @value.drop(1).each do |val|
          str += ", #{value_to_s val.value}"
        end
        str += ']'
      else
        str += value_to_s(@value)
      end
      return str
    end
  end
end