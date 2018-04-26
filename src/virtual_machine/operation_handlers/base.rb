module VM
  class OperationHandler
    def initialize(left_operand, right_operand, result_metadata, line_number)
      @left_operand = left_operand
      @right_operand = right_operand
      @result_metadata = result_metadata
      @line_number = line_number
    end
  end
end