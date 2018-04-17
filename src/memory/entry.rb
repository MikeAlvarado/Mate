require 'constants/types'
require 'validators/validate'
module Memory
  class Entry
    attr_reader :position, :inner_entries
    attr_accessor :is_temp, :type
    def initialize(position, type, is_temp = false)
      @position = position
      @type = Type.new(type)
      @is_temp = is_temp
      @inner_entries = []
    end

    def alloc(type)
      Validate::operand_type self, Types::ARRAY
      entry = Entry.new @position, type
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
        "[#{@type.to_s}, %%#{@position}]"
      else
        "[#{@type.to_s}, %%#{@position}, [#{@inner_entries.join(',')}]]"
      end
    end
  end
end