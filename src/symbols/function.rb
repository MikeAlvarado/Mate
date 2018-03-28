require 'validators/mate_error'
require_relative 'base'

module Symbols
  class Function < Base
    def undefined_err(scope_name)
      MateError.new "#{Base.message_detail scope_name}"\
      "Error de semántica: la función '#{name}' "\
      "no está definida en el programa."
    end

    def duplicate_err(scope_name)
      MateError.new "#{Base.message_detail scope_name}"\
      "Error de semántica: la función '#{@name}' "\
      "ya está definida."
    end
  end
end