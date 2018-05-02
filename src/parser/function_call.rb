require 'validators/validate'

# FunctionCall
# Stores data of the function call being made.

# @func - function being called
# @current_param - number of param being assigned

class FunctionCall
  attr_reader :func, :current_param
  def initialize(func)
    @func = func
    @current_param = 0
  end

  def increase_param_counter
    @current_param += 1
  end

  # We need to verify that the number of params match
  def verify_params
      Validate::params_match @func, @current_param
  end
end