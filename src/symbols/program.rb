require 'validators/mate_error'
require_relative 'base'

module Symbols
  class Program < Base
    def undefined_err(scope_name)
      MateError.new "#{Base.message_detail scope_name}"\
      "Error de semántica: el programa '#{@name}' "\
      "no está definido."
    end

    def duplicate_err(scope_name)
      MateError.new "#{Base.message_detail scope_name}"\
      "Error de semántica: el programa '#{@name}' "\
      "ya está definido."
    end
  end
end