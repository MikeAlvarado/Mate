# Quadruple Class
# Every instruction is created as a quadruple
# It's actually a quintiple because we added the
# line_number in the late stages of development

# @operator       - Instruction
# @left_operand   - Left operand
# @right_operand  - Right operand
# @result         - The variable where the result of an operation should be stored
class Quadruple
  attr_reader :operator, :left_operand, :result, :line_number
  attr_accessor :right_operand
  def initialize(operator, left_operand, right_operand, result)
    @operator = operator
    @left_operand = left_operand
    @right_operand = right_operand
    @result = result
    @line_number = $line_number
  end

  def to_s
    "#{@operator.to_s.ljust(4, ' ')}\t#{@left_operand.to_s.ljust(20, ' ')}\t#{@right_operand.to_s.ljust(20, ' ')}\t#{@result.to_s.ljust(20, ' ')}"
  end
end