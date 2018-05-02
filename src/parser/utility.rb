require 'memory/value'
require 'validators/mate_error'

# Parser/Utility

module Parser
  module Utility
    module_function

    # Ruby manages arrays as any program would manage strings
    # Therefore we are taking advantage of that and simplifying
    # our array-management.
    def new_array(val)
      Memory::Value.array val.to_a.flatten.compact
    end

    # Whenever we run a function that validates an operation,
    # we need to run it through execute_safely so that we can
    # rescue the error in case there's any
    def execute_safely(process)
      begin
        process.call()
      rescue MateError => err
        abort("#{err.msg} Error en la línea #{$line_number}")
      end
    end
  end
end