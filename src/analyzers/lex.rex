require_relative 'parserino'

class Mate
macro
  BLANK           [\ \t\n]
  LINE_COMMENT    (?:^[\s\t]+)?(\/\/).*$\n?
  BLOCK_COMMENT   \/\*(\*(?!\/)|[^*])*\*\/
rule
  {BLANK}
  {BLOCK_COMMENT}
  {LINE_COMMENT}
  [a-zA-Z\_][\_a-zA-Z0-9]*   { $line_number = lineno; 
                          if text == "programa" then return     [:PROGRAM,  text]
                          elsif text == "funcion" then return   [:FUNCTION, text]
                          elsif text == "origen" then return    [:ORIGIN,   text]
                          elsif text == "var" then return       [:VAR,      text]
                          elsif text == "pero" then return      [:BUT,      text]
                          elsif text == "si" then return        [:IF,       text]
                          elsif text == "no" then return        [:NO,       text]
                          elsif text == "regresa" then return   [:RETURN,   text]
                          elsif text == "mientras" then return  [:WHILE,    text]
                          elsif text == "cierto" then return    [:TRUE,     text]
                          elsif text == "falso" then return     [:FALSE,    text]
                          elsif text == "nulo" then return      [:NIL,      text]
                          elsif text == "escribe" then return   [:WRITE,    text]
                          elsif text == "lee" then return       [:READ,     text]
                          elsif text == "talla" then return     [:SIZE,     text]
                          else return [:ID, text] end }

  [0-9]+\.[0-9]+         { [:CST_DEC,           text.to_f] }
  [0-9]+                 { [:CST_INT,           text.to_i] }
  \"(\\.|[^\"])*\"       { [:CST_STR,           text] }
  ==                     { [:OP_EQUAL,          text] }
  !=                     { [:OP_NOT_EQUAL,      text] }
  \<=                    { [:OP_LESS_EQUAL,     text] }
  \>=                    { [:OP_GREATER_EQUAL,  text] }
  =                      { [:OP_ASSIGN,         text] }
  \<                     { [:OP_LESS,           text] }
  \>                     { [:OP_GREATER,        text] }
  \|\|                   { [:OP_OR,             text] }
  &&                     { [:OP_AND,            text] }
  !                      { [:OP_NOT,            text] }
  %                      { [:OP_MOD,            text] }
  \*                     { [:OP_MULTIPLY,       text] }
  \/                     { [:OP_DIVIDE,         text] }
  \+                     { [:OP_ADD,            text] }
  \-                     { [:OP_SUBTRACT,       text] }
  \(                     { [:L_PAREN,           text] }
  \)                     { [:R_PAREN,           text] }
  \{                     { [:L_BRACKET,         text] }
  \}                     { [:R_BRACKET,         text] }
  \[                     { [:L_SQ_BRACKET,      text] }
  \]                     { [:R_SQ_BRACKET,      text] }
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