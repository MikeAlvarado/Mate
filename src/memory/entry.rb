# On compilation time, the memory manager uses this
# class to allocate and deallocate memory

module Memory
  class Entry
    attr_reader :addr, :is_temp
    def initialize(is_temp: false)
      @addr = nil
      @is_temp = is_temp
    end

    def set_addr(addr)
      @addr = addr
    end

    def to_s
      "%%#{@addr}"
    end
  end
end