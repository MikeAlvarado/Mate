module VM
  # Base class for operations
  # @left_operand     - Left operand obtained already from memory
  # @right_operand    - Right operand obtained already from memory
  # @result_metadata  - Result metadata (waiting for operation to set to memory)
  # @line_number      - Line number where the operation is in the program

  class OperationHandler
    def initialize(left_operand, right_operand, result_metadata, line_number)
      @left_operand = left_operand
      @right_operand = right_operand
      @result_metadata = result_metadata
      @line_number = line_number
    end
  end
end