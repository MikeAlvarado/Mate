require 'set'

module ReservedWords
  ORIGIN = 'origen'
  IF = 'si'
  BUT = 'pero'
  NO = 'no'
  READ = 'lee'
  WRITE = 'escribe'
  WHILE = 'mientras'
  PROGRAM = 'programa'
  FUNC = 'funcion'
  VAR = 'var'
  RETURN = 'regresa'
  TRUE = 'cierto'
  FALSE = 'falso'

  module_function
  @words = nil

  def include?(word)
    if @words.nil?
      @words = Set.new
      constants.each do |c|
        @words.add(const_get(c))
      end
    end

    @words.include? word
  end
end