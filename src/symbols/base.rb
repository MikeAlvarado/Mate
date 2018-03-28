require 'validators/mate_error'

module Symbols
  class Base
    attr_reader :name
    def initialize(name)
      @name = name
    end

    def undefined_err(scope_name)
      MateError.new "#{Base.message_detail scope_name}"\
      "Error de semántica: el símbolo '#{@name}' "\
      "no está definido."
    end

    def duplicate_err(scope_name)
      MateError.new "#{Base.message_detail scope_name}"\
      "Error de semántica: el símbolo '#{@name}' "\
      "ya está definido."
    end

    def self.message_detail(scope_name)
      scope_name.nil? ? "" : "#{scope_name} --> "
    end
  end
end