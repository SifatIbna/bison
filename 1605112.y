%{
#include<iostream>
#include<cstdio>
#include<cstdlib>
#include<cstring>
#include<cmath>
#include "1605112_SymbolTable.h"
//#define YYSTYPE SymbolInfo*


    using namespace std;

    int yyparse(void);
    int yylex(void);
    extern FILE *yyin;
    FILE *fp;
    FILE *error=fopen("error.txt","w");
    FILE *logfile= fopen("logfile.txt","w");

    vector<SymbolInfo*>parameter_list;
    vector<SymbolInfo*>declared_list;
    vector<SymbolInfo*>argument_list;

    int line_count=1;
    int error_count=0;

    SymbolTable *table=new SymbolTable(100,logfile);

    void yyerror(char *s)
    {
        fprintf(stderr,"Line no %d : %s\n",line_count,s);

    }

    void printFile(int count,string statement)
    {
        fprintf(logfile,"Line at %d : %s \n\n",line_count,statement.c_str());
    }

    void printFileString(string statement)
    {

        fprintf(logfile,"%s\n\n",statement.c_str());
    }

    void printFileDoubleString(string statement1,string statement2)
    {
        fprintf(logfile,"%s %s\n\n",statement1.c_str(),statement2.c_str());
    }

    void errorPrint(int line,string statement1)
    {
        fprintf(error,"Error at Line No.%d: %s\n\n",line,statement1.c_str());

    }

    void func_matching_with_para(SymbolInfo* s, string statement1,string statement2,string statement3)
    {
        if(s==0)
        {
            table->Insert(statement2,"ID","Function");
            s=table->lookup(statement2);
            s->set_isFunction();
            for(int i=0; i<parameter_list.size(); i++)
            {
                s->get_isFunction()->add_number_of_parameter(parameter_list[i]->getName(),parameter_list[i]->getDecType());
                //cout<<parameter_list[i]->getDecType()<<endl;
            }
            parameter_list.clear();
            s->get_isFunction()->set_return_type(statement1);
        }
        else
        {
            int num=s->get_isFunction()->get_number_of_parameter();
            //	cout<<line_count<<" "<<parameter_list.size()<<endl;
            if(num !=parameter_list.size())
            {
                error_count++;
                errorPrint(line_count,"Invalid number of parameters");
                //	fprintf(error,"Error at Line No.%d:  Invalid number of parameters \n\n",line_count);

            }

            else
            {

                vector<string>parameter_type=s->get_isFunction()->get_paratype();

                for(int i=0; i<parameter_list.size(); i++)
                {
                    if(parameter_list[i]->getDecType() != parameter_type[i])
                    {
                        error_count++;
                        errorPrint(line_count,"Type Mismatch");
                        //	fprintf(error,"Error at Line No.%d: Type Mismatch \n\n",line_count);
                        break;
                    }
                }
                if(s->get_isFunction()->get_return_type() != statement1)
                {
                    error_count++;
                    errorPrint(line_count,"Return Type Mismatch");
                    //fprintf(error,"Error at Line No.%d: Return Type Mismatch \n\n",line_count);
                }
                parameter_list.clear();
            }

        }
    }

    void func_matching_no_para(SymbolInfo*s,string statement1,string statement2)
    {
        if(s==0)
        {
            table->Insert(statement2,"ID","Function");
            s=table->lookup(statement2);
            s->set_isFunction();
            s->get_isFunction()->set_return_type(statement1);
        }
        else
        {
            if(s->get_isFunction()->get_number_of_parameter() !=0 )
            {
                error_count++;
                errorPrint(line_count,"Invalid number of parameters");
                //		fprintf(error,"Error at Line No.%d:  Invalid number of parameters \n\n",line_count);
            }
            if(s->get_isFunction()->get_return_type() != statement1)
            {
                error_count++;
                errorPrint(line_count,"Return Type Mismatch");
                //		fprintf(error,"Error at Line No.%d: Return Type Mismatch \n\n",line_count);
            }

        }
    }

    void func_def_with_para_matching(SymbolInfo*s,string statement1,string statement2)
    {
        if(s!=0)
        {
            if(s->get_isFunction()->get_isdefined()==0)
            {
                int num=s->get_isFunction()->get_number_of_parameter();
                //	cout<<line_count<<" "<<parameter_list.size()<<endl;
                //	$<s_info>$->setDecType(s->get_isFunction()->get_return_type());
                if(num!=parameter_list.size())
                {
                    error_count++;
                    errorPrint(line_count,"Invalid number of parameters");
                    //		fprintf(error,"Error at Line No.%d:  Invalid number of parameters \n\n",line_count);

                }
                else
                {

                    vector<string>parameter_type=s->get_isFunction()->get_paratype();
                    for(int i=0; i<parameter_list.size(); i++)
                    {
                        if(parameter_list[i]->getDecType() != parameter_type[i])
                        {
                            error_count++;
                            errorPrint(line_count,"Type Mismatch");
//					fprintf(error,"Error at Line No.%d: Type Mismatch \n\n",line_count);
                            break;
                        }
                    }
                    if(s->get_isFunction()->get_return_type()!=statement1)
                    {
                        error_count++;
                        errorPrint(line_count,"Return Type Mismatch");
                        //fprintf(error,"Error at Line No.%d: Return Type Mismatch1 \n\n",line_count);
                    }
                    //	parameter_list.clear();
                }
                s->get_isFunction()->set_isdefined();
            }
            else
            {
                error_count++;
                errorPrint(line_count,"Multiple defination of function");
                //		fprintf(error,"Error at Line No.%d:  Multiple defination of function %s\n\n",line_count,$<s_info>2->getName().c_str());

            }
        }
        else  //cout<<parameter_list.size()<<" "<<line_count<<endl;
        {
            table->Insert(statement2,"ID","Function");
            s=table->lookup(statement2);
            s->set_isFunction();
            //cout<<s->get_isFunction()->get_number_of_parameter()<<endl;
            s->get_isFunction()->set_isdefined();
            for(int i=0; i<parameter_list.size(); i++)
            {
                s->get_isFunction()->add_number_of_parameter(parameter_list[i]->getName(),parameter_list[i]->getDecType());
                //	cout<<parameter_list[i]->getDecType()<<parameter_list[i]->getName()<<endl;
            }
            //	parameter_list.clear();
            s->get_isFunction()->set_return_type(statement1);
            //cout<<line_count<<" "<<s->get_isFunction()->get_return_type()<<endl;
        }
    }

    void func_def_no_para_matching(SymbolInfo*s,string statement1,string statement2)
    {
        if(s==0)
        {
            table->Insert(statement2,"ID","Function");
            s=table->lookup(statement2);
            s->set_isFunction();
            s->get_isFunction()->set_isdefined();
            s->get_isFunction()->set_return_type(statement1);
//	cout<<line_count<<" "<<s->get_isFunction()->get_return_type()<<endl;
        }
        else if(s->get_isFunction()->get_isdefined() == 0)
        {
            if(s->get_isFunction()->get_number_of_parameter() != 0)
            {
                error_count++;
                errorPrint(line_count,"Invalid number of parameters");
//			fprintf(error,"Error at Line No.%d:  Invalid number of parameters \n\n",line_count);
            }
            if(s->get_isFunction()->get_return_type() != statement1)
            {
                error_count++;
                errorPrint(line_count,"Return Type of Mismatch");
//			fprintf(error,"Error at Line No.%d: Return Type Mismatch \n\n",line_count);
            }

            s->get_isFunction()->set_isdefined();
        }
        else
        {
            error_count++;
            errorPrint(line_count,"Multiple defination of function");
//		fprintf(error,"Error at Line No.%d:  Multiple defination of function %s\n\n",line_count,$<s_info>2->getName().c_str());
        }
    }

    bool checkVoid(string s)
    {
        if(s == "void") return true;
        return false;
    }

    void variable_validation(string statement1,string statement2)
    {
        if(checkVoid(statement1))
        {
            error_count++;
            errorPrint(line_count,"Type specifier can not be void");
            //	fprintf(error,"Error at Line No.%d: TYpe specifier can not be void \n\n",line_count);

        }
        else
        {
            for(int i=0; i<declared_list.size(); i++)
            {
                if(table->lookupcurrent(declared_list[i]->getName()))
                {
                    error_count++;
                    //	errorPrint(line_count,"Multiple Declaration of")
                    fprintf(error,"Error at Line No.%d:  Multiple Declaration of %s \n\n",line_count,declared_list[i]->getName().c_str());
                    continue;
                }
                if(declared_list[i]->getType().size() == 3)
                {
                    declared_list[i]->setType(declared_list[i]->getType().substr(0,declared_list[i]->getType().size () - 1));
                    table->Insert(declared_list[i]->getName(),declared_list[i]->getType(),statement1+"array");
                }
                else
                    table->Insert(declared_list[i]->getName(),declared_list[i]->getType(),statement1);
            }
        }

    }

    void variable_id_validation(string statement)
    {
        if(table->lookup(statement) == 0)
        {
            error_count++;
            fprintf(error,"Error at Line No.%d:  Undeclared Variable: %s \n\n",line_count,statement.c_str());

        }
        else if(table->lookup(statement)->getDecType()=="int array" || table->lookup(statement)->getDecType() == "float array")
        {
            error_count++;
            fprintf(error,"Error at Line No.%d:  Not an array: %s \n\n",line_count,statement.c_str());
        }
    }

    void array_validation(string statement1,string statement2)
    {
        if(table->lookup(statement1) == 0)
        {
            error_count++;
            fprintf(error,"Error at Line No.%d:  Undeclared Variable: %s \n\n",line_count,statement1.c_str());
        }
        //cout<<line_count<<" "<<$<s_info>3->getDecType()<<endl;
        if(statement2 =="float "||statement2 =="void ")
        {
            error_count++;
            errorPrint(line_count,"Non-integer Array Index");
            //	fprintf(error,"Error at Line No.%d:  Non-integer Array Index  \n\n",line_count);
        }
    }

%}


