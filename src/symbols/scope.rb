require 'validators/validate'

class Scope
  attr_reader :parent, :name

  def initialize(name, parent = nil)
    @parent = parent
    @symbols = Hash.new
    @name = name
  end

  def new_symbol(symbol)
    Validate::symbol_is_new self, symbol
    @symbols[symbol.name] = symbol
  end

  def symbol?(name, type)
    return true if @symbols.key?(name) && @symbols[name].is_a?(type)
    return false if @parent == nil
    @parent.symbol? name, type
  end
end