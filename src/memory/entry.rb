require 'constants/types'
require 'validators/validate'
module Memory
  class Entry
    attr_reader :addr, :is_accessing_an_array, :array_index
    attr_accessor :is_temp, :type
    def initialize(addr, type, is_temp = false)
      @addr = addr
      @type = Type.new(type)
      @is_temp = is_temp
      @array_index = nil
      @is_accessing_an_array = false
    end

    def set_array_access(array_index)
      @array_index = array_index
      @is_accessing_an_array = true
    end

    def to_s
      if @is_accessing_an_array
        "#{@type.to_s}, %%#{@addr}-#{@array_index}"
      else
        "[#{@type.to_s}, %%#{@addr}]"
      end
    end
  end
end