%token IF ELSE FOR WHILE DO BREAK
%token INT FLOAT CHAR DOUBLE VOID
%token RETURN SWITCH CASE DEFAULT CONTINUE
%token CONST_INT CONST_FLOAT CONST_CHAR
%token ADDOP MULOP INCOP RELOP ASSIGNOP LOGICOP BITOP NOT DECOP
%token LPAREN RPAREN LCURL RCURL LTHIRD RTHIRD COMMA SEMICOLON
%token STRING ID PRINTLN



%left RELOP LOGICOP BITOP
%left ADDOP
%left MULOP

%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%union
{
    SymbolInfo* s_info;
    vector<string>*s;

}
%type <s>HAJIME


%%

HAJIME :
program {	}

;

program : program unit {$<s_info>$=new SymbolInfo();
    printFile(line_count,"program->program unit");
    printFileDoubleString($<s_info>1->getName(),$<s_info>2->getName());
    $<s_info>$->setName($<s_info>1->getName()+$<s_info>2->getName());
}

| unit {$<s_info>$=new SymbolInfo();
    printFile(line_count," program->unit");
    printFileString($<s_info>1->getName());
    $<s_info>$->setName($<s_info>1->getName());
}
;

unit : var_declaration {$<s_info>$=new SymbolInfo();
    printFile(line_count,"unit : var_declaration");
    printFile(line_count,$<s_info>1->getName());
    $<s_info>$->setName($<s_info>1->getName()+"\n");
}
| func_declaration {$<s_info>$=new SymbolInfo();
    printFile(line_count,"unit->func_declaration");
    printFileString($<s_info>1->getName());
    $<s_info>$->setName($<s_info>1->getName()+"\n");
}
| func_definition { $<s_info>$=new SymbolInfo();
    fprintf(logfile,"Line at %d : unit->func_definition\n\n",line_count);
    printFileString($<s_info>1->getName());
    $<s_info>$->setName($<s_info>1->getName()+"\n");
}
;

func_declaration : type_specifier ID  LPAREN  parameter_list RPAREN SEMICOLON {$<s_info>$=new SymbolInfo();
    printFile(line_count,"func_declaration->type_specifier ID LPAREN parameter_list RPAREN SEMICOLON");
    //	fprintf(logfile,"%s %s(%s);\n\n",$<s_info>1->getName().c_str(),$<s_info>2->getName().c_str(),$<s_info>4->getName().c_str());
    string func_va1 = $<s_info>1->getName();
    string func_var2 = $<s_info>2->getName();
    string func_var3 = $<s_info>4->getName();

    SymbolInfo *s=table->lookup(func_var2);

    func_matching_with_para(s,func_va1,func_var2,func_var3);
    /* if(s==0){
    	table->Insert($<s_info>2->getName(),"ID","Function");
    	s=table->lookup($<s_info>2->getName());
    	s->set_isFunction();
    	for(int i=0;i<parameter_list.size();i++){
    		s->get_isFunction()->add_number_of_parameter(parameter_list[i]->getName(),parameter_list[i]->getDecType());
    	//cout<<parameter_list[i]->getDecType()<<endl;
    	}
    	parameter_list.clear();s->get_isFunction()->set_return_type($<s_info>1->getName());
    }
    else{
    	int num=s->get_isFunction()->get_number_of_parameter();
    //	cout<<line_count<<" "<<parameter_list.size()<<endl;
    	if(num!=parameter_list.size()){
    		error_count++;
    		errorPrint(line_count,"Invalid number of parameters");
    	//	fprintf(error,"Error at Line No.%d:  Invalid number of parameters \n\n",line_count);

    	}

    	else{

    	vector<string>parameter_type=s->get_isFunction()->get_paratype();

    	for(int i=0;i<parameter_list.size();i++){
    	if(parameter_list[i]->getDecType() != parameter_type[i]){
    				error_count++;
    				errorPrint(line_count,"Type Mismatch");
    			//	fprintf(error,"Error at Line No.%d: Type Mismatch \n\n",line_count);
    				break;
    			}
    		}
    		if(s->get_isFunction()->get_return_type() != $<s_info>1->getName()){
    				error_count++;
    				errorPrint(line_count,"Return Type Mismatch");
    				//fprintf(error,"Error at Line No.%d: Return Type Mismatch \n\n",line_count);
    		}
    		parameter_list.clear();
    	}

    } */

    $<s_info>$->setName($<s_info>1->getName()+" "+$<s_info>2->getName()+"("+$<s_info>4->getName()+");");
}
|type_specifier ID LPAREN RPAREN SEMICOLON {$<s_info>$=new SymbolInfo();
    printFile(line_count,"func_declaration->type_specifier ID LPAREN RPAREN SEMICOLON");//fprintf(logfile,"Line at %d : func_declaration->type_specifier ID LPAREN RPAREN SEMICOLON\n\n",line_count);
    string func_var_no_para1 = $<s_info>1->getName();
    string func_var_no_para2 = $<s_info>2->getName();

    fprintf(logfile,"%s %s();\n\n",$<s_info>1->getName().c_str(),$<s_info>2->getName().c_str());
    SymbolInfo *s=table->lookup($<s_info>2->getName());

    func_matching_no_para(s,func_var_no_para1,func_var_no_para2);

    /* if(s==0){
    	table->Insert($<s_info>2->getName(),"ID","Function");
    	s=table->lookup($<s_info>2->getName());
    	s->set_isFunction();s->get_isFunction()->set_return_type($<s_info>1->getName());
    }
    else{
    	if(s->get_isFunction()->get_number_of_parameter()!=0){
    		error_count++;
    		errorPrint(line_count,"Invalid number of parameters");
    //		fprintf(error,"Error at Line No.%d:  Invalid number of parameters \n\n",line_count);
    	}
    	if(s->get_isFunction()->get_return_type()!= $<s_info>1->getName()){
    		error_count++;
    		errorPrint(line_count,"Return Type Mismatch");
    //		fprintf(error,"Error at Line No.%d: Return Type Mismatch \n\n",line_count);
    	}

    } */
    $<s_info>$->setName($<s_info>1->getName()+" "+$<s_info>2->getName()+"();");
}
;

