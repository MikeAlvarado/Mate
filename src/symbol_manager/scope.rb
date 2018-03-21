require_relative 'mate_value'
require_relative 'quadruple'
require_relative 'constants/semantic_cube'

class Scope
  attr_reader :vars, :parent, :quadruples
  attr_accessor :operators, :operands

  def initialize(parent = nil)
    @parent = parent
    @vars = Hash.new
    @operation_type = SemanticCube.get
    @operands = []
    @operators = []
    @quadruples = []
    @temporary_id = 1000
  end

  def get_operand
    # TODO
    # is the operand an id? -> look for it in the scope
    # cannot trust this approach
    op = operands.pop 
    op = self.var op if self.var? op
    return op
  end

  def set_result(id, value, type)
    if (id && self.var?(id))
      self.vars[id].value = -1
      self.vars[id].type = type
    else
      id = @temporary_id
      self.vars[id] = MateValue.new(id, type)
      @temporary_id = @temporary_id + 1
    end
    result = self.var id
    return result
  end

  def test_print(name, value)
    puts "#{name}:\n#{value} \n"
  end

  def validate_operation_type(left, right, operator, result)
    if result == Types::UNDEFINED
      raise MateError.invalid_operation left, right, operator
    end
  end

  def evaluate_binary_op
    right = get_operand
    left = get_operand
    operator = operators.pop
    result_type = @operation_type[left.type.id][right.type.id][operator.id] || Types::UNDEFINED
    validate_operation_type left.type, right.type, operator, result_type

    result_id = @temporary_id
    self.vars[result_id] = MateValue.new(result_id, result_type)
    @temporary_id = @temporary_id + 1

    result = self.vars[result_id]
    @quadruples.push Quadruple.new operator, left, right, result

    # release_addr left.addr if left.temporal
    # release_addr right.addr if right.temporal
    operands.push result
  end

  def validate_assign_operator(operator)
    if operator.id != Operators::ASSIGN
      raise MateError.invalid_operator operator
    end
  end

  def evaluate_assign_op(var_id)
    operand = get_operand
    operator = operators.pop
    validate_assign_operator operator
    self.vars[var_id].value = -1
    self.vars[var_id].type = operand.type
    @quadruples.push Quadruple.new operator, operand, nil, self.vars[var_id]
  end

  def var(key)
    @vars[key]
  end

  def var?(_var)
    scope = self
    while !scope.nil?
      return true if scope.vars.key? _var
      scope = scope.parent
    end
    return false
  end

  def self.print_quadruples(scope)
    puts "Printing quadruples..."
    scope.quadruples.each do |q|
      puts q
    end
  end

  def self.pretty_print(scope)
    pretty_print scope.parent unless scope.parent.nil?
    puts "Printing scope..."
    scope.vars.each do |key, var|
      if scope.var? var
        var = scope.var var
      end
      puts "  #{key}:\t"\
        "#{var.type.undefined? ? 'nil' : var.to_s}; "
    end
  end
end