# VarAccess
# @addr     - The address of the variable
# @index    - The index the variable is accessing (nil of it's not accessing an array)
# @is_temp  - If the variable is a temporary or a local variable

class VarAccess
  attr_reader :addr, :index, :is_temp
  def initialize (addr:, index: nil, is_temp: false)
    @addr = addr
    @index = index
    @is_temp = is_temp
  end

  def to_s
    index = @index.nil?? '' : " index: #{@index}"
    is_temp = @is_temp? ' is_temp' : ''
    "(%%#{@addr}#{index}#{is_temp})"
  end
end