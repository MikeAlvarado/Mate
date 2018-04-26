require 'byebug'
require 'constants/reserved_words'
require 'constants/types'
require 'memory/value'
require 'validators/runtime_validator'
require_relative 'base'

module VM
  class UnaryOperation < OperationHandler
    def execute(operator, memory)
      result_value = _execute operator, memory
      memory.set_value @result_metadata, result_value unless result_value.nil?
    end

    private

    def _execute(operator, memory)
      if operator.assign?
        _assign
      elsif operator.not?
        _not memory
      elsif operator.read?
        _read
      elsif operator.write?
        _write
      end
    end

    def _write
      puts @left_operand
    end

    def _assign
      Memory::Value.new @left_operand.value, @left_operand.type.id
    end

    def _not(memory)
      RuntimeValidator::operand_type(
        @left_operand, Types::BOOL,
        memory.current_frame_name)
      Memory::Value.bool !@left_operand.value
    end

    def _read
      input = STDIN.gets.chomp
      begin
        parse_input(input)
      rescue => msg
        Memory::Value.string input
      end
    end

    def parse_input(input)
      case input
      when ReservedWords::TRUE
        Memory::Value.bool true
      when ReservedWords::FALSE
        Memory::Value.bool false
      when /^[0-9]+\.[0-9]+$/
        Memory::Value.float input.to_f
      when /^[0-9]+$/
        Memory::Value.int input.to_i
      when /^\[.\,.\]$/
        array = input.tr('[', '').tr(']', '').split(',')
        array = array.map { |s| parse_input(s) }
        Memory::Value.array array
      else
        Memory::Value.string input
      end
    end
  end
end