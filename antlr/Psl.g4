grammar Psl;
import PslLexerRules;

program : stmtList ;

stmtList : (sepMark stmt)* ;

stmt : letStmt
     | useStmt
     | funcDef
     | typeDef
     | retStmt
     | exprStmt
     ;

letStmt : LET carrier (':' type)? ('=')? entityExpr stmtEnd ;
useStmt : USE carrier ('=')? entityExpr stmtEnd ;
funcDef : annotations modifiers FUNC identRef (superDef)? paramDef ('->' type)? ('=')? LINE_END? stmtPack stmtEnd ;
typeDef : TYPE identRef ('=')? (type | typePack) stmtEnd ;
retStmt : RET (entityExpr)? stmtEnd ;
exprStmt : annotations? entityExpr stmtEnd ;

carrier : entityRef
        | listUnpack
        | dictUnpack
        ;

annotations : (annotation LINE_END)* ;
annotation : '@' (identRef | dictPack | '(' INTEGER ',' INTEGER ')' | '[' INTEGER ',' INTEGER ']') ;
modifiers : ('inner' | 'sync' | 'scoped' | 'static' | 'atomic')* ;
superList : '<' sepMark argument (',' sepMark argument)* sepMark '>' ;
superDef : '<' sepMark keyValDecl (',' sepMark keyValDecl)* sepMark '>' ;
paramDef : '(' sepMark (keyValDecl (',' sepMark keyValDecl)*)? sepMark ')' ;
argument : entityExpr
         | keyValExpr
         ;

typePack : '{' sepMark (keyValDecl (',' sepMark keyValDecl)*)? sepMark '}' ;
keyValDecl : identRef (annotation)? ':' nullableType ('=' entityExpr)? ;
keyValExpr : identRef '=' entityExpr ;

entityRef : identRef ('[' (INTEGER | identRef) ']')* ;
listUnpack : '[' sepMark (identRef (',' sepMark identRef)*)? sepMark ']' ;
dictUnpack : '{' sepMark (identRef (',' sepMark identRef)*)? sepMark '}' ;
dictPack : '{' sepMark (keyValExpr (',' sepMark keyValExpr)*)? sepMark '}' ;
listPack : '[' sepMark (entityExpr (',' sepMark entityExpr)*)? sepMark ']' ;
stmtPack : '{' sepMark (stmtList)? sepMark '}' ;

entityExpr : entityChain ('as' type)? ;
entityChain : chainUnit+ ;
chainUnit : entity
          | linkCall
          ;
entity : (entityRef | functorRef | literal | listPack | dictPack) (annotation)? ;
linkCall : linkCall ('.' | '->') entity
          | functorRef argsList
          | entity
          ;
functorRef: identRef (superList)? ;

stmtEnd : sepMark | ';' ;
sepMark : (LINE_END)* ;


argsList : '(' sepMark (argument (',' sepMark argument)*)? sepMark ')' ;


literal : value
        | STRING
        | MULTI_STR
        | formatStr
        | 'null'
        | 'true'
        | 'false'
        ;
value : (INTEGER | FLOAT_NUMBER | complex) UNIT? ;
formatStr : 'f' STRING ;
complex : INTEGER ('+' | '-') INTEGER 'i'
        | FLOAT_NUMBER ('+' | '-') FLOAT_NUMBER 'i'
        ;


type : innerType
     | identRef
     | 'any'
     ;

innerType : 'number'
          | 'string'
          | 'bool'
          | 'functor'
          | 'block'
          | numberType
          | structType
          ;
numberType : scalarType
           | vectorType
           ;
scalarType : 'int'
           | 'real'
           | 'complex'
           ;
vectorType : 'array' ('<' scalarType '>')? ('[' INTEGER ']')?
           | 'matrix' ('<' scalarType '>')? ('[' INTEGER']')*
              ;
structType : 'list' ('<' nullableType (',' nullableType)* '>')? ('[' INTEGER ']')?
           | 'dict' ('<' type ',' nullableType '>')?
           ;
nullableType : type ('?')? ;

identRef : IDENTIFIER ;

enumDef : 'enum' identRef ('=')? dictUnpack stmtEnd ;