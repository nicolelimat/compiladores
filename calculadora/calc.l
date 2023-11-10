/* Arquivo gerador do Analisador Léxico*/
/* Define os símbolos e etc*/

%{
    #include "calc.h"
    #include <stdlib.h>
    void yyerror (char *);
%}

%%
[0-9]+  { yylval = atoi(yytext); return NUM; } /* transforma o caracter num número */
[A-Z]   { yylval = *yytext - 'A'; return VAR; } /* transforma a letra em uma posição */
[a-z]   { yylval = *yytext - 'a'; return VAR; }
"<-"    { return RECEBE; }
"+"     return MAIS;
"-"     return MENOS;
"*"     return VEZES;
"div"   return DIV;
"("     return ABRE;
")"     return FECHA;
\n      return ENTER;

[ \t]+  ;/* saltar espacos e tabulacoes*/
.       yyerror("caracter inválido");
%%

/* Função obrigatória para o próximo*/
int yywrap(void){
    return 1;
}