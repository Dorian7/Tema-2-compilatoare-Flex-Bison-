%{
#include "tema2.tab.h"

int lineNo = 1;
	int colNo = 1;
 
%}


%%
"+"				{ colNo++; ECHO;return TOK_PLUS; }
"-"				{ colNo++; ECHO;return TOK_MINUS; }
"*"				{ colNo++; ECHO;return TOK_MULTIPLY; }
"DIV"				{ colNo+=3; ECHO;return TOK_DIVIDE; }
"("				{ colNo++; ECHO;return TOK_LEFT; }
")"				{ colNo++; ECHO;return TOK_RIGHT; }
";"				{ colNo++; ECHO;return ';'; }
":="				{ colNo+=2; ECHO;return TOK_ASSIGN; }
"."				{ colNo++; ECHO;return '.'; }
":"				{ colNo++; ECHO;return ':'; }
","				{ colNo++; ECHO;return ','; }
"PROGRAM"                        {colNo+=7; ECHO;return TOK_PROGRAM;}
"VAR"                        {colNo+=3; ECHO;return TOK_VAR;}
"BEGIN"                        {colNo+=5; ECHO;return TOK_BEGIN;}
"END"                        {colNo+=3; ECHO;return TOK_END;}
"INTEGER"                        {colNo+=7; ECHO;return TOK_INTEGER;}
"READ"                        {colNo+=4; ECHO; return TOK_READ;}
"WRITE"                        {colNo+=5; ECHO;return TOK_WRITE;}
"FOR"                        {colNo+=3; ECHO;return TOK_FOR;}
"DO"                        {colNo+=2; ECHO;return TOK_DO;}
"TO"                        {colNo+=2; ECHO;return TOK_TO;}
0|[1-9][0-9]*	{ yylloc.first_line = lineNo; yylloc.first_column = colNo; colNo+=strlen(yytext); yylval.val = atoi(yytext); ECHO;return TOK_int; }

[A-Z][a-zA-Z0-9_]*  { yylloc.first_line = lineNo; yylloc.first_column = colNo; colNo+=strlen(yytext); yylval.sir = new char[strlen(yytext)+1]; strcpy(yylval.sir,yytext); ECHO;return TOK_Nume;}

[a-z][a-zA-Z0-9_]* { yylloc.first_line = lineNo; yylloc.first_column = colNo; colNo+=strlen(yytext); yylval.sir = new char[strlen(yytext)+1]; strcpy(yylval.sir,yytext); ECHO;return TOK_id;}

[ ]				{ colNo++; }
\r\n			{ lineNo++; colNo=1; }
\n				{ lineNo++; colNo=1; }
.				{ colNo++; return TOK_ERROR; }
%%
