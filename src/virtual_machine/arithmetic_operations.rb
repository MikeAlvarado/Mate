module VM

  module_function

  def execute_arithmetic_operation(instruction)
    case instruction.operator.id
    when Instructions::MOD

    when Instructions::MULTIPLY

    when Instructions::DIVIDE

    when Instructions::ADD

    when Instructions::SUBTRACT
    end
end