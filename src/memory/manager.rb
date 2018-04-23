require 'byebug'
require 'constants/limits'
require 'constants/types'
require_relative 'entry'

module Memory
  class Manager
    def initialize
      @local_counter = Limits::LOCAL_START_ADDR
      @memory = Hash.new
      @temp_counter = Limits::TEMP_START_ADDR
      @temp_memory = []
      @deallocated = []
      @temp_deallocated = []
    end

    def alloc(name, type = Types::UNDEFINED)
      if @deallocated.any?
        addr = @deallocated.first
        @deallocated.shift
      else
        addr = @local_counter
        @local_counter += 1
      end
      entry = Entry.new addr, type
      @memory[name] = entry
      return entry
    end

    def alloc_temp(type = Types::UNDEFINED)
      if @temp_deallocated.any?
        addr = @temp_deallocated.first
        @temp_deallocated.shift
      else
        addr = @temp_counter
        @temp_counter += 1
      end
      entry = Entry.new addr, type, true
      @temp_memory[addr - Limits::TEMP_START_ADDR] = entry
      return entry
    end

    def dealloc(entry)
      if entry.is_temp
        @temp_memory[entry.addr] = nil
        @temp_deallocated << entry.addr
      else
        @memory[entry.addr] = nil
        @deallocated << entry.addr
      end
    end

    def get(var)
      if var.is_accessing_an_array
        entry = Entry.new @memory[var.name].addr, Types::UNDEFINED
        entry.set_array_access var.array_index
        entry
      else
        @memory[var.name]
      end
    end

    def get_temp(addr)
      @temp_memory[addr - Limits::TEMP_START_ADDR]
    end

    def update(var, type)
      if var.is_accessing_an_array
        entry = Entry.new @memory[var.name].addr, Types::UNDEFINED
        entry.set_array_access var.array_index
        entry
      else
        @memory[var.name].type = type
      end
    end
  end
end