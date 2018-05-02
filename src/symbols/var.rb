require 'memory/entry'
require 'validators/mate_error'

module Symbols
  # Symbols::Var
  # Var inherits from Entry (:addr, :is_temp)
  # @name - Variable name
  class Var < Memory::Entry
    attr_reader :name
    def initialize(name, entry_metadata = {})
      super entry_metadata
      @name = name
    end

    def self.undefined_err(scope_name, name)
      MateError.new "#{Base.message_detail scope_name}"\
      "Error de semántica: la variable '#{name}' "\
      "no está definida."
    end

    def self.duplicate_err(scope_name, name)
      MateError.new "#{Base.message_detail scope_name}"\
      "Error de semántica: la variable '#{name}' "\
      "ya está definida."
    end
  end
end