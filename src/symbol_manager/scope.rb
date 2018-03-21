require_relative 'mate_value'
require_relative 'constants/semantic_cube'

class Scope
  attr_reader :vars, :parent, :temporary_id, :quadruples, :operation_type
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
    puts "operands: #{operands}"
    op = operands.pop 
    op = self.var op if self.var? op
    puts "op: #{op}"
    return op
  end

  def set_result(id, value, type)
    if (id && self.var?(id))
      self.vars[id].value = -1
      self.vars[id].type = type
    else
      id = temporary_id
      self.vars[id] = MateValue.new -1, type
      temporary_id += 1
    end
    result = self.var id
    return result
  end

  def parse_operation(right, left, result_id = nil)
    operator = operators.pop
    result_type = @operation_type[left.type][right.type][operator]
    validate_operation_type left.type, right.type, operator, result_type

    result = set_result(result_id, -1, result_type)
    quadruples.push Quadruple.new operator, left, right, result

    # release_addr left.addr if left.temporal
    # release_addr right.addr if right.temporal
    return result
  end

  def validate_operation_type(left, right, operator, result)
    if result == Types::UNDEFINED
      raise MateError.invalid_operation left, right, operator
    end
  end

  def evaluate_binary_op
    right = get_operand
    left = get_operand
    parse_operation right, left
    operands.push result
  end

  def evaluate_assign_op(var_id)
    left = get_operand
    parse_operation nil, left, var_id
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

  def self.print_quadruples
    puts "Printing quadruples..."
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