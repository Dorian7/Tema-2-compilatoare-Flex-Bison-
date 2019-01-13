%{
	#include <stdio.h>
     #include <string.h>
#include<malloc.h>

	int yylex();
	int yyerror(const char *mesaj);

     int program_corect = 1;
	char mesaj[200];
 
int numar;

	class TVAR
	{
	     char* nume;
	     int valoare;
	     TVAR* next;
	  
	  public:
	     static TVAR* head;
	     static TVAR* tail;

	     TVAR(char* n, int v = -1);
	     TVAR();
	     int exists(char* n);
             void add(char* n, int v = -1);
             int getValue(char* n);
	     void setValue(char* n, int v);
void afisare();
char * getname();
	};

	TVAR* TVAR::head;
	TVAR* TVAR::tail;

	TVAR::TVAR(char* n, int v)
	{
	 this->nume = new char[strlen(n)+1];
	 strcpy(this->nume,n);
	 this->valoare = v;
	 this->next = NULL;
	}

	TVAR::TVAR()
	{
	  TVAR::head = NULL;
	  TVAR::tail = NULL;
	}

char * TVAR::getname()
{
return nume;}


void TVAR::afisare()
{
 TVAR* tmp = TVAR::head;
	  while(tmp != NULL)
	  {
	       printf("variabila  %s ",tmp->getname());
if(tmp->getValue(tmp->getname())!=-1)
{
printf("are valoare %d \n\n",tmp->getValue(tmp->getname()));
}
else
{
printf("variabila nu a fost initializata inca \n\n");

}
            tmp = tmp->next;
	  }

}
	int TVAR::exists(char* n)
	{
	  TVAR* tmp = TVAR::head;
	  while(tmp != NULL)
	  {
	    if(strcmp(tmp->nume,n) == 0)
	      return 1;
            tmp = tmp->next;
	  }
	  return 0;
	 }

         void TVAR::add(char* n, int v)
	 {
	   TVAR* elem = new TVAR(n, v);
	   if(head == NULL)
	   {
	     TVAR::head = TVAR::tail = elem;
	   }
	   else
	   {
	     TVAR::tail->next = elem;
	     TVAR::tail = elem;
	   }
	 }

         int TVAR::getValue(char* n)
	 {
	   TVAR* tmp = TVAR::head;
	   while(tmp != NULL)
	   {
	     if(strcmp(tmp->nume,n) == 0)
	      return tmp->valoare;
	     tmp = tmp->next;
	   }
	   return -1;
	  }

	  void TVAR::setValue(char* n, int v)
	  {
	    TVAR* tmp = TVAR::head;
	    while(tmp != NULL)
	    {
	      if(strcmp(tmp->nume,n) == 0)
	      {
		tmp->valoare = v;
	      }
	      tmp = tmp->next;
	    }
	  }

	TVAR* ts = NULL;
%}


 

%union { char* sir; int val;  }

%token TOK_PLUS TOK_MINUS TOK_MULTIPLY TOK_DIVIDE TOK_LEFT TOK_RIGHT  TOK_PROGRAM TOK_VAR TOK_BEGIN TOK_END TOK_INTEGER TOK_READ TOK_WRITE 
TOK_FOR TOK_DO TOK_TO TOK_ERROR TOK_ASSIGN TOK_Nume
%token <val> TOK_int
%token <sir> TOK_id

 
 
%type <sir> id_list
%type <val> term
%type <val> factor
%type <val> exp


%start prog
%locations 

%left TOK_PLUS TOK_MINUS
%left TOK_MULTIPLY TOK_DIVIDE

%%
prog : 
	|
TOK_PROGRAM prog_name TOK_VAR dec_list TOK_BEGIN stmt_list TOK_END '.'
 | 
    error ';' 
       { program_corect = 0; }
    ;

prog_name : TOK_Nume;

dec_list : dec
|
dec_list ';' dec ;

dec : id_list ':' type 
{
char *p;
p=strtok($1,",");
while(p!=NULL)
{

if(ts != NULL)
	{
	  if(ts->exists(p) == 0)
	  {
	    ts->add(p);

	  }
	  else
	  {
	       sprintf(mesaj,"Eroare semantica: Declaratii multiple pentru variabila %s!",p);
	    yyerror(mesaj);
	    YYERROR;
	  }
	}
	else
	{
	   ts = new TVAR();
	  ts->add(p);
	}
p=strtok(NULL,",");

}
};

type : TOK_INTEGER ;

id_list : TOK_id  
            |
           id_list ',' TOK_id { 
strcat($1,",");
strcat($1,$3);
};



stmt_list : stmt 
           |
           stmt_list ';' stmt ;

stmt : assign | read | write | for ;

