require_relative 'types'
require_relative 'operators'

module SemanticCube
  include Operators, Types

  module_function
  @cube = nil
  def get
    @cube ||= {
      STRING => {
        STRING    => { ADD   => STRING }.merge(logic_ops(STRING, STRING)),
        INT       => { ADD   => STRING }.merge(common(STRING, INT)),
        FLOAT     => { ADD   => STRING }.merge(common(STRING, FLOAT)),
        BOOL      => { }.merge(common(STRING, BOOL)),
        ARRAY     => { }.merge(common(STRING, ARRAY)),
        UNDEFINED => { }.merge(common(STRING, UNDEFINED))
      },
      INT => {
        STRING    => { ADD => STRING }.merge(common(INT, STRING)),
        INT       => { }.merge(logic_ops(INT, INT)).merge(arithmetic_ops(INT)),
        FLOAT     => { }.merge(logic_ops(INT, FLOAT)).merge(arithmetic_ops(FLOAT)),
        BOOL      => { }.merge(common(INT, BOOL)),
        ARRAY     => { }.merge(common(INT, ARRAY)),
        UNDEFINED => { }.merge(common(INT, UNDEFINED))
      },
      FLOAT => {
        STRING    => { ADD => STRING }.merge(common(FLOAT, STRING)),
        INT       => { }.merge(logic_ops(FLOAT, INT)).merge(arithmetic_ops(FLOAT)),
        FLOAT     => { }.merge(logic_ops(FLOAT, FLOAT)).merge(arithmetic_ops(FLOAT)),
        BOOL      => { }.merge(common(FLOAT, BOOL)),
        ARRAY     => { }.merge(common(FLOAT, ARRAY)),
        UNDEFINED => { }.merge(common(FLOAT, UNDEFINED))
      },
      BOOL => {
        STRING    => { }.merge(common(BOOL, STRING)),
        INT       => { }.merge(common(BOOL, INT)),
        FLOAT     => { }.merge(common(BOOL, FLOAT)),
        BOOL      => { }.merge(common(BOOL, BOOL)),
        ARRAY     => { }.merge(common(BOOL, ARRAY)),
        UNDEFINED => { }.merge(common(BOOL, UNDEFINED))
      },
      ARRAY => {
        STRING    => { }.merge(common(ARRAY, STRING)),
        INT       => { }.merge(common(ARRAY, INT)),
        FLOAT     => { }.merge(common(ARRAY, FLOAT)),
        BOOL      => { }.merge(common(ARRAY, BOOL)),
        ARRAY     => { ADD => ARRAY, SUBTRACT => ARRAY }.merge(common(ARRAY, ARRAY)),
        UNDEFINED => { }.merge(common(ARRAY, UNDEFINED))
      },
      UNDEFINED => {
        STRING    => { }.merge(common(UNDEFINED, STRING)),
        INT       => { }.merge(common(UNDEFINED, INT)),
        FLOAT     => { }.merge(common(UNDEFINED, FLOAT)),
        BOOL      => { }.merge(common(UNDEFINED, BOOL)),
        ARRAY     => { }.merge(common(UNDEFINED, ARRAY)),
        UNDEFINED => { }.merge(common(UNDEFINED, UNDEFINED))
      }
    }
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

  def common(right_type, left_type)
    {
      EQUAL => BOOL,
      NOT_EQUAL => BOOL,
      OR => right_type == UNDEFINED ? left_type : right_type,
      AND => right_type == UNDEFINED ? right_type : left_type,
      ASSIGN => right_type
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