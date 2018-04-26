module VM
  class OperationHandler
    def initialize(left_operand, right_operand, result_metadata)
      @left_operand = left_operand
      @right_operand = right_operand
      @result_metadata = result_metadata
    end
  end
end