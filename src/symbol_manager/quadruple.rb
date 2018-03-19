class Quadruple
  attr_reader :operator, :left_operand, :right_operand, :result
  def initialize(operator, left_operand, right_operand, result)
    @operator = operator
    @left_operand = left_operand
    @right_operand = right_operand
    @result = result
  end
end