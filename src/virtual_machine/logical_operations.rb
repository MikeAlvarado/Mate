module VM
  module_function
  def execute_logical_operation(instruction)
    case instruction.operator.id
      when Instructions::EQUAL

      when Instructions::NOT_EQUAL

      when Instructions::LESS_EQUAL

      when Instructions::GREATER_EQUAL

      when Instructions::LESS

      when Instructions::GREATER

      when Instructions::AND

      when Instructions::OR

      when Instructions::NOT
    end
  end
end