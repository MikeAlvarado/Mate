require 'constants/types'

module Memory
  class Value
    attr_accessor :value, :type
    def initialize(value, type)
      @value = value
      @type = Type.new(type)
    end

    def self.string(value)
      Value.new value, 0
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
      str = "#{@type.to_s} "
      if(@type.array?)
        str += '[' + @value.first.to_s
        @value.drop(1).each do |val|
          str += ", #{val.to_s}"
        end
        str += ']'
      else
        str += @value.to_s
      end
      return str
    end
  end
end