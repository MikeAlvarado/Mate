require 'byebug'
require 'constants/limits'
require 'ir/var_access'
require 'validators/runtime_validator'
require_relative 'utility'

module VM
# todo: eliminate vars after each scope
  class Frame
    attr_reader :name, :dispatcher
    attr_accessor :pending_return, :return_to
    def initialize(function, dispatcher = nil)
      @dispatcher = dispatcher
      @size = function.var_count
      @name = function.name
      @params = function.params
      @local = []
      @temp = []
    end

    def get_value(var_metadata, memory, line_number)
      value = var_metadata.is_temp ?
        @temp[var_metadata.addr - Limits::TEMP_START_ADDR]
        : @local[var_metadata.addr - Limits::LOCAL_START_ADDR]
      if var_metadata.index.nil?
        value
      else
        array = value
        index = Utility::get_value var_metadata.index, memory, line_number
        array.value[index.value]
      end
    end

    def set_param(param_number, param_value, memory)
      param_metadata = @params[param_number]
      @local[param_metadata.addr - Limits::LOCAL_START_ADDR] = param_value
    end

    def set_value(var_metadata, var_value, memory, line_number)
      limit = var_metadata.is_temp ? Limits::TEMP_START_ADDR : Limits::LOCAL_START_ADDR
      storage = var_metadata.is_temp ? @temp : @local

      if var_metadata.index.nil?
        storage[var_metadata.addr - limit] = var_value
      else
        index = Utility::get_value var_metadata.index, memory, line_number
        storage[var_metadata.addr - limit].value[index.value] = var_value
      end
    end

    def to_s
      local = array_to_s @local
      temp = array_to_s @temp
      "FRAME\nname = #{@name}\tsize = #{@size}\nlocal = #{local}\ntemp = #{temp}\nparams = #{@params}\npending = #{@pending}\n"
    end

    def array_to_s arr
      str = "[#{arr.first}"
      arr.drop(1).each do |val|
        str += ", #{val}"
      end
      str += ']'
    end
  end
end