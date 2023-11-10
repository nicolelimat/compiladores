/* Arquivo da Gramática*/
/* Cabeçalhos*/
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "lexico.c" /* Gerado a partir da ferramenta flex*/
/* int yylex(); Gerado a partir da compilação utilizando o flex, pode ser utilizado o programa lexico.c todo*/
/* int erro (char *s); Rotina de erro, mas ele retirou daqui*/
%}

%start programa

/* Todos os símbolos retornados pelo léxico, terminais*/
%token T_PROGRAMA
%token T_INICIO
%token T_FIM
%token T_LEIA
%token T_ESCREVA
%token T_SE
%token T_ENTAO
%token T_SENAO
%token T_FIMSE
%token T_ENQTO
%token T_FACA
%token T_FIMENQTO
%token T_MAIS
%token T_MENOS
%token T_VEZES
%token T_DIV
%token T_MAIOR
%token T_MENOR
%token T_IGUAL
%token T_E
%token T_OU
%token T_NAO
%token T_ATRIB
%token T_ABRE
%token T_FECHA
%token T_INTEIRO
%token T_LOGICO
%token T_V
%token T_F
%token T_IDENTIF
%token T_NUMERO

/* Definir precedência das operações*/
%left T_E T_OU
%left T_IGUAL
%left T_MAIOR T_MENOR
%left T_MAIS T_MENOS
%left T_VEZES T_DIV

%%

programa
    : cabecalho variaveis T_INICIO lista_comandos T_FIM
    ;

cabecalho
    : T_PROGRAMA T_IDENTIF
    ;

variaveis
    : 
    | declaracao_variaveis
    ;

declaracao_variaveis
    : tipo lista_variaveis declaracao_variaveis
    | tipo declaracao_variaveis
    ;

tipo
    : T_INTEIRO
    | T_LOGICO
    ;

lista_variaveis
    : T_IDENTIF lista_variaveis
    | T_IDENTIF
    ;

lista_comandos
    :
    | comando lista_comandos
    ;

comando
    : entrada_saida
    | escrita
    | repeticao
    | selecao
    | atribuicao
    ;

entrada_saida
    : leitura
    | escrita
    ;

leitura
    : T_LEIA T_IDENTIF
    ;

escrita
    : T_ESCREVA expr
    ;

repeticao
    : T_ENQTO expr T_FACA lista_comandos T_FIMENQTO
    ;

selecao
    : T_SE expr T_ENTAO lista_comandos T_SENAO lista_comandos T_FIMSE
    ;

atribuicao
    : T_IDENTIF T_ATRIB expr
    ;

expr
    : expr T_VEZES expr
    | expr T_DIV expr
    | expr T_MAIS expr
    | expr T_MENOS expr

    | expr T_MAIOR expr
    | expr T_MENOR expr
    | expr T_IGUAL expr

    | expr T_E expr
    | expr T_OU expr

    | termo
    ;

termo
    : T_IDENTIF
    | T_NUMERO
    | T_V
    | T_F
    | T_NAO termo
    | T_ABRE expr T_FECHA
    ;

%%
/* Implementação das funções*/
/* Função que o sintático gera*/
int main () { 
    yyparse();
    printf("Programa ok!\n\n");
    return 0;
}