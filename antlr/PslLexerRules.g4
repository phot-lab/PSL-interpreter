lexer grammar PslLexerRules;
// 纯词法的语法声明
// PSL的词法规则定义，它定义了一些词法规则来识别PSL源码中的不同类型的词法单元。

RET : 'ret';
LET : 'let';
USE : 'use';
FUNC : 'func';
TYPE : 'type';

SKIP_
 : ( BLANK | LIN_CMT1 | LIN_CMT2 | BLK_CMT | LINE_MID ) -> skip
 ;

fragment LINE_MID
 : '\\' ('\r'? '\n')
 ;

LINE_END
 : [\r\n]+
 ;

fragment BLANK
 : [ \t\u000C]+
 ;

fragment LIN_CMT1
 : '//' ~[\r\n]*
 ;

fragment LIN_CMT2
 : '#' ~[\r\n\f]*
 ;

fragment BLK_CMT
 : '/*' .*? '*/'
 ;

MULTI_STR
 : '\'\'\'' ~[']* '\'\'\''
 | '"""' ~["]* '"""'
 ;

IDENTIFIER
 : [a-zA-Z_] [a-zA-Z_0-9]*
 ;

UNIT
 : '`' ~('`')* '`'
 ;

STRING
 : '"' ~["]* '"'
 | '\'' ~[']* '\''
 ;

// 数字定义 ： 整数、浮点数
NUMBER
 : INTEGER
 | FLOAT_NUMBER
 ;

// 整数定义 ： 十进制整数、八进制整数、十六进制整数、二进制整数，暂时只定义十进制整数
INTEGER
 : DECIMAL_INTEGER
// | OCT_INTEGER
// | HEX_INTEGER
// | BIN_INTEGER
 ;

// 浮点数定义 ： 小数或指数形式的浮点数
FLOAT_NUMBER
 : POINT_FLOAT
 | EXPONENT_FLOAT
 ;

// 十进制整数定义 ： 非零数字后面跟随零或者多个数字，或者只有一个零
DECIMAL_INTEGER
 : NON_ZERO_DIGIT DIGIT*
 | '0'+
 ;

// 片段规则，小数定义：它可以是一个整数部分（可选）后跟一个小数点和一个或多个数字，或者只有小数点
fragment POINT_FLOAT
 : INT_PART? FRACTION
 | INT_PART '.'
 ;

// 指数形式的浮点数定义 ： 由整数部分或者小数部分后面跟随一个指数部分组成
fragment EXPONENT_FLOAT
 : ( INT_PART | POINT_FLOAT ) EXPONENT
 ;

// 片段规则，非零数字定义 ： 1-9
fragment NON_ZERO_DIGIT
 : [1-9]
 ;

// 片段规则，数字定义 ： 0-9
fragment DIGIT
 : [0-9]
 ;

// 片段规则，整数部分定义，由一个或多个数字组成
fragment INT_PART
 : DIGIT+
 ;

// 片段规则，小数部分定义，由一个小数点后跟一个或多个数字组成
fragment FRACTION
 : '.' DIGIT+
 ;

// 片段规则，科学计数法指数部分定义，由一个指数符号（e或E）后跟一个可选的正负号和一个或多个数字组成
fragment EXPONENT
 : [eE] [+-]? DIGIT+
 ;
