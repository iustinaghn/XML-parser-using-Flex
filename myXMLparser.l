/* Ghenea Iustina 332CC */

/* Definition section */
%{
#include<stdio.h>

typedef struct{
    char name[100];
    char attr_name[20][100], attr_val[20][100];
    int attrN_ix, attrV_ix;
    char bet_tags_no_attr[100], bet_tags_attr[100];
    int tabs;
}Obj;

Obj* obj;
int ix = 0;
int nr_tabs = 0;
int maximum = 0;
int *list;
int l = 0, iterator = 0;

int computeMax(int maximum, int curr){
     maximum = (maximum < curr) ? curr : maximum;
     return maximum;
}

void printTabs(int tabs){
    for(int i = 0; i < tabs; ++i){
        printf("\t");
    }
}

int findList(Obj* objects){
    int ok = 0;
    for(int i = 0; i <= ix; ++i){
        int l = 0;
        list[l] = i;
        for(int j = i + 1; j <= ix; ++j){
            if(strcmp(objects[i].name, objects[j].name) == 0){
                ok = 1;
                ++l;
                list[l] = j;
            }
        }
        if(ok == 1) return l;
    }
    return 0;
}

void writeFile(Obj obj, int ix){
    printTabs(obj.tabs);

    if(obj.tabs != maximum && ix == list[0])
        printf("<%s>\n", obj.name);

    if(obj.tabs != maximum && ix == list[iterator]){
            if(iterator == 0)
                printTabs(obj.tabs + 1);
            else
                printTabs(obj.tabs - 1);
            printf("<%d>", iterator);
            ++iterator;
     }
    else if(obj.tabs != maximum && ix != list[iterator])
         printf("<%s>", obj.name);
    else if(obj.tabs == maximum && obj.attr_name[0][0] != '\0')
        printf("<%s>", obj.name);
    else if(ix != list[iterator])
        printf("%s", obj.name);

    if(strcmp(obj.bet_tags_no_attr,"") != 0){
        printf(" : %s\n", obj.bet_tags_no_attr);
    }
    else
        printf("\n");

    for(int i = 0; i <= obj.attrN_ix; ++i){
        if(strcmp(obj.attr_name[i], "") != 0){
            if(ix == list[iterator - 1])
                printTabs(obj.tabs + 2);
            else
                printTabs(obj.tabs + 1);
            printf("_%s : %s\n", obj.attr_name[i], obj.attr_val[i]);

            if(strcmp(obj.bet_tags_attr, "") != 0){
                printTabs(obj.tabs + 1);
                printf("__text : %s\n", obj.bet_tags_attr);
            }
        }
    }
}

%}
letter                                  [A-Za-z]
ignoreVersion                           "<?"
endTag                                  ">"
nl		                                (\r\n|\r|\n)
startOpenTag		                    "<"[ ]*
closeTag                                "</"[^>]*>
between_tags                            [^<]*
tag                                     [^>< ]*
comment                                 {startOpenTag}"!--"([^-]|"-"[^-])*"--"{endTag}
value                                   [A-Za-z0-9]

%s IGNORE TAG ATTRIBUTE VALUE BETWEEN_WITHOUT BETWEEN_WITH

%%
        /* ignore the XML version line */
<INITIAL>{ignoreVersion}                {BEGIN(IGNORE);}
<IGNORE>[^>]*                           ;
<IGNORE>{endTag}                        {BEGIN(0);}

        /* ignore comment - single line & multiple line */
{comment}                               ;

<INITIAL>{startOpenTag}                 {ix++; nr_tabs++; maximum = computeMax(maximum, nr_tabs); BEGIN(TAG);}
<TAG>{endTag}                           {BEGIN(0); BEGIN(BETWEEN_WITHOUT);}
<BETWEEN_WITHOUT>{between_tags}         {if(yytext[0] != '\n') strcat(obj[ix].bet_tags_no_attr, yytext); BEGIN(0);}
<TAG>{letter}+" "                       {yyless(yyleng - 1); obj[ix].tabs = nr_tabs;
                                        strcat(obj[ix].name, yytext); BEGIN(ATTRIBUTE);}
<ATTRIBUTE>{letter}+"="                 {yyless(yyleng - 1);
                                        if(yytext[0] != '\n') strcat(obj[ix].attr_name[obj[ix].attrN_ix], yytext);
                                        obj[ix].attrN_ix++; BEGIN(0); BEGIN(VALUE);}
<VALUE>"\""                             ;
<VALUE>{value}+"\""                     {yyless(yyleng - 1);
                                        if(yytext[0] != '\n') strcat(obj[ix].attr_val[obj[ix].attrV_ix], yytext);
                                        obj[ix].attrV_ix++;}
<VALUE>" "                              {BEGIN(ATTRIBUTE);}
<VALUE>">"                              {BEGIN(0); BEGIN(BETWEEN_WITH);}
<BETWEEN_WITH>{between_tags}            {if(yytext[0] != '\n') strcat(obj[ix].bet_tags_attr, yytext); BEGIN(0);}
<TAG>{tag}                              {obj[ix].tabs = nr_tabs; strcat(obj[ix].name, yytext); }
{closeTag}                              {nr_tabs--;}
.|{nl}                                  ;
%%



/* Code */

int yywrap(void){
    return 1;
}

/* show error message */
void yyerror(char *msg){
  fprintf(stderr, "%s\n", msg);
}


int main(int argc, char *argv[]){
    extern FILE *yyin;
    yyin = fopen(argv[1], "r");

    if(!yyin){
        yyerror("Error opening the input file.");
        return 0;
    }

    obj = malloc(100 * sizeof(Obj));
    list = malloc(100 * sizeof(int));
    obj->attrN_ix = 0;
    obj->attrV_ix = 0;
    strcat(obj[ix].name, "root");

    yylex();

    l = findList(obj);
    maximum = (l > 0) ? (maximum + 1) : maximum;
    int tabs_at_list = obj[list[0]].tabs;

    for(int i =  0; i <= ix; ++i){
        if(obj[i].tabs > tabs_at_list)
            obj[i].tabs++;
        writeFile(obj[i], i);
    }
    return 0;
}