class Mate
rule
  program:
    PROGRAM ID LEFT_BRACKET function RIGHT_BRACKET  { puts "Programa compilado" }

  function:
    FUNCTION function_type LEFT_PARENTHESIS parameter_list RIGHT_PARENTHESIS { puts 'funcion' }

  function_type:
    ID                                                {}
    | ORIGIN                                          {}

  parameter_list:
    /* empty */                                       { puts 'empty!' }
    | ID parameter_list1 ID                           { puts 'id list1' }

  parameter_list1:
    COMMA                                             { puts 'comma' }

  block
    LEFT_BRACKET instruction_list RIGHT_BRACKET       {}

  instruction_list
    /* empty */                                       {}
    | instruction instruction_list                    {}

  instruction:
    var_declaration                                   {}

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
    | var_value                                       {}

  constant
    CST_STRING                                        {}
    | CST_INTEGER                                     {}
    | CST_DECIMAL                                     {}
    | CST_BOOLEAN                                     {}

  var_value
    ID array_access                                   {}
  
  array_access
    /* empty */                                       {}


end

---- header

  require_relative 'lexerino'
  $line_number = 0

---- inner

  def parse(input)
    scan_file(input)
  end

  def on_error(t, val, vstack)
    raise ParseError, sprintf("\nParsing error on value %s (%s) found on line: %i", val[0].inspect, token_to_str(t) || '?', $line_number)
  end