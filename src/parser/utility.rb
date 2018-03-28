require 'memory/value'

module Parser
  module Utility
    def self.new_array(val)
      Memory::Value.array val.to_a.flatten.compact
    end
  end
end