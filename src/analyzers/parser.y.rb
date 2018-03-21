class Mate
rule
  program:
    PROGRAM ID L_BRACKET functions R_BRACKET          { puts 'Programa compilado' }

  functions:
    function _functions                               {}

  _functions:
    /* empty */                                       {}
    | function _functions                             {}

  function:
    FUNCTION function_id L_PAREN params R_PAREN block {}

  function_id:
    ID                                                { def_function val[0] }
    | ORIGIN                                          { def_function val[0] }

  params:
    /* empty */                                       {}
    | ID _params
    { $symbols.waitlist_var(val[0]) }

  _params:
    /* empty */                                       {}
    | COMMA ID _params
    { $symbols.waitlist_var(val[1]) }

  block:
    L_BRACKET                                         { $symbols.def_scope }
    statements                                        {}
    R_BRACKET                                         { $symbols.del_scope }

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
    | return                                          { $returned = true }

  var_declaration:
    VAR ID more_declarations                          { def_var val[1], val[2] }

  more_declarations:
    _more_declarations                                { result = false }
    | op_assign _more_declarations                    { result = true }

  _more_declarations:
    /* empty */                                       {}
    | COMMA ID more_declarations                      { def_var val[1], val[2] }

  var_assign:
    var_value op_assign                               { assign_var(val[0]) }

  op_assign:
    OP_ASSIGN                                         { operators_push Operators::ASSIGN }
    expression                                        { }

  constant:
    CST_STR                                           { result = MateValue.string val[0] }
    | CST_INT                                         { result = MateValue.int val[0].to_i }
    | CST_DEC                                         { result = MateValue.float val[0].to_f }
    | cst_bool                                        { result = MateValue.bool val[0] }

  cst_bool:
    TRUE                                              { result = true }
    | FALSE                                           { result = false}

  var_value:
    ID array_access                                   { result = val[0] }

  array:
    L_SQ_BRACKET values R_SQ_BRACKET                  { result = mate_array(val[1]) }

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
    { validate_function_defined val[0] }

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
    not exp _expression                               { result = val[1] }

  _expression:
    /* empty */                                       {}
    | and_or expression                               {}

  not:
    /* empty */                                       { result = false }
    | OP_NOT                                          { result = true }

  exp:
    item _exp                                         { result = val[0] }

  _exp:
    /* empty */                                       {}
    | logic_op exp                                    { binary_operation }

  logic_op:
    OP_GREATER                                        { operators_push Operators::GREATER }
    | OP_LESS                                         { operators_push Operators::LESS }
    | OP_EQUAL                                        { operators_push Operators::EQUAL }
    | OP_GREATER_EQUAL                                { operators_push Operators::GREATER_EQUAL }
    | OP_LESS_EQUAL                                   { operators_push Operators::LESS_EQUAL }
    | OP_NOT_EQUAL                                    { operators_push Operators::NOT_EQUAL }

  and_or:
    OP_AND                                            { operators_push Operators::AND }
    | OP_OR                                           { operators_push Operators::OR }

  item:
    term _item                                        {}

  _item:
    /* empty */                                       {}
    | add_subtract item                               { binary_operation }

  add_subtract:
    OP_ADD                                            { operators_push Operators::ADD }
    | OP_SUBTRACT                                     { operators_push Operators::SUBTRACT }

  term:
    factor _term                                      {}

  _term:
    /* empty */                                       {}
    | multiply_divide term                            { binary_operation }

  multiply_divide:
    OP_MULTIPLY                                       { operators_push Operators::MULTIPLY }
    | OP_DIVIDE                                       { operators_push Operators::DIVIDE }

  factor:
    L_PAREN expression R_PAREN                        {}
    | _add_subtract
     value                                            { operands_push val[1] }

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
  require 'symbol_manager/mate_value'
  require 'symbol_manager/symbols'
  require 'symbol_manager/constants/operators'
  require 'errors/mate_error'
  $line_number = 0
  $symbols = Symbols.new

---- inner

  def parse(input)
    scan_file(input)
  end

  def execute_safely(process)
    begin
      process.call()
    rescue MateError => err
      abort("#{err.msg} Error en la línea #{$line_number}")
    end
  end

  def def_function(name)
    execute_safely -> () { $symbols.def_function name }
  end

  def def_var(name, assigning)
    execute_safely -> () { $symbols.def_var name }
    assign_var name if assigning
  end

  def assign_var(name)
    execute_safely -> () { $symbols.assign_var name }
  end

  def validate_function_defined(name)
    execute_safely -> () { $symbols.validate_function_defined name }
  end

  def operators_push(operator)
    $symbols.current_scope.operators.push(Operators::Instance.new operator)
  end

  def operands_push(operand)
    $symbols.current_scope.operands.push(operand)
  end

  def binary_operation
    execute_safely -> () { $symbols.current_scope.evaluate_binary_op }
  end

  def mate_array(val)
    MateValue.array val.to_a.flatten.compact
  end

  def on_error(t, val, vstack)
    puts "Símbolo inesperado #{val[0].inspect} (#{token_to_str(t) || '?'}) "\
    "en la línea #{$line_number}"
  end
