class MateError < RuntimeError
  attr_reader :msg

  def initialize(msg)
    @msg = msg
  end
end