func_definition : type_specifier ID  LPAREN  parameter_list RPAREN {$<s_info>$=new SymbolInfo();
    string func_def_var1 = $<s_info>1->getName();
    string func_def_var2 = $<s_info>2->getName();

    SymbolInfo *s=table->lookup($<s_info>2->getName());
    func_def_with_para_matching(s,func_def_var1,func_def_var2);

    /* if(s!=0){
    	if(s->get_isFunction()->get_isdefined()==0){
    	int num=s->get_isFunction()->get_number_of_parameter();
    //	cout<<line_count<<" "<<parameter_list.size()<<endl;
    //	$<s_info>$->setDecType(s->get_isFunction()->get_return_type());
    	if(num!=parameter_list.size()){
    		error_count++;
    		errorPrint(line_count,"Invalid number of parameters");
    //		fprintf(error,"Error at Line No.%d:  Invalid number of parameters \n\n",line_count);

    	} else{

    	vector<string>parameter_type=s->get_isFunction()->get_paratype();
    	for(int i=0;i<parameter_list.size();i++){
    	if(parameter_list[i]->getDecType()!=parameter_type[i]){
    				error_count++;
    				errorPrint(line_count,"Type Mismatch");
    //					fprintf(error,"Error at Line No.%d: Type Mismatch \n\n",line_count);
    				break;
    			}
    		}
    		if(s->get_isFunction()->get_return_type()!=$<s_info>1->getName()){
    				error_count++;
    				errorPrint(line_count,"Return Type Mismatch");
    //				fprintf(error,"Error at Line No.%d: Return Type Mismatch1 \n\n",line_count);
    		}
    	//	parameter_list.clear();
    	}
    	s->get_isFunction()->set_isdefined();}
    	else{
    		error_count++;
    		errorPrint(line_count,"Multiple defination of function");
    //		fprintf(error,"Error at Line No.%d:  Multiple defination of function %s\n\n",line_count,$<s_info>2->getName().c_str());

    	}
    }
    else{ //cout<<parameter_list.size()<<" "<<line_count<<endl;
    		table->Insert($<s_info>2->getName(),"ID","Function");
    		s=table->lookup($<s_info>2->getName());
    		s->set_isFunction();
    		//cout<<s->get_isFunction()->get_number_of_parameter()<<endl;
    		s->get_isFunction()->set_isdefined();
    		for(int i=0;i<parameter_list.size();i++){
    			s->get_isFunction()->add_number_of_parameter(parameter_list[i]->getName(),parameter_list[i]->getDecType());
    	//	cout<<parameter_list[i]->getDecType()<<parameter_list[i]->getName()<<endl;
    	}
    //	parameter_list.clear();
    	s->get_isFunction()->set_return_type($<s_info>1->getName());
    	//cout<<line_count<<" "<<s->get_isFunction()->get_return_type()<<endl;
    } */

} compound_statement
{
    printFile(line_count,"func_definition->type_specifier ID LPAREN parameter_list RPAREN compound_statement");
    //	fprintf(logfile,"Line at %d : func_definition->type_specifier ID LPAREN parameter_list RPAREN compound_statement \n\n",line_count);
    fprintf(logfile,"%s %s(%s) %s \n\n",$<s_info>1->getName().c_str(),$<s_info>2->getName().c_str(),$<s_info>4->getName().c_str(),$<s_info>7->getName().c_str());


    $<s_info>$->setName($<s_info>1->getName()+" "+$<s_info>2->getName()+"("+$<s_info>4->getName()+")"+$<s_info>7->getName());
}
| type_specifier ID LPAREN RPAREN { $<s_info>$=new SymbolInfo();
    string func_def_var1 = $<s_info>1->getName();
    string func_def_var2 = $<s_info>2->getName();

    SymbolInfo *s=table->lookup($<s_info>2->getName());
    func_def_no_para_matching(s,func_def_var1,func_def_var2);


    $<s_info>1->setName($<s_info>1->getName()+" "+$<s_info>2->getName()+"()");
} compound_statement
{
    printFile(line_count,"func_definition->type_specifier ID LPAREN RPAREN compound_statement");
    //	fprintf(logfile,"Line at %d : func_definition->type_specifier ID LPAREN RPAREN compound_statement\n\n",line_count);
    fprintf(logfile,"%s %s\n\n",$<s_info>1->getName().c_str(),$<s_info>6->getName().c_str());
    $<s_info>$->setName($<s_info>1->getName()+$<s_info>6->getName());

}
;


parameter_list  : parameter_list COMMA type_specifier ID {$<s_info>$=new SymbolInfo();
    printFile(line_count,"parameter_list->parameter_list COMMA type_specifier ID");//fprintf(logfile,"Line at %d : parameter_list->parameter_list COMMA type_specifier ID\n\n",line_count);
    fprintf(logfile,"%s,%s %s\n\n",$<s_info>1->getName().c_str(),$<s_info>3->getName().c_str(),$<s_info>4->getName().c_str());
    parameter_list.push_back(new SymbolInfo($<s_info>4->getName(),"ID",$<s_info>3->getName()));
    $<s_info>$->setName($<s_info>1->getName()+","+$<s_info>3->getName()+" "+$<s_info>4->getName());
}
| parameter_list COMMA type_specifier {$<s_info>$=new SymbolInfo();
    printFile(line_count,"parameter_list->parameter_list COMMA type_specifier");//fprintf(logfile,"Line at %d : parameter_list->parameter_list COMMA type_specifier\n\n",line_count);
    fprintf(logfile,"%s,%s\n\n",$<s_info>1->getName().c_str(),$<s_info>3->getName().c_str());
    parameter_list.push_back(new SymbolInfo("","ID",$<s_info>3->getName()));
    $<s_info>$->setName($<s_info>1->getName()+","+$<s_info>3->getName());

}
| type_specifier ID {$<s_info>$=new SymbolInfo();
    printFile(line_count,"parameter_list->type_specifier ID");//fprintf(logfile,"Line at %d : parameter_list->type_specifier ID\n\n",line_count);
    fprintf(logfile,"%s %s\n\n",$<s_info>1->getName().c_str(),$<s_info>2->getName().c_str());
    parameter_list.push_back(new SymbolInfo($<s_info>2->getName(),"ID",$<s_info>1->getName()));
    $<s_info>$->setName($<s_info>1->getName()+" "+$<s_info>2->getName());
}
| type_specifier {$<s_info>$=new SymbolInfo();
    printFile(line_count,"parameter_list->type_specifier");//fprintf(logfile,"Line at %d : parameter_list->type_specifier\n\n",line_count);
    fprintf(logfile,"%s \n\n",$<s_info>1->getName().c_str());
    parameter_list.push_back(new SymbolInfo("","ID",$<s_info>1->getName()));
    $<s_info>$->setName($<s_info>1->getName()+" ");
}
;


