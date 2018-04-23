require 'byebug'
require 'constants/limits'
require 'validators/runtime_validator'
require_relative 'utility'

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
      @current_frame.set_value var_metadata, var_value, self
    end

    def current_frame_name
      @current_frame.name
    end

    def get_value(var_metadata)
      var_value = @current_frame.get_value var_metadata, self
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

    def set_value(var_metadata, var_value, memory)
      if var_metadata.is_temp
        if var_metadata.is_accessing_an_array
          index = Utility::get_value var_metadata.array_index, memory
          @temp[var_metadata.addr - Limits::TEMP_START_ADDR].value[index.value] = var_value
        else
          @temp[var_metadata.addr - Limits::TEMP_START_ADDR] = var_value
        end
      else
        if var_metadata.is_accessing_an_array
          index = Utility::get_value var_metadata.array_index, memory
          @local[var_metadata.addr - Limits::LOCAL_START_ADDR].value[index.value] = var_value
        else
          @local[var_metadata.addr - Limits::LOCAL_START_ADDR] = var_value
        end
      end
    end

    def get_value(var_metadata, memory)
      if var_metadata.is_temp
        value = @temp[var_metadata.addr - Limits::TEMP_START_ADDR]
      else
        value = @local[var_metadata.addr - Limits::LOCAL_START_ADDR]
      end
      if var_metadata.is_accessing_an_array
        index = Utility::get_value var_metadata.array_index, memory
        RuntimeValidator::index_within_bounds index.value, value.value.length, @name
        value.value[index.value]
      else
        value
      end
    end
  end
end