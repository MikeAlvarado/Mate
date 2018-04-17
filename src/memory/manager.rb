require 'constants/types'
require_relative 'entry'

module Memory
  class Manager
    FAKE_TEMP_START = 5000
    def initialize
      @fake_counter = 0
      @fake_memory = Hash.new
      @fake_temp_counter = FAKE_TEMP_START
      @fake_temp_memory = []
      @fake_deallocated = []
      @fake_temp_deallocated = []
    end

    def alloc(name, type = Types::UNDEFINED)
      if @fake_deallocated.any?
        position = @fake_deallocated.first
        @fake_deallocated.shift
      else
        position = @fake_counter
        @fake_counter += 1
      end
      entry = Entry.new position, type
      @fake_memory[name] = entry
      return entry
    end

    def alloc_temp(type = Types::UNDEFINED)
      if @fake_temp_deallocated.any?
        position = @fake_temp_deallocated.first
        @fake_temp_deallocated.shift
      else
        position = @fake_temp_counter
        @fake_temp_counter += 1
      end
      entry = Entry.new position, type, true
      @fake_temp_memory[position - FAKE_TEMP_START] = entry
      return entry
    end

    def dealloc(entry)
      if entry.is_temp
        @fake_temp_memory[entry.position] = nil
        @fake_temp_deallocated << entry.position
      else
        @fake_memory[entry.position] = nil
        @fake_deallocated << entry.position
      end
    end

    def get(var)
      if var.is_accessing_an_array
        @fake_memory[var.name].get(var.index)
      else
        @fake_memory[var.name]
      end
    end

    def get_temp(position)
      @fake_temp_memory[position - FAKE_TEMP_START]
    end

    def update(var, type)
      if(var.is_accessing_an_array)
        @fake_memory[var.name].update_entry(var.array_index, type)
      else
        @fake_memory[var.name].type = type
      end
    end
  end
end