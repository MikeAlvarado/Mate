class Quadruple
  attr_reader :operator, :left_operand, :right_operand, :result
  def initialize(operator, left_operand, right_operand, result)
    @operator = operator
    @left_operand = left_operand
    @right_operand = right_operand
    @result = result
  end

  def to_s
    "#{@operator}\t#{@left_operand}\t#{@right_operand}\t#{@result}"
  end
end