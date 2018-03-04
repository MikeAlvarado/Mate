class Mate
rule
  program:
    PROGRAM ID L_BRACKET functions R_BRACKET  { puts "Programa compilado" }

  functions:
    function _functions                               {}

  _functions:
    /* empty */                                       {}
    | function _functions                             {}

  function:
    FUNCTION function_id L_PAREN params R_PAREN block {}

  function_id:
    ID                                                {}
    | ORIGIN                                          {}

  params:
    /* empty */                                       {}
    | ID _params                                      {}

  _params:
    /* empty */                                       {}
    | COMMA ID _params                                {}

  block:
    L_BRACKET statements R_BRACKET                    {}

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
    VAR ID more_declarations                          {}

  more_declarations:
    _more_declarations                                {}
    | op_assign _more_declarations                    {}

  _more_declarations:
    /* empty */                                       {}
    | COMMA ID more_declarations                      {}

  var_assign:
    var_value op_assign                               {}

  op_assign:
    OP_ASSIGN expression                              {}

  constant:
    CST_STR                                           {}
    | CST_INT                                         {}
    | CST_DEC                                         {}
    | cst_bool                                        {}

  cst_bool:
    TRUE                                              {}
    | FALSE                                           {}

  var_value:
    ID array_access                                   {}

  array:
    L_SQ_BRACKET values R_SQ_BRACKET                  {}

  values:
    /* empty */                                       {}
    | expression _values                              {}

  _values:
    /* empty */                                       {}
    | COMMA expression _values                        {}

  array_access:
    /* empty */                                       {}
    | L_SQ_BRACKET expression R_SQ_BRACKET            {}

  function_call:
    ID L_PAREN values R_PAREN                         {}

  return:
    RETURN expression                                 {}

  while:
    WHILE condition_block                             {}

  if_else:
    IF condition_block _if_else                       {}

  _if_else:
    /* empty */                                       {}
    | BUT IF NO block                                 {}

  condition_block:
    L_PAREN expression R_PAREN block                  {}

  expression:
    not exp _expression                               {}

  _expression:
    /* empty */                                       {}
    | and_or expression                               {}

  not:
    /* empty */                                       {}
    | OP_NOT                                          {}

  exp:
    item _exp                                         {}

  _exp:
    /* empty */                                       {}
    | logic_op exp                                    {}

  logic_op:
    OP_GREATER                                        {}
    | OP_LESS                                         {}
    | OP_EQUAL                                        {}
    | OP_GREATER_EQUAL                                {}
    | OP_LESS_EQUAL                                   {}
    | OP_NOT_EQUAL                                    {}

  and_or:
    OP_AND                                            {}
    | OP_OR                                           {}

  item:
    term _item                                        {}

  _item:
    /* empty */                                       {}
    | add_subtract item                               {}

  add_subtract:
    OP_ADD                                            {}
    | OP_SUBTRACT                                     {}

  term:
    factor _term                                      {}

  _term:
    /* empty */                                       {}
    | multiply_divide term                            {}

  multiply_divide:
    OP_MULTIPLY                                       {}
    | OP_DIVIDE                                       {}

  factor:
    L_PAREN expression R_PAREN                        {}
    | add_subtract constant                           {}
    | value                                           {}

  value:
    constant                                          {}
    | var_value                                       {}
    | array                                           {}
    | function_call                                   {}

end

---- header

  require_relative 'lexerino'
  $line_number = 0

---- inner

  def parse(input)
    scan_file(input)
  end

  def on_error(t, val, vstack)
    puts "Unexpected token #{val[0].inspect}, #{token_to_str(t) || '?'} found on line #{$line_number}"
  end