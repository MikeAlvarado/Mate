require_relative 'scope'
require 'errors/mate_error'
require 'set'

class Symbols
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
    scope = Scope.new(@current_scope)
    @current_scope = scope
    unless @var_waitlist.empty?
      @var_waitlist.each do |var|
        def_var(var)
      end
      @var_waitlist = []
    end
  end

  def waitlist_var(var)
    @var_waitlist << var
  end

  def def_var(name, value = nil)
    if @function.include?(name)
      raise MateError.new "Error de semántica: identificador duplicado '#{name}'."
    end
    if @current_scope.var?(name)
      raise MateError.new "Error de semántica: la variable '#{name}' "\
      "ya está definida en la función '#{@current_function_name}'."
    end
    @current_scope.vars[name] = value
  end

  def def_function(name)
    if @function.include?(name)
      raise MateError.new "Error de semántica: la función '#{name}' "\
      "ya está definida."
    end
    @function.add(name)
    @current_function_name = name
  end

  def pretty_print
    puts @current_function_name
    Scope.pretty_print(@current_scope)
    puts ''
  end
end