assign : TOK_id TOK_ASSIGN exp  
{ 
 

if(ts != NULL)
	{
	  if(ts->exists($1) == 1)
	  {
	    ts->setValue($1, $3);
	  }
	  else
	  {
	    sprintf(mesaj,"%d:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost declarata!", @1.first_line, @1.first_column, $1);
	    yyerror(mesaj);
	    YYERROR;
	  }
	}
	else
	{
	  sprintf(mesaj,"%d:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost declarata!", @1.first_line, @1.first_column, $1);
	  yyerror(mesaj);
	  YYERROR;
	}

};

exp : term  {  $$=$1;}
| exp TOK_PLUS term  {  $$=$1+$3;} | exp TOK_MINUS term { $$=$1-$3; } ;

term : factor { $$=$1;} | term TOK_MULTIPLY factor {$$=$1 * $3; } | term TOK_DIVIDE factor
{ 
if($3 == 0) 
	  { 
	      sprintf(mesaj,"%d:%d Eroare semantica: Impartire la zero!", @1.first_line, @1.first_column);
	      yyerror(mesaj);
	      YYERROR;
	  } 
	  else { $$ = $1 / $3; } 
  
}
 ;

factor : TOK_id  
{ 
 
if(ts != NULL)
	{
	  if(ts->exists($1) == 1)
	  {
	    if(ts->getValue($1) == -1)
	    {
	      sprintf(mesaj,"%d:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost initializata!", @1.first_line, @1.first_column, $1);
	      yyerror(mesaj);
	      YYERROR;
	    }
	    else
	    {
	      $$=ts->getValue($1);
	    }
	  }
	  else
	  {
	    sprintf(mesaj,"%d:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost declarata!", @1.first_line, @1.first_column, $1);
	    yyerror(mesaj);
	    YYERROR;
	  }
	}
	else
	{
	  sprintf(mesaj,"%d:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost declarata!", @1.first_line, @1.first_column, $1);
	  yyerror(mesaj);
	  YYERROR;
	}

}
| TOK_int { $$=$1;  } | TOK_LEFT exp TOK_RIGHT {  $$ = $2;  } ;



read : TOK_READ TOK_LEFT id_list TOK_RIGHT  

{  
char *p;
 

p=strtok($3,",");
while(p!=NULL)
{

if(ts != NULL)
	{
	  if(ts->exists(p) == 1)
	  {
	    printf("\n variabila poate fi citita \n ");
ts->setValue(p,10);
	  }
	  else
	  {
	    sprintf(mesaj,"Variabila %s nu a fost declarata inca!" ,p);
	    yyerror(mesaj);
	    YYERROR;
	  }
	}
	else
	{
	   
	    sprintf(mesaj,"Variabila %s nu a fost declarata inca!" ,p);
	    yyerror(mesaj);
	    YYERROR;
	}
p=strtok(NULL,",");
}
  
}
 
;

write : TOK_WRITE TOK_LEFT id_list TOK_RIGHT 
{

char *p=strtok($3,",");
while(p!=NULL)
{ 

if(ts != NULL)
	{
	  if(ts->exists(p) == 1)
	  {
	    if(ts->getValue(p) == -1)
	    {
	      sprintf(mesaj,"Eroare semantica: Variabila %s este utilizata fara sa fi fost initializata!", p);
	      yyerror(mesaj);
	      YYERROR;
	    }
	    else
	    {
	      printf("%d\n",ts->getValue(p));
	    }
	  }
	  else
	  {
	    sprintf(mesaj,"Eroare semantica: Variabila %s este utilizata fara sa fi fost declarata!", p);
	    yyerror(mesaj);
	    YYERROR;
	  }
	}
	else
	{
	  sprintf(mesaj,"Eroare semantica: Variabila %s este utilizata fara sa fi fost declarata!", p);
	  yyerror(mesaj);
	  YYERROR;
	}

p=strtok(NULL,",");
}

 
}
 ;

for : TOK_FOR index_exp TOK_DO body 

;

index_exp : TOK_id TOK_ASSIGN exp TOK_TO exp {


if(ts != NULL)
	{
	  if(ts->exists($1) == 0)
	  {
	   sprintf(mesaj," Variabila nu a fost declarata %s!",$1);

	  }
	 
	}
	else
	{
	   sprintf(mesaj,"Variabila nu a fost declarata %s!",$1);  
	}



};

body : stmt | TOK_BEGIN stmt_list TOK_END ;
 

%%

int main()
{
	yyparse();
	
	if(program_corect == 1)
	{
		printf("CORECT\n");	
	ts->afisare();
	}
else
{
printf("INCORECT\n");
//ts->afisare();
}	

       return 0;
}

int yyerror(const char *mesaj)
{
	printf("Error: %s\n", mesaj);
	return 1;
}
