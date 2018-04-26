require 'ir/var_access'
require 'symbols/var'
require 'validators/mate_runtime_error'

module VM
  module Utility

    module_function

    def get_value(operand, memory)
      unless operand.nil?
        if operand.is_a?(VarAccess) || operand.is_a?(Symbols::Var)
          return memory.get_value operand
        end
      end
      operand
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