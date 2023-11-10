/* Arquivo da Gramática*/
/* Cabeçalhos*/
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "lexico.c" /* Gerado a partir da ferramenta flex*/
/* int yylex(); Gerado a partir da compilação utilizando o flex, pode ser utilizado o programa lexico.c todo*/
/* int erro (char *s); Rotina de erro, mas ele retirou daqui*/
#include "utils.c"
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
    : cabecalho variaveis 
        { fprintf(yyout, "\tAMEM\n"); }
     T_INICIO lista_comandos T_FIM
        { fprintf(yyout, "\tDMEM\n"); }
        { fprintf(yyout, "\tFIMP\n"); }
    ;

cabecalho
    : T_PROGRAMA T_IDENTIF
        { fprintf(yyout, "\tINPP\n"); }
    ;

variaveis
    : 
    | declaracao_variaveis
    ;

declaracao_variaveis
    : tipo lista_variaveis declaracao_variaveis
    | tipo lista_variaveis
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
    : /* vazio*/
    | comando lista_comandos
    ;

comando
    : entrada_saida
    | repeticao
    | selecao
    | atribuicao
    ;

entrada_saida
    : entrada
    | saida
    ;

entrada
    : T_LEIA T_IDENTIF
        {
            { fprintf(yyout, "\tLEIA\n"); }
            { fprintf(yyout, "\tARGZ\n"); }
        }
    ;

saida
    : T_ESCREVA expr
        { fprintf(yyout, "\tESCR\n"); }
    ;

atribuicao
    : T_IDENTIF T_ATRIB expr
        { fprintf(yyout, "\tARGZ\n"); }
    ;

selecao
    : T_SE expr T_ENTAO 
        { fprintf(yyout, "\tDSVF\tLx\n"); }
      lista_comandos T_SENAO 
         {
            { fprintf(yyout, "\tDSVS\tLy\n"); }
            { fprintf(yyout, "Lx\tNADA\n"); }
         }
      lista_comandos T_FIMSE
        { fprintf(yyout, "Ly\tNADA\n"); }

    ;

repeticao
    : T_ENQTO 
        { fprintf(yyout, "\tLx\tNADA\n"); }
     expr T_FACA 
        { fprintf(yyout, "\tDSVF\tLy\n"); }
     lista_comandos T_FIMENQTO
        {
            { fprintf(yyout, "\tDSVF\tLx\n"); }
            { fprintf(yyout, "Ly\tNADA\n"); }
        }
    ;

expr
    : expr T_VEZES expr
        { fprintf(yyout, "\tMULT\n"); }
    | expr T_DIV expr
        { fprintf(yyout, "\tDIV\n"); }
    | expr T_MAIS expr
        { fprintf(yyout, "\tSOMA\n"); }
    | expr T_MENOS expr
        { fprintf(yyout, "\tSUBT\n"); }
    | expr T_MAIOR expr
        { fprintf(yyout, "\tCMMA\n"); }
    | expr T_MENOR expr
        { fprintf(yyout, "\tCMME\n"); }
    | expr T_IGUAL expr
        { fprintf(yyout, "\tCMIG\n"); }
    | expr T_E expr
        { fprintf(yyout, "\tCONJ\n"); }
    | expr T_OU expr
        { fprintf(yyout, "\tDISJ\n"); }
    | termo
    ;

termo
    : T_IDENTIF
        { fprintf(yyout, "\tCRGV\n"); }
    | T_NUMERO
        { fprintf(yyout, "\tCRCT\t%s\n", atomo); }
    | T_V
        { fprintf(yyout, "\tCRCT\t1\n"); }
    | T_F
        { fprintf(yyout, "\tCRCT\t0\n"); }
    | T_NAO termo
        { fprintf(yyout, "\tNEGA\n"); }
    | T_ABRE expr T_FECHA
    ;

%%
/* Implementação das funções*/
/* Função que o sintático gera*/
int main (int argc, char *argv[]) { 
    char *p, nameIn[100], nameOut[100];
    argv++; // pular para o proximo nome, pq o primeiro nome eh o do executavel, dpois eh os param
    if(argc < 2){ // se só tiver o nome do executavel, sem os parametros
        puts("\nCompilador da linguagem SIMPLES");
        puts("\n\tUSO: ./simples <NOME>[.simples]\n\n");
        exit(1);
    }
    p = strstr(argv[0], ".simples");// procurar se tem a ext simples
    if (p) *p = 0; // se tem a extensão ele vai apagar
    strcpy(nameIn, argv[0]);
    strcat(nameIn, ".simples");
    strcpy(nameOut, argv[0]);
    strcat(nameOut, ".mvs");
    yyin = fopen(nameIn, "rt");
    if(!yyin){
        puts("Programa fonte não encontrado!");
        exit(2);
    }
    yyout = fopen(nameOut, "wt");
    yyparse();
    printf("Programa ok!\n\n");
    return 0;
}