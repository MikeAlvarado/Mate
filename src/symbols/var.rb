require 'validators/mate_error'
require_relative 'base'

module Symbols
  class Var < Base
    attr_reader :is_param
    attr_accessor :is_accessing_an_array, :array_index
    def initialize(name, is_param = false)
    super(name)
      @array_index = nil
      @is_accessing_an_array = false
      @is_param = is_param
    end
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