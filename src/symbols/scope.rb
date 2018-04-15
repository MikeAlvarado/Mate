require 'constants/reserved_words'
require 'symbols/var'
require 'validators/validate'

class Scope
  attr_reader :parent

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

  def var?(symbol)
    return true if @vars.key?(symbol.name)
    return false if @parent == nil
    @parent.var? symbol
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