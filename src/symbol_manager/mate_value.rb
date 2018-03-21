require_relative 'constants/types'
class MateValue
  attr_accessor :value, :type
  def initialize(value, type)
    @value = value
    @type = type
  end

  def self.string(value)
    MateValue.new value, Types::Instance.new(0)
  end

  def self.int(value)
    MateValue.new value, Types::Instance.new(1)
  end

  def self.float(value)
    MateValue.new value, Types::Instance.new(2)
  end

  def self.bool(value)
    MateValue.new value, Types::Instance.new(3)
  end

  def self.array(value)
    MateValue.new value, Types::Instance.new(4)
  end

  def self.undefined
    MateValue.new nil, Types::Instance.new(5)
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