compound_statement : LCURL {table->Enter_Scope();
    //	cout<<line_count<<" "<<parameter_list.size()<<endl;
    for(int i=0; i<parameter_list.size(); i++)
        table->Insert(parameter_list[i]->getName(),"ID",parameter_list[i]->getDecType());
    //	table->printcurrent();
    parameter_list.clear();
} statements RCURL {$<s_info>$=new SymbolInfo();
    printFile(line_count,"compound_statement->LCURL statements RCURL");//fprintf(logfile,"Line at %d : compound_statement->LCURL statements RCURL\n\n",line_count);
    fprintf(logfile,"{%s}\n\n",$<s_info>3->getName().c_str());
    $<s_info>$->setName("{\n"+$<s_info>3->getName()+"\n}");
    table->printall();
    table->Exit_Scope();
}
| LCURL RCURL {table->Enter_Scope();
    for(int i=0; i<parameter_list.size(); i++)
        table->Insert(parameter_list[i]->getName(),"ID",parameter_list[i]->getDecType());
    //table->printcurrent();
    parameter_list.clear();
    $<s_info>$=new SymbolInfo();
    printFile(line_count,"compound_statement->LCURL RCURL");//fprintf(logfile,"Line at %d : compound_statement->LCURL RCURL\n\n",line_count);
    fprintf(logfile,"{}\n\n");
    $<s_info>$->setName("{}");
    table->printall();
    table->Exit_Scope();
}
;

var_declaration : type_specifier declaration_list SEMICOLON {$<s_info>$=new SymbolInfo();
    printFile(line_count,"var_declaration->type_specifier declaration_list SEMICOLON");//fprintf(logfile,"Line at %d : var_declaration->type_specifier declaration_list SEMICOLON\n\n",line_count);
    string var1 = $<s_info>1->getName();
    string var2 = $<s_info>2->getName();
    fprintf(logfile,"%s %s;\n\n",$<s_info>1->getName().c_str(),$<s_info>2->getName().c_str());

    variable_validation(var1,var2);

    declared_list.clear();
    $<s_info>$->setName($<s_info>1->getName()+" "+$<s_info>2->getName()+";");
}
;

type_specifier	: INT  {$<s_info>$=new SymbolInfo();
    printFile(line_count," type_specifier	: INT");//fprintf(logfile,"Line at %d : type_specifier	: INT\n\n",line_count);
    fprintf(logfile,"int \n\n");
    $<s_info>$->setName("int ");
}
| FLOAT  {$<s_info>$=new SymbolInfo();
    printFile(line_count," type_specifier	: FLOAT");//fprintf(logfile,"Line at %d : type_specifier	: FLOAT\n\n",line_count);
    fprintf(logfile,"float \n\n");
    $<s_info>$->setName("float ");
}
| VOID  {$<s_info>$=new SymbolInfo();
    printFile(line_count," type_specifier	: VOID");//fprintf(logfile,"Line at %d : type_specifier	: VOID\n\n",line_count);
    fprintf(logfile,"void \n\n");
    $<s_info>$->setName("void ");
}
;

declaration_list : declaration_list COMMA ID {$<s_info>$=new SymbolInfo();
    printFile(line_count," declaration_list->declaration_list COMMA ID");//fprintf(logfile,"Line at %d : declaration_list->declaration_list COMMA ID\n\n",line_count);

    fprintf(logfile,"%s,%s\n\n",$<s_info>1->getName().c_str(),$<s_info>3->getName().c_str());
    declared_list.push_back(new SymbolInfo($<s_info>3->getName(),"ID"));
    $<s_info>$->setName($<s_info>1->getName()+","+$<s_info>3->getName());
}
| declaration_list COMMA ID LTHIRD CONST_INT RTHIRD {$<s_info>$=new SymbolInfo();
    printFile(line_count," declaration_list->declaration_list COMMA ID LTHIRD CONST_INT RTHIRD");//fprintf(logfile,"Line at %d : declaration_list->declaration_list COMMA ID LTHIRD CONST_INT RTHIRD\n\n",line_count);
    fprintf(logfile,"%s,%s[%s]\n\n",$<s_info>1->getName().c_str(),$<s_info>3->getName().c_str(),$<s_info>5->getName().c_str());
    declared_list.push_back(new SymbolInfo($<s_info>3->getName(),"IDa"));
    $<s_info>$->setName($<s_info>1->getName()+","+$<s_info>3->getName()+"["+$<s_info>5->getName()+"]");
}
| ID {$<s_info>$=new SymbolInfo();
    printFile(line_count," declaration_list->ID");//fprintf(logfile,"Line at %d : declaration_list->ID\n\n",line_count);
    fprintf(logfile,"%s\n\n",$<s_info>1->getName().c_str());
    declared_list.push_back(new SymbolInfo($<s_info>1->getName(),"ID"));
    $<s_info>$->setName($<s_info>1->getName());

}
| ID LTHIRD CONST_INT RTHIRD {$<s_info>$=new SymbolInfo();
    printFile(line_count," declaration_list->ID LTHIRD CONST_INT RTHIRD");//fprintf(logfile,"Line at %d : declaration_list->ID LTHIRD CONST_INT RTHIRD\n\n",line_count);
    fprintf(logfile,"%s[%s]\n\n",$<s_info>1->getName().c_str(),$<s_info>3->getName().c_str());
    declared_list.push_back(new SymbolInfo($<s_info>1->getName(),"IDa"));
    $<s_info>$->setName($<s_info>1->getName()+"["+$<s_info>3->getName()+"]");

}
| ID error LTHIRD error RTHIRD
;

statements : statement {$<s_info>$=new SymbolInfo();
    printFile(line_count," statements->statement");//fprintf(logfile,"Line at %d : statements->statement\n\n",line_count);
    fprintf(logfile,"%s\n\n",$<s_info>1->getName().c_str());
    $<s_info>$->setName($<s_info>1->getName());
}
| statements statement {$<s_info>$=new SymbolInfo();
    printFile(line_count," statements->statements statement");//fprintf(logfile,"Line at %d : statements->statements statement\n\n",line_count);
    fprintf(logfile,"%s %s\n\n",$<s_info>1->getName().c_str(),$<s_info>2->getName().c_str());
    $<s_info>$->setName($<s_info>1->getName()+"\n"+$<s_info>2->getName());
}
;

