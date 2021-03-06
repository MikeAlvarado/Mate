require 'byebug'
require 'constants/reserved_words'
require 'symbols/var'
require 'validators/validate'

# Scope Class
# Every scope has its own variables and can access its parent's variables
# @parent - Scope that created this scope
# @vars   - Hash of variables (key: var name, value: Symbols::Var)
class Scope
  attr_reader :parent, :vars

  def initialize(parent = nil)
    @parent = parent
    @vars = Hash.new
  end

  def def_var(symbol)
    @vars[symbol.name] = symbol
  end

  def def_params(symbols)
    symbols.each {
      |s|
      @vars[s.name] = s
    }
  end

  def var?(name)
    return true if @vars.key?(name)
    return false if @parent == nil
    @parent.var? name
  end

  def to_s
    s = "**** SCOPE ****\n"
    unless @vars.empty?
      s += "\nVARS\n"
      @vars.each {
        |v| s += "#{v}\n"
      }
    end
    s += "\n"
    s
  end
end