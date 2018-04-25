require 'byebug'
require 'constants/limits'
require 'validators/runtime_validator'
require_relative 'utility'

module VM
# todo: eliminate vars after each scope
  class Frame
    attr_reader :name
    def initialize(function)
      @size = function.var_count
      @name = function.name
      @params = function.params
      @pending = []
      @local = []
      @temp = []
    end

    def get_value(var_metadata, memory)
      value = var_metadata.is_temp ?
        @temp[var_metadata.addr - Limits::TEMP_START_ADDR]
        : @local[var_metadata.addr - Limits::LOCAL_START_ADDR]

      if var_metadata.index.nil?
        value
      else
        index = Utility::get_value var_metadata.index, memory
        RuntimeValidator::index_within_bounds index.value, value.value.length, @name
        value.value[index.value]
      end
    end

    def push_pending(var_metadata)
      @pending << var_metadata
    end

    def set_param(param_number, param_value, memory)
      param_metadata = @params[param_number]
      @local[param_metadata.addr - Limits::LOCAL_START_ADDR] = param_value
    end

    def pop_pending
      @pending.pop
    end

    def set_value(var_metadata, var_value, memory)
      limit = var_metadata.is_temp ? Limits::TEMP_START_ADDR : Limits::LOCAL_START_ADDR
      storage = var_metadata.is_temp ? @temp : @local

      if var_metadata.index.nil?
        storage[var_metadata.addr - limit] = var_value
      else
        index = Utility::get_value var_metadata.index, memory
        storage[var_metadata.addr - limit].value[index.value] = var_value
      end
    end
  end
end