require 'validators/mate_error'
require_relative 'base'

module Symbols
  class Var < Base
    def undefined_err(scope_name)
      MateError.new "#{Base.message_detail scope_name}"\
      "Error de semántica: la variable '#{name}' "\
      "no está definida."
    end

    def duplicate_err(scope_name)
      MateError.new "#{Base.message_detail scope_name}"\
      "Error de semántica: la variable '#{name}' "\
      "ya está definida."
    end
  end
end