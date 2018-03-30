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

  def symbol?(symbol)
    return true if @symbols.key?(symbol.name) && @symbols[symbol.name].is_a?(symbol.class)
    return false if @parent == nil
    @parent.symbol? symbol
  end
end