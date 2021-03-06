require 'byebug'
require 'constants/limits'
require_relative 'entry'

# Memory - Compile time

module Memory
  # @local_counter    - number of addresses the have been used for local vars
  # @memory           - hash for storing local variables and identifying them with the var name
  # @temp_counter     - number of addresses the have been used for temp vars
  # @temp_memory      - array of temporary variables
  # @deallocated      - array of local var addresses the have been deallocated
  # @temp_deallocated - array of temporary var addresses that have been deallocated
  class Manager
    def initialize
      @local_counter = Limits::LOCAL_START_ADDR
      @memory = Hash.new
      @temp_counter = Limits::TEMP_START_ADDR
      @temp_memory = []
      @deallocated = []
      @temp_deallocated = []
    end

    # Assigns an addresses that has been deallocated or a new address
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

    # Assigns an addresses that has been deallocated or a new address
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

    # If it's a temporary variable, it releases its address
    def dealloc_temp(entry)
      if entry.is_temp
        @temp_memory.delete_at(entry.addr - Limits::TEMP_START_ADDR)
        @temp_deallocated << entry.addr
      end
    end

    # If it's a local variable, it releases its address
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