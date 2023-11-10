lexico: lexico.l;
	flex -t lexico.l > lexico.c;
	gcc lexico.c -o lexico;
	./lexico < programa.simples;
limpa: ;
	rm lexico.c lexico