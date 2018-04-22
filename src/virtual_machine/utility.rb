require 'memory/value'
require 'validators/mate_runtime_error'

module VM
  module Utility

    module_function

    def get_value(operand, memory)
      unless operand.nil?
        return operand if operand.is_a? Memory::Value
        memory.get_value operand
      end
    end

    def execute_safely(process)
      begin
        process.call()
      rescue MateRuntimeError => err
        abort "Error corriendo el programa: #{err.msg}. En la función #{err.function}"
      end
    end
  end
end