statement : var_declaration { $<s_info>$=new SymbolInfo();
    printFile(line_count," statement -> var_declaration");//fprintf(logfile,"Line at %d : statement -> var_declaration\n\n",line_count);
    fprintf(logfile,"%s\n\n",$<s_info>1->getName().c_str());
    $<s_info>$->setName($<s_info>1->getName());

}
| expression_statement {$<s_info>$=new SymbolInfo();
    printFile(line_count,"statement -> expression_statement");//fprintf(logfile,"Line at %d : statement -> expression_statement\n\n",line_count);
    fprintf(logfile,"%s\n\n",$<s_info>1->getName().c_str());
    $<s_info>$->setName($<s_info>1->getName());

}
| compound_statement {$<s_info>$=new SymbolInfo();
    printFile(line_count," statement->compound_statement");//fprintf(logfile,"Line at %d : statement->compound_statement\n\n",line_count);
    fprintf(logfile,"%s\n\n",$<s_info>1->getName().c_str());
    $<s_info>$->setName($<s_info>1->getName());

}
| FOR LPAREN expression_statement expression_statement expression RPAREN statement {$<s_info>$=new SymbolInfo();
    printFile(line_count," statement ->FOR LPAREN expression_statement expression_statement expression RPAREN statement");//fprintf(logfile,"Line at %d : statement ->FOR LPAREN expression_statement expression_statement expression RPAREN statement\n\n",line_count);
    string for_var1 = $<s_info>3->getName();
    string for_var2 = $<s_info>4->getName();
    string for_var3 = $<s_info>5->getName();
    string for_var4 = $<s_info>7->getName();

    fprintf(logfile,"for(%s %s %s)\n%s \n\n",$<s_info>3->getName().c_str(),$<s_info>4->getName().c_str(),$<s_info>5->getName().c_str(),$<s_info>7->getName().c_str());
    if(checkVoid(for_var1))
    {
        error_count++;
        errorPrint(line_count,"Type Mismatch");
        //		fprintf(error,"Error at Line No.%d:  Type Mismatch \n\n",line_count);
        //$<s_info>$->setDecType("int ");
    }

    $<s_info>$->setName("for("+$<s_info>3->getName()+$<s_info>4->getName()+$<s_info>5->getName()+")\n"+$<s_info>5->getName());

}
| IF LPAREN expression RPAREN statement %prec LOWER_THAN_ELSE {$<s_info>$=new SymbolInfo();
    printFile(line_count," statement->IF LPAREN expression RPAREN statement");//fprintf(logfile,"Line at %d : statement->IF LPAREN expression RPAREN statement\n\n",line_count);
    fprintf(logfile,"if(%s)\n%s\n\n",$<s_info>3->getName().c_str(),$<s_info>5->getName().c_str());
    string if_var1 = $<s_info>3->getName();
    string if_var2 = $<s_info>5->getName();

    string if_var_dec1 = $<s_info>3->getDecType();
    string if_var_dec2 = $<s_info>5->getDecType();

    if(checkVoid(if_var_dec1))
    {
        error_count++;
        errorPrint(line_count,"Type Mismatch");
        //			fprintf(error,"Error at Line No.%d:  Type Mismatch \n\n",line_count);
        //$<s_info>$->setDecType("int ");
    }

    $<s_info>$->setName("if("+$<s_info>3->getName()+")\n"+$<s_info>5->getName());

}
| IF LPAREN expression RPAREN statement ELSE statement {$<s_info>$=new SymbolInfo();
    printFile(line_count," statement->IF LPAREN expression RPAREN statement ELSE statement");//fprintf(logfile,"Line at %d : statement->IF LPAREN expression RPAREN statement ELSE statement\n\n",line_count);
    string if_var1 = $<s_info>3->getName();
    string if_var2 = $<s_info>5->getName();
    string if_var3 = $<s_info>7->getName();

    string if_var_dec1 = $<s_info>3->getDecType();
    string if_var_dec2 = $<s_info>5->getDecType();
    string if_var_dec3 = $<s_info>7->getDecType();

    fprintf(logfile,"if(%s)\n%s\n else \n %s\n\n",$<s_info>3->getName().c_str(),$<s_info>5->getName().c_str(),$<s_info>7->getName().c_str());
    if(checkVoid(if_var_dec1))
    {
        error_count++;
        errorPrint(line_count,"Type Mismatch");
        //							fprintf(error,"Error at Line No.%d:  Type Mismatch \n\n",line_count);
        //$<s_info>$->setDecType("int ");
    }

    $<s_info>$->setName("if("+$<s_info>3->getName()+")\n"+$<s_info>5->getName()+" else \n"+$<s_info>7->getName());
}

| WHILE LPAREN expression RPAREN statement {$<s_info>$=new SymbolInfo();
    errorPrint(line_count," statement->WHILE LPAREN expression RPAREN statement");//fprintf(logfile,"Line at %d : statement->WHILE LPAREN expression RPAREN statement\n\n",line_count);
    fprintf(logfile,"while(%s)\n%s\n\n",$<s_info>3->getName().c_str(),$<s_info>5->getName().c_str());
    string while_var1 = $<s_info>3->getName();
    string while_var2 = $<s_info>5->getName();

    string while_dec1 = $<s_info>3->getDecType();
    string while_dec2 = $<s_info>5->getDecType();

    if(checkVoid(while_dec1))
    {
        error_count++;
        errorPrint(line_count,"Type Mismatch");
        //				fprintf(error,"Error at Line No.%d:  Type Mismatch \n\n",line_count);
        //	$<s_info>$->setDecType("int ");
    }
    $<s_info>$->setName("while("+$<s_info>3->getName()+")\n"+$<s_info>5->getName());
}
| PRINTLN LPAREN ID RPAREN SEMICOLON {$<s_info>$=new SymbolInfo();
    printFile(line_count," statement->PRINTLN LPAREN ID RPAREN SEMICOLON");//fprintf(logfile,"Line at %d : statement->PRINTLN LPAREN ID RPAREN SEMICOLON\n\n",line_count);
    fprintf(logfile,"\n (%s);\n\n",$<s_info>3->getName().c_str());
    $<s_info>$->setName("\n("+$<s_info>3->getName()+")");
}
| RETURN expression SEMICOLON {$<s_info>$=new SymbolInfo();
    printFile(line_count," statement->RETURN expression SEMICOLON");//fprintf(logfile,"Line at %d : statement->RETURN expression SEMICOLON\n\n",line_count);
    fprintf(logfile,"return %s;\n\n",$<s_info>2->getName().c_str());
    if(checkVoid($<s_info>2->getDecType()))
    {
        error_count++;
        errorPrint(line_count,"Type Mismatch");
        //			fprintf(error,"Error at Line No.%d:  Type Mismatch \n\n",line_count);
        $<s_info>$->setDecType("int ");
    }
    $<s_info>$->setName("return "+$<s_info>2->getName()+";");
}
|RETURN expression error SEMICOLON
| FOR error LPAREN error expression_statement error expression_statement error expression error RPAREN error statement
| WHILE error LPAREN error RPAREN error statement
| IF error LPAREN error RPAREN statement
| IF error LPAREN error RPAREN error statement error ELSE error statement

;

expression_statement 	: SEMICOLON	{$<s_info>$=new SymbolInfo();
    printFile(line_count," expression_statement->SEMICOLON");//fprintf(logfile,"Line at %d : expression_statement->SEMICOLON\n\n",line_count);
    fprintf(logfile,";\n\n");
    $<s_info>$->setName(";");
}
| expression SEMICOLON {$<s_info>$=new SymbolInfo();
    printFile(line_count," expression_statement->expression SEMICOLON");//fprintf(logfile,"Line at %d : expression_statement->expression SEMICOLON\n\n",line_count);
    fprintf(logfile,"%s;\n\n",$<s_info>1->getName().c_str());
    $<s_info>$->setName($<s_info>1->getName()+";");
}
;

