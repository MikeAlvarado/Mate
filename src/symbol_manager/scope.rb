class Scope
  attr_reader :vars, :parent

  def initialize(parent = nil)
    @parent = parent
    @vars = Hash.new
  end

  def var(key)
    @vars[key]
  end

  def var?(_var)
    scope = self
    while !scope.nil?
      return true if scope.vars.key? _var
      scope = scope.parent
    end
    return false
  end

  def self.pretty_print(scope)
    pretty_print(scope.parent) unless scope.parent.nil?
    print '  ' unless scope.vars.empty?
    scope.vars.each do |key, value|
      print "#{key}: #{value.nil? ? 'nil' : value}" + "; "
    end
    puts '' unless scope.vars.empty?
  end
end