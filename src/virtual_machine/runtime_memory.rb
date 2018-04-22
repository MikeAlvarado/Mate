require 'constants/limits'
require 'validators/runtime_validator'

module VM
  class RuntimeMemory
    def initialize(origin)
      @current_frame = Frame.new origin
      @frame_stack = [@current_frame]
      @var_count = 0
    end

    def set_value(var_metadata, var_value)
      unless(var_metadata.is_temp)
        @var_count += 1
        RuntimeValidator::var_memory_available @var_count, @current_frame.name
      end
      @current_frame.set_value var_metadata, var_value
    end

    def current_frame_name
      @current_frame.name
    end

    def get_value(var_metadata)
      var_value = @current_frame.get_value var_metadata
      RuntimeValidator::var_exists var_metadata, @current_frame.name
      var_value
    end

    def push(function)
      RuntimeValidator::frame_memory_available
      @frame_stack << Frame.new(function)
    end

    def pop
      @frame_stack.pop
    end
  end

  # todo: eliminate vars after each scope
  class Frame
    attr_reader :name
    def initialize(function)
      @size = function.var_count
      @name = function.name
      @local = []
      @temp = []
    end

    def set_value(var_metadata, var_value)
      if var_metadata.is_temp
        @temp[var_metadata.addr - Limits::TEMP_START_ADDR] = var_value
      else
        @local[var_metadata.addr - Limits::LOCAL_START_ADDR] = var_value
      end
    end

    def get_value(var_metadata)
      return @temp[var_metadata.addr - Limits::TEMP_START_ADDR] if var_metadata.is_temp
      @local[var_metadata.addr - Limits::LOCAL_START_ADDR]
    end
  end
end