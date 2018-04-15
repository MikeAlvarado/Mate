module Memory
  class Entry
    attr_reader :position
    attr_accessor :is_temp, :type
    def initialize(position, type, is_temp = false)
      @position = position
      @type = Type.new(type)
      @is_temp = is_temp
    end

    def to_s
        "[#{@type.to_s}, %%#{@position}]"
    end
  end
end