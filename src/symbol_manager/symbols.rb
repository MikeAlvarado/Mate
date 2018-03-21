require_relative 'mate_value'
require_relative 'scope'
require 'errors/mate_error'
require 'set'

class Symbols
  attr_accessor :current_scope
  def initialize
    @function = Set.new
    @current_scope = nil
    @current_function_name = ''
    @var_waitlist = []
  end

  def del_scope
    @current_scope = @current_scope.parent unless @current_scope.nil?
  end

  def def_scope
    scope = Scope.new @current_scope
    @current_scope = scope
    unless @var_waitlist.empty?
      @var_waitlist.each do |var|
        def_var var
      end
      @var_waitlist = []
    end
  end

  def waitlist_var(var)
    @var_waitlist << var
  end

  def validate_var_defined(name)
    unless @current_scope.var? name
      raise MateError.undefined_var name, @current_function_name
    end
  end

  def validate_function_defined(name)
    unless @function.include? name
      raise MateError.undefined_function name
    end
  end

  def def_var(name, value = MateValue.undefined)
    if @function.include? name
      raise MateError.duplicate_id name
    end
    if @current_scope.var? name
      raise MateError.duplicate_var name, @current_function_name
    end
    @current_scope.vars[name] = value
  end

  def assign_var(name, value)
    validate_var_defined name
    @current_scope.vars[name] = value
  end

  def def_function(name)
    if @function.include?(name)
      raise MateError.duplicate_function name
    end
    @function.add(name)
    @current_function_name = name
  end

  def pretty_print
    puts @current_function_name
    Scope.pretty_print @current_scope
    puts ''
  end
end