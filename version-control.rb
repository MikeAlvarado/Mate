class Mate
rule
  program:
    PROGRAM ID LEFT_BRACKET function RIGHT_BRACKET  { puts "Programa compilado" }

  function:
    FUNCTION function_type LEFT_PARENTHESIS parameter_list RIGHT_PARENTHESIS block {}

  function_type:
    ID                                                {}
    | ORIGIN                                          {}

  parameter_list:
    /* empty */                                       {}
    ID parameter_list1                                {}

  parameter_list1:
    /* empty */                                       {}
    | COMA ID parameter_list1                         {}

  block
    LEFT_BRACKET instruction_list RIGHT_BRACKET       {}

  instruction_list
    /* empty */                                       {}
    | instruction instruction_list                    {}

  instruction:
    var_declaration                                   {}
    var_assign                                        {}
    while                                             {}
    function_call                                     {}
    condition                                         {}
    return                                            {}

  var_declaration
    VAR ID var_declaration_list SEMICOLON             {}

  var_declaration_list
    var_declaration_list1                             {}
    | OP_ASSIGN var_options var_declaration_list1     {}

  var_declaration_list1
    /* empty */                                       {}
    | COMMA ID var_declaration_list                   {}

  var_assign
    var_value OP_ASSIGN var_options SEMICOLON         {}

  var_options
    constant                                          {}
    | arithmetic_op                                   {}
    | logical_op                                      {}
    | function_call                                   {}
    | array                                           {}
    | var_value                                       {}

  array
    LEFT_SQ_BRACKET array_options RIGHT_SQ_BRACKET    {}

  array_options
    /* empty */                                       {}
    | array_options1 array_options2                   {}

  array_options1
    constant                                          {}
    | arithmetic_op                                   {}
    | logical_op                                      {}
    | var_value                                       {}

  array_options2
    /* empty */                                       {}
    | COMMA array_options1 array_options2             {}

  constant
    CST_STRING                                        {}
    | CST_INTEGER                                     {}
    | CST_DECIMAL                                     {}
    | CST_BOOLEAN                                     {}

  var_value
    ID array_access                                   {}
  
  array_access
    /* empty */                                       {}
    | LEFT_SQ_BRACKET array_position RIGHT_SQ_BRACKET {}

  array_position
    arithmetic_op                                     {}
    | CST_INTEGER                                     {}
    | ID                                              {}

  function_call
    ID LEFT_PARENTHESIS function_call_options RIGHT_PARENTHESIS SEMICOLON {}

  function_call_options
    /* empty */                                       {}
    | function_call_options1 function_call_options2   {}

  function_call_options1
    constant                                          {}
    | arithmetic_op                                   {}
    | logical_op                                      {}
    | var_value                                       {}
    | array                                           {}

  function_call_options2
    /* empty */                                       {}
    | COMMA function_call_options1 function_call_options2 {}

  condition
    IF LEFT_PARENTHESIS logical_op RIGHT_PARENTHESIS block condition_else {}

  condition_else
    /* empty */                                       {}
    | ELSE block                                      {}

  return
    RETURN return_options SEMICOLON                    {}

  return_options
    constant                                          {}
    | arithmetic_op                                   {}
    | logical_op                                      {}
    | var_value                                       {}
    | array                                           {}
    | function_call                                   {}

  while
    WHILE LEFT_PARENTHESIS logical_op RIGHT_PARENTHESIS block {}

  arithmetic_exp
    arithmetic_term add_subtract                      {}

  add_subtract
    /* empty */                                       {}
    | OP_ADD arithmetic_exp                           {}
    | OP_SUBTRACT arithmetic_exp                      {}

  arithmetic_term
    arithmetic_op multiply_divide                     {}

  multiply_divide
    /* empty */                                       {}
    | OP_MULTIPLY arithmetic_term                     {}
    | OP_DIVIDE arithmetic_term                       {}

  arithmetic_op
    /* rm empty */                                    {}
    LEFT_PARENTHESIS arithmetic_exp RIGHT_PARENTHESIS {}
    | CST_INTEGER                                     {}
    | CST_DECIMAL                                     {}
    | arithmetic_exp                                  {}
    | var_value                                       {}

  logical_exp
    var_value                                         {}
    | CST_BOOLEAN                                     {}
    | arithmetic_op logical_operators arithmetic_op   {}

  logical_operators
    OP_LESS                                           {}
    | OP_GREATER                                      {}
    | OP_GREATER_EQUAL                                {}
    | OP_LESS_EQUAL                                   {}
    | OP_EQUAL                                        {}
    | OP_NOT_EQUAL                                    {}

  logical_op
    /* rm empty */                                    {}
    LEFT_PARENTHESIS logical_op RIGHT_PARENTHESIS     {}
    | not logical_exp and_or {}

  not
    /* empty */                                       {}
    | OP_NOT                                          {}

  and_or
    /* empty */                                       {}
    | OP_AND logical_op                               {}
    | OP_OR  logical_op                               {}

end

---- header

  require_relative 'lex'
  $line_number = 0

---- inner

  def parse(input)
    scan_file(input)
  end