require 'memory/value'
require 'validators/mate_error'

module Parser
  module Utility
    module_function

    def new_array(val)
      Memory::Value.array val.to_a.flatten.compact
    end

    def execute_safely(process)
      begin
        process.call()
      rescue MateError => err
        abort("#{err.msg} Error en la línea #{$line_number}")
      end
    end
  end
end