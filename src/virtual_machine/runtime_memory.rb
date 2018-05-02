require 'byebug'
require 'constants/limits'
require 'ir/var_access'
require 'validators/runtime_validator'
require_relative 'frame'

module VM
  # RuntimeMemory
  # @call_stack   - Stack of frames
  # @var_count    - Number of vars used in all the program
  class RuntimeMemory
    def initialize(origin)
      @call_stack = [Frame.new(origin)]
      @var_count = 0
    end

    def current_frame_name
      @current_frame.name
    end

    def get_value(var_metadata, line_number)
      @current_frame.get_value var_metadata, self, line_number
    end

    def end_frame
      return_to = @current_frame.return_to
      @current_frame = @current_frame.dispatcher
      @call_stack.pop
      return_to
    end

    def new_frame(function)
      RuntimeValidator::frame_memory_available @call_stack.length, @current_frame.name
      @call_stack << Frame.new(function, @current_frame)
    end

    def set_param(param_number, var_value)
      @call_stack.last.set_param param_number, var_value, self
    end

    def set_value(var_metadata, var_value, line_number)
      unless var_metadata.is_temp
        @var_count += 1
        RuntimeValidator::var_memory_available(
          @var_count, @current_frame.name, line_number)
      end
      @current_frame.set_value var_metadata, var_value, self, line_number
    end

    def remove_temp(var_metadata, line_number)
      if !var_metadata.nil? && var_metadata.is_a?(VarAccess) && var_metadata.is_temp
        set_value(var_metadata, nil, line_number)
      end
    end

    def set_return_metadata(return_metadata, instruction_number)
      @call_stack.last.return_to = instruction_number + 1
      @current_frame.pending_return = return_metadata unless return_metadata.nil?
    end

    def set_return(return_value, line_number)
      return_metadata = @current_frame.dispatcher.pending_return
      @current_frame.dispatcher.set_value(
        return_metadata, return_value, self, line_number)
      end_frame
    end

    def start_frame
      @current_frame = @call_stack.last
    end

    def to_s
      str = "MEMORY\ncurrent_frame = #{@current_frame}"
    end
  end
end