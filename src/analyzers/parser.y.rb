# Parser
# This class parses the program and initiates the line number

# @parser - a helper object with functions that correspond
#  to the grammar

# Whenever a constant is found, it creates a Memory::Value
# with its type and value.

class Mate
rule
  program:
    program_def L_BRACKET functions R_BRACKET
    {
      @parser.program_complete val[0]
    }

  program_def:
    PROGRAM ID
    {
      result = val[1]
      @parser.def_program val[1]
    }

  functions:
    function _functions                               {}

  _functions:
    /* empty */                                       {}
    | function _functions                             {}

  function:
    FUNCTION _function params block
    {
      @parser.func_end
    }

  _function:
    ORIGIN                                            { @parser.def_origin }
    | ID                                              { @parser.def_func val[0] }

  params:
    /* empty */                                       {}
    | L_PAREN _params R_PAREN                         {}

  _params:
    /* empty */                                       {}
    | _param_id more_params                           {}

  more_params:
  /* empty */                                         {}
  | COMMA _param_id more_params                       {}

  _param_id:
    ID                                                { @parser.def_param val[0] }

  block:
    L_BRACKET                                         { @parser.def_scope }
    statements                                        {}
    R_BRACKET                                         { @parser.del_scope }

  statements:
    /* empty */                                       {}
    | statement statements                            {}

  statement:
    simple_statement SEMICOLON                        {}
    | if_else                                         {}
    | while                                           {}

  simple_statement:
    var_declaration                                   {}
    | var_assign                                      {}
    | function_call                                   { @parser.finished_statement_function_call }
    | return                                          {}

  var_declaration:
    VAR ID more_declarations                          { @parser.def_var val[1], val[2] }

  more_declarations:
    _more_declarations                                { result = false }
    | op_assign _more_declarations                    { result = true }

  _more_declarations:
    /* empty */                                       {}
    | COMMA ID more_declarations                      { @parser.def_var val[1], val[2] }

  var_assign:
    var_value op_assign                               { @parser.ass_var val[0] }

  op_assign:
    OP_ASSIGN                                         { @parser.new_operator Operators::ASSIGN }
    expression                                        {}

  constant:
    CST_STR                                           { result = Memory::Value.string val[0]      }
    | CST_INT                                         { result = Memory::Value.int val[0].to_i    }
    | CST_DEC                                         { result = Memory::Value.float val[0].to_f  }
    | cst_bool                                        { result = Memory::Value.bool val[0]        }
    | NIL                                             { result = Memory::Value.undefined          }

  cst_bool:
    TRUE                                              { result = true }
    | FALSE                                           { result = false }

  var_value:
    ID array_access
    {
      result = @parser.handle_var_value val[0], val[1]
    }

  array:
    L_SQ_BRACKET values R_SQ_BRACKET                  { result = Parser::Utility::new_array val[1] }

  values:
    /* empty */                                       {}
    | _array_value _values                            { result = [val[0], val[1]] }

  _values:
    /* empty */                                       {}
    | COMMA _array_value _values                      { result = [val[1], val[2]] }

  _array_value:
    constant                                          { result = val[0] }
    | array                                           { result = val[0] }

  array_access:
    /* empty */                                       { result = false }
    | L_SQ_BRACKET expression R_SQ_BRACKET            { result = true }

  function_call:
    built_in_function_call                            {}
    | custom_function_call                            {}

  built_in_function_call:
    WRITE L_PAREN expression R_PAREN                  { @parser.write }
    | READ L_PAREN R_PAREN                            { @parser.read }
    | SIZE L_PAREN expression R_PAREN                 { @parser.element_size }

  custom_function_call:
    call_name
    L_PAREN
    call_params                                       { @parser.verify_params }
    R_PAREN                                           { @parser.call_func }

  call_name:
    ID                                                { @parser.new_call val[0] }

  call_params:
    /* empty */                                       {}
    | expression                                      { @parser.new_call_param }
    _call_params                                      {}

  _call_params:
    /* empty */                                       {}
    | COMMA                                           {}
    expression                                        { @parser.new_call_param }
    _call_params                                      {}

  return:
    RETURN expression                                 { @parser.func_return }

  while:
    WHILE                                             { @parser.loop_condition_start}
    L_PAREN expression R_PAREN                        { @parser.loop_condition_end }
    block                                             { @parser.loop_end }

  if_else:
    IF L_PAREN expression R_PAREN                     { @parser.if_condition }
    block _if_else                                    { @parser.if_end }

  _if_else:
    /* empty */                                       {}
    | BUT IF NO                                       { @parser.else_start }
    block                                             {}

  expression:
    not exp _expression                               { @parser.eval_negation if val[0] }

  _expression:
    /* empty */                                       {}
    | and_or expression                               { @parser.eval_binary_op }

  not:
    /* empty */                                       { result = false }
    | OP_NOT                                          { result = true }

  exp:
    item _exp                                         { result = val[0] }

  _exp:
    /* empty */                                       {}
    | logic_op exp                                    { @parser.eval_binary_op }

  logic_op:
    OP_GREATER                                        { @parser.new_operator Operators::GREATER }
    | OP_LESS                                         { @parser.new_operator Operators::LESS }
    | OP_EQUAL                                        { @parser.new_operator Operators::EQUAL }
    | OP_GREATER_EQUAL                                { @parser.new_operator Operators::GREATER_EQUAL }
    | OP_LESS_EQUAL                                   { @parser.new_operator Operators::LESS_EQUAL }
    | OP_NOT_EQUAL                                    { @parser.new_operator Operators::NOT_EQUAL }

  and_or:
    OP_AND                                            { @parser.new_operator Operators::AND }
    | OP_OR                                           { @parser.new_operator Operators::OR }

  item:
    term _item                                        {}

  _item:
    /* empty */                                       {}
    | add_subtract item                               { @parser.eval_binary_op }

  add_subtract:
    OP_ADD                                            { @parser.new_operator Operators::ADD }
    | OP_SUBTRACT                                     { @parser.new_operator Operators::SUBTRACT }

  term:
    factor _term                                      {}

  _term:
    /* empty */                                       {}
    | multiply_divide term                            { @parser.eval_binary_op }

  multiply_divide:
    OP_MULTIPLY                                       { @parser.new_operator Operators::MULTIPLY }
    | OP_DIVIDE                                       { @parser.new_operator Operators::DIVIDE }
    | OP_MOD                                          { @parser.new_operator Operators::MOD }

  factor:
    L_PAREN expression R_PAREN                        {}
    | _add_subtract
     value                                            { @parser.new_operand val[1], val[0] unless val[1].nil? }

  _add_subtract:
    /* empty */                                       { result = false }
    | add_subtract                                    { result = true }

  value:
    constant                                          { result = val[0] }
    | var_value                                       { result = val[0] }
    | array                                           { result = val[0] }
    | function_call                                   { result = nil }

end

---- header
  require_relative 'lexerino'
  require 'memory/value'
  require 'parser/helper'
  require 'parser/utility'
  require 'symbols/var'
  $line_number = 0

---- inner

  def initialize(debug)
    $debug = debug.to_i == 1
    @parser = Parser::Helper.new
  end

  def parse(input)
    scan_file(input)
  end

  def on_error(t, val, vstack)
    puts "Símbolo inesperado #{val.inspect} (#{token_to_str(t) || '?'}) "\
    "en la línea #{$line_number}."
  end