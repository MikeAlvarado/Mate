require_relative 'parserino'

class Mate
macro
  BLANK     [\ \t\n]
rule
  {BLANK}
  [a-zA-Z][a-zA-Z0-9]*   { $line_number = lineno; 
                          if text == "programa" then return     [:PROGRAM,  text]
                          elsif text == "funcion" then return   [:FUNCTION, text]
                          elsif text == "origen" then return    [:ORIGIN,   text]
                          elsif text == "var" then return       [:VAR,      text]
                          elsif text == "si" then return        [:IF,       text]
                          elsif text == "si no" then return     [:ELSE,     text]
                          elsif text == "regresa" then return   [:RETURN,   text]
                          elsif text == "mientras" then return  [:WHILE,    text]
                          elsif text == "lee" then return       [:READ,     text]
                          elsif text == "escribe" then return   [:WRITE,    text]
                          elsif text == "concatena" then return [:CONCAT,   text]
                          elsif text == "cierto" then return    [:TRUE,     text]
                          elsif text == "falso" then return     [:FALSE,    text]
                          else return [:ID, text] end }

  [0-9]+\.[0-9]+         { [:CST_DECIMAL,       text.to_f] }
  [0-9]+                 { [:CST_INTEGER,       text.to_i] }
  ".*"                   { [:CST_STRING,        text] }
  =                      { [:OP_ASSIGN,         text] }
  !=                     { [:OP_NOT_EQUAL,      text] }
  ==                     { [:OP_EQUAL,          text] }
  \<                     { [:OP_LESS,           text] }
  \>                     { [:OP_GREATER,        text] }
  \<=                    { [:OP_LESS_EQUAL,     text] }
  \>=                    { [:OP_GREATER_EQUAL,  text] }
  \|\|                   { [:OP_OR,             text] }
  &&                     { [:OP_AND,            text] }
  !                      { [:OP_NOT,            text] }
  %                      { [:OP_MOD,            text] }
  \*                     { [:OP_MULTIPLY,       text] }
  \/                     { [:OP_DIVIDE,         text] }
  \+                     { [:OP_ADD,            text] }
  \-                     { [:OP_SUBTRACT,       text] }
  \(                     { [:LEFT_PARENTHESIS,  text] }
  \)                     { [:RIGHT_PARENTHESIS, text] }
  \{                     { [:LEFT_BRACKET,      text] }
  \}                     { [:RIGHT_BRACKET,     text] }
  \[                     { [:LEFT_SQ_BRACKET,   text] }
  \]                     { [:RIGHT_SQ_BRACKET,  text] }
  ;                      { [:SEMICOLON,         text] }
  ,                      { [:COMMA,             text] }

inner
  def tokenize(code)
    scan_setup(code)
    tokens = []
    while token = next_token
      tokens << token
    end
    tokens
  end
end