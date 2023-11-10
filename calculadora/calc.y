/* Arquivo gerador do Analisador Sintático*/
/* Definições, arquivos necessários, vai vir do flex*/
%{
#include <stdio.h>
#include "lexico.c"
int valor[26];
int yylex(void);
void yyerror(char *);    
%}

/* Terminais*/
%token NUM
%token VAR
%token RECEBE
%token MAIS
%token MENOS
%token VEZES
%token DIV
%token ABRE
%token FECHA
%token ENTER

/* Símbolo de partida*/
%start linha /* variável principal da gramática*/

/* Definindo a associatividade/assertividade*/
%left MAIS MENOS
%left VEZES DIV /* mais embaixo na folha, então, maior precedência*/

%%

/* Gramática*/
/* Variáveis (lado esquerdo da regra)*/
/* Gramática extendida: além de verificar sintaxe, realiza operações*/
linha
    : linha comando ENTER
    | /* ou vazio*/
    ;
comando
    : expr              { printf("result = %d\n", $1); } /* gramática extendida*/
    | VAR RECEBE expr   { valor[$1] = $3; }
    ;
expr
    : NUM               { $$ = $1; }
    | VAR               { $$ = valor[$1]; }
    | expr MAIS expr    { $$ = $1 + $3; }
    | expr MENOS expr   { $$ = $1 - $3; }
    | expr VEZES expr   { $$ = $1 * $3; }
    | expr DIV expr     { $$ = $1 / $3; }
    | ABRE expr FECHA   { $$ = $2; }
    ;

%%

/* Código de Usuário*/
/* Função de erro*/
void yyerror (char *s){
    printf("%s \n", s);
}

int main (void){
    yyparse();
    return 0;
}