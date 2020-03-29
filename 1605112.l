%{
#include<iostream>
#include<stdlib.h>
#include<string.h>
#include "1605112_SymbolTable.h"
#include "y.tab.h"


using namespace std;

extern YYSTYPE yylval;
extern SymbolTable *table;
void yyerror(char *);

extern int line_count;
extern int error;

char a[1000];
char b[1000];
char com[1000];
int string_line_count=0;
int comment_line_count=0;

%}

%x string
%x substr
%x comment
%x scomment
%x now

digit [0-9]
letter [A-Za-z]
delim [ \t\r\f\v]
newline \n
ws [delim]+
id (_|{letter})(_|{letter}|{digit})*
integer {digit}+
number {digit}*(\.{digit}+)?(E[+-]?{digit}+)?
ADDOP [+-]
MULOP [*/%]

%%

{delim}+	{}
{newline} {line_count++;}

"if" {return IF;}
"else" {return ELSE;}
"for" {return FOR;}
"while" {return WHILE;}
"int" {return INT;}
"float" {return FLOAT;}
"double" {return DOUBLE;}
"char" {return CHAR;}
"return" {return RETURN;}
"void" {return VOID;}
"println"	{return PRINTLN;}
"main" {return ID;}

{ADDOP} {
			SymbolInfo *s= new  SymbolInfo(yytext, "ADDOP");
			yylval.s_info= s;
			return ADDOP;
		}



{MULOP}	{
			SymbolInfo *s= new  SymbolInfo(yytext, "MULOP");
			yylval.s_info = s;
			return MULOP;
		}


"=" 	{return ASSIGNOP;}

">" |
"<" |
">=" |
"<=" |
"==" |
"!=" {
		SymbolInfo *s= new  SymbolInfo(yytext,"RELOP");
		yylval.s_info = s;
		return RELOP;
	}

"&&"	|
"||"	{
			SymbolInfo *s= new  SymbolInfo(yytext,"LOGICOP");
			yylval.s_info = s;
			return LOGICOP;
		}
"!"		{	return NOT; }


";" 	{return SEMICOLON;}

"," 	{return COMMA;}

"(" 	{return LPAREN;}

")" 	{return RPAREN;}

"{" 	{return LCURL;}

"}" 	{return RCURL;}

"[" 	{return LTHIRD;}

"]" 	{return RTHIRD;}

"++" 	{return INCOP;}

"--" 	{return DECOP;}



{integer}	{
				SymbolInfo *s= new  SymbolInfo(yytext, "CONST_INT");
				yylval.s_info = s;
				return CONST_INT;
			}

{number} 	{
				SymbolInfo *s= new  SymbolInfo(yytext,"CONST_FLOAT");
				yylval.s_info = s;
				return CONST_FLOAT;
			}
{id} 		{

				SymbolInfo *s= table->lookup(yytext);
				if(s==NULL)
				{
					s= new SymbolInfo(yytext, "ID");
				}
				yylval.s_info = s;

				return ID;
			}

\"      	{BEGIN(string);strcat(a,yytext);strcat(b,yytext);}
<string>\"		{strcat(a,yytext);strcat(b,yytext);BEGIN(INITIAL);
					//fprintf(tokenout,"<STRING, %s> ",b);
				 	//fprintf(logout,"Line no. %d: TOKEN <STRING> Lexeme %s found\n",line_count,a);
					SymbolInfo*s  = new SymbolInfo(b,"STRING");
					yylval.s_info = s;
				 	memset(a, 0, sizeof(a));memset(b, 0, sizeof(b));return STRING;}
<string>\\		{line_count++;strcat(a,yytext);string_line_count++;BEGIN(substr);}
<string>\\t	  {strcat(b," ");strcat(a,"\\t");}
<string>{letter}+	{ strcat(a,yytext);strcat(b,yytext);}
<string>\n		{//fprintf(logout,"Error at line %d: Unterminated string %s \n",line_count-string_line_count,a);
					BEGIN(INITIAL);
					line_count++;
					error++;string_line_count=0;
					memset(a, 0, sizeof(a));
					memset(b, 0, sizeof(b));
				}

<substr>\n		{BEGIN(string);strcat(a,yytext);}



%%

int yywrap(void)
{
	return 1;
}
