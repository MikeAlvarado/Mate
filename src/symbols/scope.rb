require 'constants/reserved_words'
require 'symbols/function'
require 'validators/validate'

class Scope
  attr_reader :parent, :name

  def initialize(name, parent = nil)
    @parent = parent
    @symbols = Hash.new
    @params = Hash.new
    @name = name
    @initial_instruction = nil
    @functions = Hash.new
  end

  def def_func(ir)
    @initial_instruction = ir.get_instruction_number
    @parent.functions[name] = self
  end

  def def_origin
    symbol = Symbols::Function.new ReservedWords::ORIGIN
    Validate::symbol_is_new self, symbol
    @symbols[symbol.name] = symbol
  end

  def new_symbol(symbol)
    Validate::symbol_is_not_reserved symbol
    Validate::symbol_is_new self, symbol
    @symbols[symbol.name] = symbol
  end

  def add_param(symbol)
    Validate::symbol_is_not_reserved symbol
    Validate::symbol_is_new self, symbol
    @params[symbol.name] = symbol
  end

  def symbol?(symbol)
    return true if @symbols.key?(symbol.name) && @symbols[symbol.name].is_a?(symbol.class)
    return false if @parent == nil
    @parent.symbol? symbol
  end
end