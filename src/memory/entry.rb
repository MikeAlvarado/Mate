# A variable can be a Symbols::Var which inherits from Entry
# Entry by itself is used for managing memory on compile time

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