variable : ID 		{$<s_info>$=new SymbolInfo();
    //	fprintf(logfile,"Line at %d : variable->ID\n\n",line_count);
    printFile(line_count," variable->ID");
    fprintf(logfile,"%s\n\n",$<s_info>1->getName().c_str());

    string id_var1 = $<s_info>1->getName();
    string id_dec1 = $<s_info>1->getDecType();

    variable_id_validation(id_var1);

    /*okup($<s_info>1->getName())->getDecType()=="int array" || table->lookup($<s_info>1->getName())->getDecType() == "float array"){
    	 error_count++;
    	fprintf(error,"Error at Line No.%d:  Not an array: %s \n\n",line_count,$<s_info>1->getName().c_str());
    } */
    if(table->lookup($<s_info>1->getName()) != 0)
    {
        //cout<<line_count<<" "<<$<s_info>1->getName()<<" "<<table->lookup($<s_info>1->getName())->getDecType()<<endl;
        $<s_info>$->setDecType(table->lookup($<s_info>1->getName())->getDecType());
    }
    $<s_info>$->setName($<s_info>1->getName());


}
| ID LTHIRD expression RTHIRD  {$<s_info>$=new SymbolInfo();
    printFile(line_count," variable->ID LTHIRD expression RTHIRD");//fprintf(logfile,"Line at %d : variable->ID LTHIRD expression RTHIRD\n\n",line_count);
    fprintf(logfile,"%s[%s]\n\n",$<s_info>1->getName().c_str(),$<s_info>3->getName().c_str());
    string array_id1 = $<s_info>1->getName();
    string array_id2 = $<s_info>3->getName();

    string array_dec1 = $<s_info>1->getDecType();
    string array_dec2 = $<s_info>3->getDecType();

    array_validation(array_id1,array_dec2);

    /* if(table->lookup($<s_info>1->getName()) == 0){
    	error_count++;
    	fprintf(error,"Error at Line No.%d:  Undeclared Variable: %s \n\n",line_count,$<s_info>1->getName().c_str());
    }

    //	fprintf(error,"Error at Line No.%d:  Non-integer Array Index  \n\n",line_count);
    } */
    if(table->lookup($<s_info>1->getName())!=0)
    {
        //cout<<line_count<<" "<<table->lookup($<s_info>1->getName())->getDecType()<<endl;
        if(table->lookup($<s_info>1->getName())->getDecType()!="int array" && table->lookup($<s_info>1->getName())->getDecType()!="float array")
        {

            error_count++;
            errorPrint(line_count,"Type Mismatch");
            //		fprintf(error,"Error at Line No.%d:  Type Mismatch \n\n",line_count);
        }

         if(table->lookup($<s_info>1->getName())->getDecType()=="float array")
        {
            $<s_info>1->setDecType("float ");
        }

        if(table->lookup($<s_info>1->getName())->getDecType()=="int array")
        {

            $<s_info>1->setDecType("int ");
        }
       
        $<s_info>$->setDecType($<s_info>1->getDecType());

    }
    $<s_info>$->setName($<s_info>1->getName()+"["+$<s_info>3->getName()+"]");

}
| ID LTHIRD expression error RTHIRD

;
expression : logic_expression	{$<s_info>$=new SymbolInfo();
    printFile(line_count," expression->logic_expression");//fprintf(logfile,"Line at %d : expression->logic_expression\n\n",line_count);
    fprintf(logfile,"%s\n\n",$<s_info>1->getName().c_str());
    $<s_info>$->setName($<s_info>1->getName());
    $<s_info>$->setDecType($<s_info>1->getDecType());
}
| variable ASSIGNOP logic_expression {$<s_info>$=new SymbolInfo();
    printFile(line_count," expression->variable ASSIGNOP logic_expression");//fprintf(logfile,"Line at %d : expression->variable ASSIGNOP logic_expression\n\n",line_count);
    fprintf(logfile,"%s=%s\n\n",$<s_info>1->getName().c_str(),$<s_info>3->getName().c_str());

    string assign_var1 = $<s_info>1->getName();
    string assign_var2 = $<s_info>3->getName();

    string assign_dec1 = $<s_info>1->getDecType();
    string assign_dec2 = $<s_info>3->getDecType();

    if(checkVoid(assign_dec2))
    {
        error_count++;
        errorPrint(line_count,"Type Mismatch");
        //			fprintf(error,"Error at Line No.%d:  Type Mismatch \n\n",line_count);
        $<s_info>$->setDecType("int ");
    }
    else if(table->lookup(assign_var1) != 0)
    {
        //cout<<line_count<<" "<<table->lookup($<s_info>1->getName())->getDecType()<<""<<$<s_info>3->getDecType()<<endl;
        if(table->lookup(assign_var1)->getDecType() != assign_dec2)
        {
            error_count++;
            errorPrint(line_count,"Type Mismatch");
            //	fprintf(error,"Error at Line No.%d: Type Mismatch \n\n",line_count);
        }
    }
    $<s_info>$->setDecType(assign_dec1);
    $<s_info>$->setName(assign_var1+"="+assign_var2);

}
| variable ASSIGNOP error logic_expression

;
logic_expression : rel_expression 	{$<s_info>$=new SymbolInfo();
    printFile(line_count," logic_expression->rel_expression");//fprintf(logfile,"Line at %d : logic_expression->rel_expression\n\n",line_count);
    fprintf(logfile,"%s\n\n",$<s_info>1->getName().c_str());
    $<s_info>$->setName($<s_info>1->getName());
    $<s_info>$->setDecType($<s_info>1->getDecType());

}
| rel_expression LOGICOP rel_expression {$<s_info>$=new SymbolInfo();
    printFile(line_count," logic_expression->rel_expression LOGICOP rel_expression");//fprintf(logfile,"Line at %d : logic_expression->rel_expression LOGICOP rel_expression\n\n",line_count);
    fprintf(logfile,"%s%s%s\n\n",$<s_info>1->getName().c_str(),$<s_info>2->getName().c_str(),$<s_info>3->getName().c_str());
    string logicop_var1 = $<s_info>1->getName();
    string logicop_var2 = $<s_info>3->getName();

    string logicop_dec1 = $<s_info>1->getDecType();
    string logicop_dec2 = $<s_info>3->getDecType();

    if($<s_info>1->getDecType()=="void "||$<s_info>3->getDecType()=="void ")
    {
        error_count++;
        errorPrint(line_count,"Type Mismatch");
        //		fprintf(error,"Error at Line No.%d:  Type Mismatch \n\n",line_count);
        $<s_info>$->setDecType("int ");
    }
    $<s_info>$->setDecType("int ");
    $<s_info>$->setName(logicop_var1+$<s_info>2->getName()+logicop_var2);

}
| rel_expression LOGICOP error rel_expression

;

