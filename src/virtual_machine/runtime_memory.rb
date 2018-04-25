require 'byebug'
require 'validators/runtime_validator'
require_relative 'frame'

module VM
  class RuntimeMemory
    def initialize(origin)
      @frame_stack = [Frame.new(origin)]
      @call_stack = []
      @var_count = 0
    end

    def current_frame_name
      @current_frame.name
    end

    def get_value(var_metadata)
      var_value = @current_frame.get_value var_metadata, self
      RuntimeValidator::var_exists var_metadata, @current_frame.name
      var_value
    end

    def end_frame
      @frame_stack.pop
      @current_frame = @frame_stack.last
      return @call_stack.pop unless @frame_stack.empty?
    end

    def new_frame(function)
      push function
    end

    def push(function)
      RuntimeValidator::frame_memory_available @frame_stack.length, @current_frame.name
      @frame_stack << Frame.new(function)
    end

    def set_param(param_number, var_value)
      @frame_stack.last.set_param param_number, var_value, self
    end

    def set_value(var_metadata, var_value)
      unless var_metadata.is_temp
        @var_count += 1
        RuntimeValidator::var_memory_available @var_count, @current_frame.name
      end
      @current_frame.set_value var_metadata, var_value, self
    end

    def set_return_addr(return_metadata, instruction_number)
      @call_stack << instruction_number + 1
      @current_frame.push_pending return_metadata
    end

    def set_return(return_value)
      return_metadata = @frame_stack[-2].pop_pending
      @frame_stack[-2].set_value return_metadata, return_value, self
    end

    def start_frame
      @current_frame = @frame_stack.last
    end
  end
end