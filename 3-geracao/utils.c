// Estruturas Auxiliares

/*
* Tabela de Símbolos 
* -> uma estrura melhor seria a tabela hash
* -> é o gargalo do nosso compilador, as buscas nessa tabela ocorrerão várias vezes
*/ 
#define TAM_TAB 100

struct elemTabSimbolos {
    char id[100]; // nome do indentificador
    int end;      // endereco 
    int tip;      // tipo
} tabSim[TAM_TAB], elemTab;

int posTab; // inidica a próxima posicao livre para inserir

// Rotinas
int buscaSimbolo (char *s){
    int i;
    for (i = posTab -1; strcmp(tabSim[i].id, s) && i >= 0; i--) // posiciona no último elemento e vai decrementando
        ;
    if (i == -1){
        char msg[200];
        sprintf(msg, "Identificador [%s] não encontrado!", s); // sprintf gera e printa um string
        yyerror(msg); // aborta quando chamado (técnica do pânico), diferente de Java e C que tratam o erro
    }
    return i;
}

void insereSimbolo (struct elemTabSimbolos elem){
    int i;
    if (posTab ==  TAM_TAB) 
        yyerror("Tabela de Símbolos cheia!");
    for (i = posTab -1; strcmp(tabSim[i].id, elem.id) && i >= 0; i--)
        ; 
    if (i != -1){
        char msg[200];
        sprintf(msg, "Identificador [%s] duplicado!", elem.id);
        yyerror(msg); 
    }
    tabSim[posTab++] = elem; // insere e depois pula um no posTab
}

// TODO: Retirar símbolos da tabela, descadastrar o nome da tabela
// TODO: Verificar símbolos da tabela

// Pilha Semântica
#define TAM_PIL 100
int pilha[TAM_PIL];
int topo = -1; // vai indicar exatamente onde ele vai inserir

void empilha (int valor){
    if(topo == TAM_PIL)
        yyerror("Pilha semântica cheia!");
    pilha[++topo] = valor;
}

void desempilha (void){
    if(topo == -1)
        yyerror("Pilha semântica vazia!");
    pilha[topo--];
}

