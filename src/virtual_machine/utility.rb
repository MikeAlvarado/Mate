require 'ir/var_access'
require 'symbols/var'
require 'validators/mate_runtime_error'

module VM
  module Utility

    module_function

    def get_value(operand, memory, line_number)
      unless operand.nil?
        if operand.is_a?(VarAccess) || operand.is_a?(Symbols::Var)
          return memory.get_value operand, line_number
        end
      end
      operand
    end

    def execute_safely(process)
      begin
        process.call()
      rescue MateRuntimeError => err
        unless err.line_number.nil?
          line_number = " en la línea #{err.line_number}"
        end
        abort "Error corriendo el programa: #{err.msg}. En la función #{err.function}#{line_number}"
      end
    end
  end
end