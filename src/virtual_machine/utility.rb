require 'byebug'
require 'ir/var_access'
require 'memory/value'
require 'symbols/var'
require 'validators/mate_runtime_error'

module VM
  module Utility

    module_function

    def get_value(operand, memory, line_number)
      unless operand.nil?
        if operand.is_a?(VarAccess) || operand.is_a?(Symbols::Var)
          memory_entry = memory.get_value operand, line_number
          if memory_entry.nil? ||
            memory_entry.value.nil?
            return Memory::Value.undefined
          else
            return memory_entry
          end
        end
      end
      operand
    end

    def execute_safely(process)
      begin
        process.call()
      rescue Interrupt => err
        puts "¡Adiós!"
      rescue MateRuntimeError => err
        unless err.line_number.nil?
          line_number = " en la línea #{err.line_number}"
        end
        abort "Error corriendo el programa: #{err.msg}. En la función #{err.function}#{line_number}"
      end
    end
  end
end