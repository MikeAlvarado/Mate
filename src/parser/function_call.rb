require 'validators/validate'
class FunctionCall
  attr_reader :func, :current_param
  def initialize(func)
    @func = func
    @current_param = 0
  end

  def increase_param_counter
    @current_param += 1
  end

  def verify_params
      Validate::params_match @func, @current_param
  end
end