rel_expression	: simple_expression {$<s_info>$=new SymbolInfo();
    printFile(line_count," rel_expression->simple_expression");//fprintf(logfile,"Line at %d : rel_expression->simple_expression\n\n",line_count);
    fprintf(logfile,"%s\n\n",$<s_info>1->getName().c_str());
    $<s_info>$->setName($<s_info>1->getName());
    $<s_info>$->setDecType($<s_info>1->getDecType());

}
| simple_expression RELOP simple_expression	 {$<s_info>$=new SymbolInfo();
    printFile(line_count," rel_expression->simple_expression RELOP simple_expression");//fprintf(logfile,"Line at %d : rel_expression->simple_expression RELOP simple_expression\n\n",line_count);
    fprintf(logfile,"%s%s%s\n\n",$<s_info>1->getName().c_str(),$<s_info>2->getName().c_str(),$<s_info>3->getName().c_str());
    string relop_var1 = $<s_info>1->getName();
    string relop_var2 = $<s_info>3->getName();

    string relop_dec1 = $<s_info>1->getDecType();
    string relop_dec2 = $<s_info>3->getDecType();

    if(relop_dec1 == "void "||relop_dec2=="void ")
    {
        error_count++;
        errorPrint(line_count,"Type Mismatch");
        //		fprintf(error,"Error at Line No.%d:  Type Mismatch \n\n",line_count);
        $<s_info>$->setDecType("int ");
    }
    $<s_info>$->setDecType("int ");

    $<s_info>$->setName(relop_var1+$<s_info>2->getName()+relop_var2);

}
;

simple_expression : term {$<s_info>$=new SymbolInfo();
    printFile(line_count," simple_expression->term");//fprintf(logfile,"Line at %d : simple_expression->term\n\n",line_count);
    fprintf(logfile,"%s\n\n",$<s_info>1->getName().c_str());
    $<s_info>$->setDecType($<s_info>1->getDecType());
    $<s_info>$->setName($<s_info>1->getName());


}
| simple_expression ADDOP term {$<s_info>$=new SymbolInfo();
    printFile(line_count," simple_expression->simple_expression ADDOP term");
    //		fprintf(logfile,"Line at %d : simple_expression->simple_expression ADDOP term\n\n",line_count);
    fprintf(logfile,"%s%s%s\n\n",$<s_info>1->getName().c_str(),$<s_info>2->getName().c_str(),$<s_info>3->getName().c_str());
    //cout<<$<s_info>3->getDecType()<<endl;
    if($<s_info>1->getDecType()=="void "||$<s_info>3->getDecType()=="void ")
    {
        error_count++;
        fprintf(error,"Error at Line No.%d:  Type Mismatch \n\n",line_count);
        $<s_info>$->setDecType("int ");
    }
    else if($<s_info>1->getDecType()=="float " ||$<s_info>3->getDecType()=="float ")
        $<s_info>$->setDecType("float ");
    else  $<s_info>$->setDecType("int ");
    $<s_info>$->setName($<s_info>1->getName()+$<s_info>2->getName()+$<s_info>3->getName());
}
| simple_expression ADDOP error term

;

term : unary_expression  {$<s_info>$=new SymbolInfo();
    printFile(line_count," term->unary_expression");//fprintf(logfile,"Line at %d : term->unary_expression\n\n",line_count);
    fprintf(logfile,"%s\n\n",$<s_info>1->getName().c_str());
    $<s_info>$->setDecType($<s_info>1->getDecType());

    $<s_info>$->setName($<s_info>1->getName());

}
|  term MULOP unary_expression {$<s_info>$=new SymbolInfo();
    printFile(line_count," term->term MULOP unary_expression");//fprintf(logfile,"Line at %d : term->term MULOP unary_expression\n\n",line_count);
    fprintf(logfile,"%s%s%s\n\n",$<s_info>1->getName().c_str(),$<s_info>2->getName().c_str(),$<s_info>3->getName().c_str());
    string mulop_var1 = $<s_info>1->getName();
    string mulop_var2 = $<s_info>3->getName();

    string mulop_dec1 = $<s_info>1->getDecType();
    string mulop_dec2 = $<s_info>3->getDecType();

    if(mulop_dec1 == "void "||mulop_dec2 == "void ")
    {
        error_count++;
        errorPrint(line_count,"Type Mismatch");
        //			fprintf(error,"Error at Line No.%d:  Type Mismatch \n\n",line_count);
        $<s_info>$->setDecType("int ");
    }
    else if($<s_info>2->getName()=="%")
    {
        if(mulop_dec1 != "int " ||mulop_dec2 != "int ")
        {
            error_count++;
            errorPrint(line_count,"  Integer operand on modulus operator  ");
            //		fprintf(error,"Error at Line No.%d:  Integer operand on modulus operator  \n\n",line_count);

        }
        $<s_info>$->setDecType("int ");

    }
    else if($<s_info>2->getName()=="/")
    {
        if(mulop_dec1 == "void "||mulop_dec2 == "void ")
        {
            error_count++;
            errorPrint(line_count,"Type Mismatch");
            //			fprintf(error,"Error at Line No.%d:  Type Mismatch \n\n",line_count);
            $<s_info>$->setDecType("int ");
        }
        else  if(mulop_dec1 == "int " && mulop_dec2 == "int ")
            $<s_info>$->setDecType("int ");
        else $<s_info>$->setDecType("float ");

    }
    else{
        if(mulop_dec1 == "void "||mulop_dec2 == "void ")
        {
            error_count++;
            errorPrint(line_count,"Type Mismatch");
            //			fprintf(error,"Error at Line No.%d:  Type Mismatch \n\n",line_count);
            $<s_info>$->setDecType("int ");
        }
        else  if(mulop_dec1 == "float " || mulop_dec2 == "float ")
            $<s_info>$->setDecType("float ");
        else $<s_info>$->setDecType("int ");
    }
    $<s_info>$->setName(mulop_var1+$<s_info>2->getName()+mulop_var2);

}
|  term MULOP error unary_expression

;

unary_expression : ADDOP unary_expression  {$<s_info>$=new SymbolInfo();
    printFile(line_count," unary_expression->ADDOP unary_expression");//fprintf(logfile,"Line at %d : unary_expression->ADDOP unary_expression\n\n",line_count);
    fprintf(logfile,"%s%s\n\n",$<s_info>1->getName().c_str(),$<s_info>2->getName().c_str());
    if($<s_info>2->getDecType()=="void ")
    {
        error_count++;
        errorPrint(line_count,"Type Mismatch");
        //			fprintf(error,"Error at Line No.%d:  Type Mismatch \n\n",line_count);
        $<s_info>$->setDecType("int ");
    }
    else
        $<s_info>$->setDecType($<s_info>2->getDecType());
    $<s_info>$->setName($<s_info>1->getName()+$<s_info>2->getName());

}
| NOT unary_expression {$<s_info>$=new SymbolInfo();
    printFile(line_count," unary_expression->NOT unary_expression");//fprintf(logfile,"Line at %d : unary_expression->NOT unary_expression\n\n",line_count);
    fprintf(logfile,"!%s\n\n",$<s_info>2->getName().c_str());
    if($<s_info>2->getDecType()=="void ")
    {
        error_count++;
        errorPrint(line_count,"Type Mismatch");
        //		fprintf(error,"Error at Line No.%d:  Type Mismatch \n\n",line_count);
        $<s_info>$->setDecType("int ");
    }
    else
        $<s_info>$->setDecType($<s_info>2->getDecType());
    $<s_info>$->setName("!"+$<s_info>2->getName());

}
| factor {$<s_info>$=new SymbolInfo();
    printFile(line_count," unary_expression->factor");//fprintf(logfile,"Line at %d : unary_expression->factor\n\n",line_count);
    fprintf(logfile,"%s\n\n",$<s_info>1->getName().c_str());
    // cout<<$<s_info>1->getDecType()<<endl;
    $<s_info>$->setDecType($<s_info>1->getDecType());
    $<s_info>$->setName($<s_info>1->getName());

}
| ADDOP error unary_expression
| NOT error unary_expression

;

