require_relative 'mate_value'
require_relative 'scope'
require_relative 'quadruple'
require 'errors/mate_error'
require 'set'
require_relative 'constants/semantic_cube'
require_relative 'constants/types'

class Symbols
  attr_accessor :operands, :operators
  def initialize
    @function = Set.new
    @current_scope = nil
    @current_function_name = ''
    @var_waitlist = []
    @operation_type = SemanticCube.get
    @operands = []
    @operators = []
    @quadruples = []
    @result = {}
  end

  def get_operand
    op = @operands.pop 
    op = scope.var op if scope.var? op
    return op
  end

  def add_to_quadruple(right, left)
    operator = @operators.pop
    result_type = @operation_type[left.type][right.type][operator]
    @result = MateValue.new -1, result_type

    validate_operation_type left.type, right.type, operator, result_type
    @quadruples.push Quadruple.new operator, left, right, result

    #release_addr left.addr if left.temporal
    #release_addr right.addr if right.temporal
  end

  def evaluate_operation
    right = get_operand
    left = get_operand
    add_to_quadruple right, left
    @operands.push @result
  end

  def evaluate_assign
    left = get_operand
    add_to_quadruple(nil, left)
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

  def validate_operation_type(left, right, operator, result)
    if result == Types::UNDEFINED
      raise MateError.invalid_operation left, right, operator
    end
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