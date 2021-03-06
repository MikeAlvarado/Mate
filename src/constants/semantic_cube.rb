require 'byebug'
require_relative 'types'
require_relative 'operators'

# SemanticCube
# Contains the result type of any binary operation between two types
# Since Mate is a losely-typed language, UNDEFINED is a valid type (on compile time)
# therefore all valid operations on any type are also valid on UNDEFINED

module SemanticCube
  include Operators, Types

  module_function
  @cube = nil

  def resolve(left, right, operator)
    @cube ||= {
      STRING => {
        STRING    => { ADD   => STRING }.merge(logic_ops(STRING, STRING)),
        INT       => { ADD   => STRING }.merge(common(STRING, INT)),
        FLOAT     => { ADD   => STRING }.merge(common(STRING, FLOAT)),
        BOOL      => { ADD   => STRING }.merge(common(STRING, BOOL)),
        ARRAY     => { ADD   => STRING }.merge(common(STRING, ARRAY)),
        INVALID   => { }.merge(common(STRING, INVALID)),
        UNDEFINED => { ADD   => STRING }.merge(logic_ops(STRING, UNDEFINED))
      },
      INT => {
        STRING    => { ADD => STRING }.merge(common(INT, STRING)),
        INT       => { }.merge(logic_ops(INT, INT)).merge(arithmetic_ops(INT)),
        FLOAT     => { }.merge(logic_ops(INT, FLOAT)).merge(arithmetic_ops(FLOAT)),
        BOOL      => { }.merge(common(INT, BOOL)),
        ARRAY     => { }.merge(common(INT, ARRAY)),
        INVALID   => { }.merge(common(INT, INVALID)),
        UNDEFINED => { }.merge(logic_ops(INT, UNDEFINED)).merge(arithmetic_ops(UNDEFINED))
      },
      FLOAT => {
        STRING    => { ADD => STRING }.merge(common(FLOAT, STRING)),
        INT       => { }.merge(logic_ops(FLOAT, INT)).merge(arithmetic_ops(FLOAT)),
        FLOAT     => { }.merge(logic_ops(FLOAT, FLOAT)).merge(arithmetic_ops(FLOAT)),
        BOOL      => { }.merge(common(FLOAT, BOOL)),
        ARRAY     => { }.merge(common(FLOAT, ARRAY)),
        INVALID   => { }.merge(common(FLOAT, INVALID)),
        UNDEFINED => { }.merge(logic_ops(FLOAT, UNDEFINED)).merge(arithmetic_ops(UNDEFINED))
      },
      BOOL => {
        STRING    => { ADD   => STRING }.merge(common(BOOL, STRING)),
        INT       => { }.merge(common(BOOL, INT)),
        FLOAT     => { }.merge(common(BOOL, FLOAT)),
        BOOL      => { }.merge(common(BOOL, BOOL)),
        ARRAY     => { }.merge(common(BOOL, ARRAY)),
        INVALID   => { }.merge(common(BOOL, INVALID)),
        UNDEFINED => { }.merge(common(BOOL, UNDEFINED))
      },
      ARRAY => {
        STRING    => { ADD   => STRING }.merge(common(ARRAY, STRING)),
        INT       => { }.merge(common(ARRAY, INT)),
        FLOAT     => { }.merge(common(ARRAY, FLOAT)),
        BOOL      => { }.merge(common(ARRAY, BOOL)),
        ARRAY     => { ADD => ARRAY, SUBTRACT => ARRAY }.merge(common(ARRAY, ARRAY)),
        INVALID   => { }.merge(common(ARRAY, INVALID)),
        UNDEFINED => { ADD => UNDEFINED, SUBTRACT => UNDEFINED }.merge(common(ARRAY, UNDEFINED))
      },
      INVALID => {
        STRING    => { }.merge(common(INVALID, STRING)),
        INT       => { }.merge(common(INVALID, INT)),
        FLOAT     => { }.merge(common(INVALID, FLOAT)),
        BOOL      => { }.merge(common(INVALID, BOOL)),
        ARRAY     => { }.merge(common(INVALID, ARRAY)),
        INVALID   => { }.merge(common(INVALID, INVALID))
      },
      UNDEFINED => {
        STRING    => { ADD => STRING }.merge(common(UNDEFINED, STRING)),
        INT       => { }.merge(logic_ops(UNDEFINED, INT)).merge(arithmetic_ops(UNDEFINED)),
        FLOAT     => { }.merge(logic_ops(UNDEFINED, FLOAT)).merge(arithmetic_ops(UNDEFINED)),
        BOOL      => { }.merge(common(UNDEFINED, BOOL)),
        ARRAY     => { ADD => UNDEFINED, SUBTRACT => UNDEFINED }.merge(common(UNDEFINED, ARRAY)),
        INVALID   => { }.merge(common(UNDEFINED, INVALID)),
        UNDEFINED => { ADD => UNDEFINED, SUBTRACT => UNDEFINED }.merge(logic_ops(UNDEFINED, UNDEFINED)).merge(arithmetic_ops(UNDEFINED))
      }
    }
    @cube[left.type.id][right.type.id][operator.id] || INVALID
  end

  def arithmetic_ops(type)
    {
      MOD => type,
      MULTIPLY => type,
      DIVIDE => type,
      ADD => type,
      SUBTRACT => type
    }
  end

  def common(left_type, right_type)
    {
      EQUAL => BOOL,
      NOT_EQUAL => BOOL,
      OR => right_type == UNDEFINED ? left_type : right_type,
      AND => right_type == UNDEFINED ? right_type : left_type,
    }
  end

  def logic_ops(or_type, and_type)
    {
      LESS_EQUAL => BOOL,
      GREATER_EQUAL => BOOL,
      LESS => BOOL,
      GREATER => BOOL
    }.merge(common(or_type, and_type))
  end

  private :arithmetic_ops, :common, :logic_ops
end