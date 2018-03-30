class Mate
rule
  program:
    PROGRAM ID
    { @parser.def_program val[1] }
    L_BRACKET
    { @parser.def_scope }
    functions R_BRACKET
    {
      @parser.program_complete val[1]
      @parser.del_scope
    }

  functions:
    function _functions                               {}

  _functions:
    /* empty */                                       {}
    | function _functions                             {}

  function:
    FUNCTION function_id L_PAREN params R_PAREN block {}

  function_id:
    ID                                                { @parser.def_func val[0] }
    | ORIGIN                                          { @parser.def_origin }

  params:
    /* empty */                                       {}
    | ID _params
    { @parser.def_param val[0] }

  _params:
    /* empty */                                       {}
    | COMMA ID _params
    { @parser.def_param val[1] }

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
    | function_call                                   {}
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
    expression                                        { }

  constant:
    CST_STR                                           { result = Memory::Value.string val[0] }
    | CST_INT                                         { result = Memory::Value.int val[0].to_i }
    | CST_DEC                                         { result = Memory::Value.float val[0].to_f }
    | cst_bool                                        { result = Memory::Value.bool val[0] }

  cst_bool:
    TRUE                                              { result = true }
    | FALSE                                           { result = false}

  var_value:
    ID array_access                                   { result = val[0] }

  array:
    L_SQ_BRACKET values R_SQ_BRACKET                  { result = Parser::Utility::new_array val[1] }

  values:
    /* empty */                                       {}
    | expression _values                              { result = [val[0], val[1]] }

  _values:
    /* empty */                                       {}
    | COMMA expression _values                        { result = [val[1], val[2]] }

  array_access:
    /* empty */                                       {}
    | L_SQ_BRACKET expression R_SQ_BRACKET            {}

  function_call:
    ID L_PAREN values R_PAREN
    { @parser.call_function val[0] }

  return:
    RETURN expression                                 {}

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

  factor:
    L_PAREN expression R_PAREN                        {}
    | _add_subtract
     value                                            { @parser.new_operand val[1] }

  _add_subtract:
    /* empty */                                       {}
    | add_subtract                                    {}

  value:
    constant                                          { result = val[0] }
    | var_value                                       { result = val[0] }
    | array                                           { result = val[0] }
    | function_call                                   { result = val[0] }

end

---- header
  require_relative 'lexerino'
  require 'memory/value'
  require 'parser/helper'
  require 'parser/utility'
  $line_number = 0

---- inner

  def initialize()
    @parser = Parser::Helper.new
  end
  
  def parse(input)
    scan_file(input)
  end

  def on_error(t, val, vstack)
    puts "Símbolo inesperado #{val.inspect} (#{token_to_str(t) || '?'}) "\
    "en la línea #{$line_number}"
  end
