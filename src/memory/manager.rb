require 'byebug'
require 'constants/limits'
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

    def alloc(var_entry)
      if @deallocated.any?
        addr = @deallocated.first
        @deallocated.shift
      else
        addr = @local_counter
        @local_counter += 1
      end
      var_entry.set_addr addr
      @memory[var_entry.name] = var_entry
      var_entry
    end

    def alloc_temp
      if @temp_deallocated.any?
        addr = @temp_deallocated.first
        @temp_deallocated.shift
      else
        addr = @temp_counter
        @temp_counter += 1
      end
      entry = Entry.new is_temp: true
      entry.set_addr addr
      @temp_memory[addr - Limits::TEMP_START_ADDR] = entry
      entry
    end

    def dealloc_temp(entry)
      if entry.is_temp
        @temp_memory.delete_at(entry.addr - Limits::TEMP_START_ADDR)
        @temp_deallocated << entry.addr
      end
    end

    def dealloc(entry)
      unless entry.is_temp
        @memory.delete entry.name
        @deallocated << entry.addr
      end
    end

    def get(name)
      @memory[name]
    end

    def get_temp(addr)
      @temp_memory[addr - Limits::TEMP_START_ADDR]
    end
  end
end