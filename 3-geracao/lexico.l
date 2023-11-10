/* Arquivo Lexico que vai reconhecer as palavras-chave*/
%{
#include "sintatico.h" /* Gerado pelo bison, prevendo a existência dele*/
int yyerror (char *s); /* String com mensagem de erro*/
int numLinha = 1;
char atomo[100]; /* entidade*/
%}

/* Padroes léxicos*/
identificador [a-zA-z]([a-zA-Z0-9])*
numero        [0-9]+
espaco        [ \t]+
novalinha     [\n]

%x coment

/* Retorna o codigo numerico das palavras-chave*/
%%
programa            return T_PROGRAMA;
inicio              return T_INICIO;
fimprograma         return T_FIM;

leia                return T_LEIA;
escreva             return T_ESCREVA;

se                  return T_SE;
entao               return T_ENTAO;
senao               return T_SENAO;
fimse               return T_FIMSE;

enquanto            return T_ENQTO;
faca                return T_FACA;
fimenquanto         return T_FIMENQTO;

"+"                 return T_MAIS;
"-"                 return T_MENOS;
"*"                 return T_VEZES;
div                 return T_DIV;

">"                 return T_MAIOR; 
"<"                 return T_MENOR; /* testou primero que <-*/
"="                 return T_IGUAL;

e                   return T_E;/* não pode ter uma variável "e" declarada*/
ou                  return T_OU;
nao                 return T_NAO;

"<-"                return T_ATRIB;
"("                 return T_ABRE;
")"                 return T_FECHA;

inteiro             return T_INTEIRO;
logico              return T_LOGICO;
V                   return T_V;
F                   return T_F;

"#".*              /* nada */
"/*"                BEGIN(coment);
<coment>"*/"        BEGIN(INITIAL);
<coment>.           /* nada */
<coment>\n          numLinha++;

{identificador}     { strcpy(atomo, yytext); return T_IDENTIF; } /* pega o id no yytext e copia para atomo*/
{numero}            { strcpy(atomo, yytext); return T_NUMERO; } 
{espaco}            /* nada */ 
{novalinha}         numLinha++;/*contar pra poder identificar erro*/
.                   yyerror ("LEXICO!");

%%
/* Implementação das funções*/
int yywrap () { return 1; }

int yyerror (char *s) {
    printf("ERRO na linha %d: %s\n", numLinha, s);
    exit(100);
}