factor	: variable { $<s_info>$=new SymbolInfo();
    printFile(line_count,"factor->variable");//fprintf(logfile,"Line at %d : factor->variable\n\n",line_count);
    fprintf(logfile,"%s\n\n",$<s_info>1->getName().c_str());
    $<s_info>$->setDecType($<s_info>1->getDecType());
    $<s_info>$->setName($<s_info>1->getName());

}
| ID LPAREN argument_list RPAREN {$<s_info>$=new SymbolInfo();
    printFile(line_count," factor->ID LPAREN argument_list RPAREN");//fprintf(logfile,"Line at %d : factor->ID LPAREN argument_list RPAREN\n\n",line_count);
    fprintf(logfile,"%s(%s)\n\n",$<s_info>1->getName().c_str(),$<s_info>3->getName().c_str());
    string func_var1 = $<s_info>1->getName();
    string func_var2 = $<s_info>3->getName();

    SymbolInfo* s=table->lookup(func_var1);
    if(s==0)
    {
        error_count++;
        errorPrint(line_count,"  Undefined Function ");
        //		fprintf(error,"Error at Line No.%d:  Undefined Function \n\n",line_count);
        $<s_info>$->setDecType("int ");
    }
    else if(s->get_isFunction()==0)
    {
        error_count++;
        errorPrint(line_count,"Not a Function");
        //			fprintf(error,"Error at Line No.%d:  Not A Function \n\n",line_count);
        $<s_info>$->setDecType("int ");
    }
    else {
        if(s->get_isFunction()->get_isdefined()==0)
        {
            error_count++;
            errorPrint(line_count,"  Undeclared Function ");
            //		fprintf(error,"Error at Line No.%d:  Undeclared Function \n\n",line_count);
        }

        int num=s->get_isFunction()->get_number_of_parameter();
        //cout<<line_count<<" "<<argument_list.size()<<endl;
        $<s_info>$->setDecType(s->get_isFunction()->get_return_type());

        if(num!=argument_list.size())
        {
            error_count++;
            errorPrint(line_count,"Invalid number of arguments");
            //			fprintf(error,"Error at Line No.%d:  Invalid number of arguments \n\n",line_count);

        }
        else{
            //cout<<s->get_isFunction()->get_return_type()<<endl;
            vector<string>parameter_list=s->get_isFunction()->get_paralist();
            vector<string>parameter_type=s->get_isFunction()->get_paratype();

            for(int i=0; i<argument_list.size(); i++)
            {
                if(argument_list[i]->getDecType() != parameter_type[i])
                {
                    error_count++;
                    errorPrint(line_count,"Type Mismatch");
                    //		fprintf(error,"Error at Line No.%d: Type Mismatch \n\n",line_count);
                    break;
                }
            }

        }
    }
    argument_list.clear();
    //cout<<line_count<<" "<<$<s_info>$->getDecType()<<endl;
    $<s_info>$->setName(func_var1+"("+func_var2+")");
}
| LPAREN expression RPAREN {$<s_info>$=new SymbolInfo();
    printFile(line_count," factor->LPAREN expression RPAREN");//fprintf(logfile,"Line at %d : factor->LPAREN expression RPAREN\n\n",line_count);
    fprintf(logfile,"(%s)\n\n",$<s_info>2->getName().c_str());
    $<s_info>$->setDecType($<s_info>2->getDecType());
    $<s_info>$->setName("("+$<s_info>2->getName()+")");
}
| CONST_INT { $<s_info>$=new SymbolInfo();
    printFile(line_count," factor->CONST_INT");//fprintf(logfile,"Line at %d : factor->CONST_INT\n\n",line_count);
    fprintf(logfile,"%s\n\n",$<s_info>1->getName().c_str());
    $<s_info>$->setDecType("int ");
    $<s_info>$->setName($<s_info>1->getName());

}
| CONST_FLOAT {$<s_info>$=new SymbolInfo();
    printFile(line_count," factor->CONST_FLOAT");//fprintf(logfile,"Line at %d : factor->CONST_FLOAT\n\n",line_count);
    fprintf(logfile,"%s\n\n",$<s_info>1->getName().c_str());
    $<s_info>$->setDecType("float ");
    $<s_info>$->setName($<s_info>1->getName());

}
| variable INCOP {$<s_info>$=new SymbolInfo();
    printFile(line_count," factor->variable INCOP");//fprintf(logfile,"Line at %d : factor->variable INCOP\n\n",line_count);
    fprintf(logfile,"%s++\n\n",$<s_info>1->getName().c_str());
    $<s_info>$->setDecType($<s_info>1->getDecType());
    $<s_info>$->setName($<s_info>1->getName()+"++");

}
| variable DECOP {$<s_info>$=new SymbolInfo();
    printFile(line_count," factor->variable DECOP");//fprintf(logfile,"Line at %d : factor->variable DECOP\n\n",line_count);
    fprintf(logfile,"%s--\n\n",$<s_info>1->getName().c_str());
    $<s_info>$->setDecType($<s_info>1->getDecType());
    $<s_info>$->setName($<s_info>1->getName()+"--");

}
| LPAREN error expression error RPAREN
| LPAREN expression error RPAREN
| LPAREN error expression RPAREN

;

argument_list : arguments  {$<s_info>$=new SymbolInfo();
    printFile(line_count," argument_list->arguments");
    fprintf(logfile,"Line at %d : argument_list->arguments\n\n",line_count);
    fprintf(logfile,"%s\n\n",$<s_info>1->getName().c_str());
    $<s_info>$->setName($<s_info>1->getName());
}
| 			{ $<s_info>$=new SymbolInfo();
    printFile(line_count," argument_list-> ");
}
///fprintf(logfile,"Line at %d : argument_list-> \n\n",line_count);$<s_info>$->setName("");}
;

arguments : arguments COMMA logic_expression { $<s_info>$=new SymbolInfo();
    printFile(line_count," arguments->arguments COMMA logic_expression ");//fprintf(logfile,"Line at %d : arguments->arguments COMMA logic_expression \n\n",line_count);
    fprintf(logfile,"%s,%s\n\n",$<s_info>1->getName().c_str(),$<s_info>3->getName().c_str());
    argument_list.push_back($<s_info>3);
    $<s_info>$->setName($<s_info>1->getName()+","+$<s_info>3->getName());
}
| logic_expression {$<s_info>$=new SymbolInfo();
    printFile(line_count," arguments->logic_expression");
    //		fprintf(logfile,"Line at %d : arguments->logic_expression\n\n",line_count);
    fprintf(logfile,"%s\n\n",$<s_info>1->getName().c_str());
    argument_list.push_back(new SymbolInfo($<s_info>1->getName(),$<s_info>1->getType(),$<s_info>1->getDecType()));
    // cout<<$<s_info>1->getDecType()<<endl;
    $<s_info>$->setName($<s_info>1->getName());

}
;
%%
int main(int argc,char *argv[])
{

    if((fp=fopen(argv[1],"r"))==NULL)
    {
        printf("Cannot Open Input File.\n");
        return 0;
    }
    yyin=fp;
    table->Enter_Scope();
    yyparse();
    fprintf(logfile," Symbol Table : \n\n");
    table->printall();
    fprintf(logfile,"Total Lines : %d \n\n",line_count);
    fprintf(logfile,"Total Errors : %d \n\n",error_count);
    fprintf(error,"Total Errors : %d \n\n",error_count);

    fclose(fp);
    fclose(logfile);
    fclose(error);

    return 0;
}
