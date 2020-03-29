//
// Created by Latif Siddiq Suuny on 28-Apr-18.
//



#include <bits/stdc++.h>
#include "1605112_function.h"
using namespace std;

class SymbolInfo
        {
        
        string name;
        string type;
        string dectype;
        SymbolInfo * next;
        Function* isFunction;

        public:
        SymbolInfo()
        {
            this->isFunction=0;
            this->next=0;

        }

        SymbolInfo(string name,string type,string dec="")
        {
            this->name=name;
            this->type=type;
            this->dectype=dec;
            this->next=0;
        }

        string getName()
        {
            return this->name;
        }

        string getType()
        {
            return this->type;
        }
        string getDecType()
        {
            return this->dectype;
        }

        SymbolInfo *getNext()
        {
            return this->next;
        }


        string setName(string new_name)
        {
            this->name=new_name;
            return this->name;
        }

        string setType(string new_type)
        {
            this->type=new_type;
            return this->type;
        }
        string setDecType(string new_type)
        {
            this->dectype=new_type;
            return this->dectype;
        }

        SymbolInfo *set_next(SymbolInfo * new_next)
        {
            this->next=new_next;
            return this->next;
        }
        void set_isFunction(){
            isFunction=new Function();
        }
        Function* get_isFunction(){
           return isFunction;
        }
        };
