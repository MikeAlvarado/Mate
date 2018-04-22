require 'constants/types'
require 'validators/validate'
module Memory
  class Entry
    attr_reader :addr, :inner_entries
    attr_accessor :is_temp, :type
    def initialize(addr, type, is_temp = false)
      @addr = addr
      @type = Type.new(type)
      @is_temp = is_temp
      @inner_entries = []
    end

    def alloc(type)
      Validate::operand_type self, Types::ARRAY
      entry = Entry.new @addr, type
      @inner_entries << entry
    end

    def get(index)
      @inner_entries[index]
    end

    def update_entry(index, type)
      @inner_entries[index].type = type
    end

    def to_s
      if(@inner_entries.empty?)
        "[#{@type.to_s}, %%#{@addr}]"
      else
        "[#{@type.to_s}, %%#{@addr}, [#{@inner_entries.join(',')}]]"
      end
    end
  end
end