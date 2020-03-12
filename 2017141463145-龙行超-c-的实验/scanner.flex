import java_cup.runtime.*;
import java.io.*;

%%

%class scanner
%line 
%column 
%cup
%unicode
%state BLOCK_COMMENT STRING

%{
    private String string = "";

    public void println(String text) {
        System.out.println(text);
    }

    public void print(String text) {
        System.out.print(text);
    }

    public Symbol(int type) {
         return new Symbol(type, yyline, yycolumn);
    }

    private Symbol symbol(int type, Object value) {
        return new Symbol(type, yyline, yycolumn, value);
    }

%}

digit = [0-9]
number = {digit}+
float = {digit}+.{digit}+
character = [a-zA-Z]
identifier = (_({character}|{number}|_)+)|{character}({character}|{number}|_)*
comment1 = \/\/[^(\r|\n|\r\n)]*

%%

<YYINITIAL>{
    "const" | "switch" | "for" | "while" | "do" | "if" | "esle" | "int" | "float" | "double" | "char" | "unsigned" | "return" | "void" | "breaak" | "case" {
        println("<keyword>: " + yytext());
        return symbol(sym.KEYWORD);
    }

    "(" | ")" | "{" | "}" | "[" | "]" {
        println("<bracket>: " + yytext());
    }

    \" {
        yybegin(STRING);
    }

    {identifier} {
        println("<identifier>: " + yytext());
    }

    {number} | {float} { 
        println("<number>: " + yytext());
    }

    {comment1} {
        println("<comment>: " + yytext().substring(2));
    }

    "/*" {
        yybegin(BLOCK_COMMENT);
    }

    " "| \t | \r | \n | \r\n {
        print("");
    }

    "+" | "-" | "*" | "/" | "%" {
        println("<operator>: " + yytext());
    }

    "." | "," | ";" | "=" | "++" "--" "+=" {
        println("<" + yytext() + ">");
    }

    ">=" | "<=" | "<" | ">" | "!=" | "==" {
        println("<compare>: " + yytext());
    }

    "&&" | "||" | "!" {
        println("<logic>: " + yytext());
    }  

    "^" | ">>" | "<<" | "~" | "&" | "|" {
        println("<bit>: " + yytext());
    }
}

<BLOCK_COMMENT> {
    \*\/ {
        println("<comment>: " + string);
        string = "";
        yybegin(0);
    }

    . | \r | \n | \r \n {
        string  += yytext();
    }
}

<STRING> {
     \" {
         println("<string>: " + string);
         string = "";
        yybegin(0);
    }

    . | \r | \n | \r \n  {
        string  += yytext();
    }
}

. {
    println("error: unknown " + yytext());
}
