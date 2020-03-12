import java_cup.runtime.*;
import java.io.*;

%%
//参数设置和声明段 
%class scanner 
%line 
%column 
%cup
%unicode

%{
    public static void init(){}/**//* Just为了兼容手写版*/
    private Symbol symbol(int type){
        return new Symbol(type,yyline,yycolumn); 
    }
    private Symbol symbol(int type,Object value){
        return new Symbol(type,yyline,yycolumn,value);
    }
%}

LineTerminator=\r|\n|\r\n
WhiteSpace={LineTerminator}|[ \t\f]

%%

<YYINITIAL> {
    "or" {
        return symbol(sym.OR);
    }

    "and" {
        return symbol(sym.AND);
    }

    "not" {
        return symbol(sym.NOT);
    }

    "true" | "false" {
        return symbol(sym.CONSTANT, new Boolean(yytext()));
    }

    ";" {
        return symbol(sym.SEMI);
    }

    "(" {
        return symbol(sym.LBRACKETS);
    }

    ")" {
        return symbol(sym.RBRACKETS);
    }

    {WhiteSpace} {

    }
}

. { 
    System.out.println("Error:"+yytext()+" is illegal!"); 
}