
///////////////////////////symbolTable/////////////////

#include <bits/stdc++.h>
#include "1605112_ScopeTable.h"

using namespace std;

class SymbolTable
{
    FILE *logout;
    int n,current_id;
    vector<ScopeTable*>Scopes;
    ScopeTable * current;
public:
    SymbolTable()
    {
        current_id=0;
        current=0;
    }
    SymbolTable(int num,FILE *x)
    {
        this->n=num;
        this->current_id=0;
        current=0;
	    logout=x;
    }
    void Enter_Scope()  //// entering nw Scope
    {

        current_id++;
        ScopeTable *new_table;
        if(!Scopes.empty())
        {
            new_table=new ScopeTable(current_id,n,Scopes.back(),logout);
            if(current_id!=1)
	        fprintf(logout," New ScopeTable with id %d created\n\n",current_id);
           // cout<<" New ScopeTable with id "<<current_id<<" created"<<endl;
        }
        else
        {
            new_table=new ScopeTable(current_id,n,0,logout);

        }
        Scopes.push_back(new_table);
        current=new_table;
    }
    void Exit_Scope()  /// exiting current scope
    {
        if(current_id==0)
        {
            // fprintf(logout," No scope Table Found\n");
            return;
        }
        if(current_id!=1)
 	    fprintf(logout," ScopeTable with id %d removed\n\n",current_id);
        current=Scopes.back()->get_parent();
        Scopes.pop_back();
    }
    bool Insert(string name,string type,string dectype="")  // inseting new value
    {
        if(current!=0)
        {
            return current->Insert(name,type,dectype);
        }
        else
        {
            Enter_Scope();
            return current->Insert(name,type,dectype);
        }



    }
    bool InsertPrev(string name,string type,string dectype="") // inserting preview
    {
        if(current==0) {
            Enter_Scope();
        }
        if(current->get_parent()==0)
        {
            return current->Insert(name,type,dectype);
        }
        else
        {
            return current->get_parent()->Insert(name,type,dectype);
        }



    }
    bool Remove(string name) // removing current symbolinfo
    {
        if(current!=0)
        {
            return current->Delete(name);

        }
        else
        {
            //fprintf(logout," No scope Table Found\n");
            return false;
        }
    }
     SymbolInfo *lookupcurrent(string name)  // look up current
    {
        if(current){
            return current->lookup(name);
        }
        return 0;

    }

    SymbolInfo *lookup(string name) // lookup current
    {
        ScopeTable *temp=current;
        while(temp)
        {

            temp->set_position(0);
            if(temp->lookup(name))
            {
                temp->set_position(1);
                return temp->lookup(name);
            }
            temp=temp->get_parent();
        }
        //fprintf(logout," Not Found\n");
        return 0;

    }

    void printcurrent()  //// printing current table
    {
        return current->printScopeTable();
    }
    void printall()     /////////// printing all scope table
    {
        ScopeTable *temp=current;
        while(temp)
        {
            temp->printScopeTable();
            temp=temp->get_parent();
        }
    }

};


// void SymbolTable Enter_Scope()
// {
//
//     current_id++;
//     ScopeTable *new_table;
//     if(!Scopes.empty())
//     {
//         new_table=new ScopeTable(current_id,n,Scopes.back(),logout);
//         if(current_id!=1)
//       fprintf(logout," New ScopeTable with id %d created\n\n",current_id);
//        // cout<<" New ScopeTable with id "<<current_id<<" created"<<endl;
//     }
//     else
//     {
//         new_table=new ScopeTable(current_id,n,0,logout);
//
//     }
//     Scopes.push_back(new_table);
//     current=new_table;
// }
// void SymbolTable:: Exit_Scope()
// {
//     if(current_id==0)
//     {
//         // fprintf(logout," No scope Table Found\n");
//         return;
//     }
//     if(current_id!=1)
//   fprintf(logout," ScopeTable with id %d removed\n\n",current_id);
//     current=Scopes.back()->get_parent();
//     Scopes.pop_back();
// }
// bool SymbolTable:: Insert(string name,string type,string dectype="")
// {
//     if(current!=0)
//     {
//         return current->Insert(name,type,dectype);
//     }
//     else
//     {
//         Enter_Scope();
//         return current->Insert(name,type,dectype);
//     }
//
//
//
// }
// bool SymbolTable:: InsertPrev(string name,string type,string dectype="")
// {
//     if(current==0) {
//         Enter_Scope();
//     }
//     if(current->get_parent()==0)
//     {
//         return current->Insert(name,type,dectype);
//     }
//     else
//     {
//         return current->get_parent()->Insert(name,type,dectype);
//     }
//
//
//
// }
// bool SymbolTable::  Remove(string name)
// {
//     if(current!=0)
//     {
//         return current->Delete(name);
//
//     }
//     else
//     {
//         //fprintf(logout," No scope Table Found\n");
//         return false;
//     }
// }
//  SymbolInfo* SymbolTable:: lookupcurrent(string name)
// {
//     if(current){
//         return current->lookup(name);
//     }
//     return 0;
//
// }
//
// SymbolInfo* SymbolTable:: lookup(string name)
// {
//     ScopeTable *temp=current;
//     while(temp)
//     {
//
//         temp->set_position(0);
//         if(temp->lookup(name))
//         {
//             temp->set_position(1);
//             return temp->lookup(name);
//         }
//         temp=temp->get_parent();
//     }
//     //fprintf(logout," Not Found\n");
//     return 0;
//
// }
//
// void SymbolTable:: printcurrent()
// {
//     return current->printScopeTable();
// }
// void SymbolTable:: printall()
// {
//     ScopeTable *temp=current;
//     while(temp)
//     {
//         temp->printScopeTable();
//         temp=temp->get_parent();
//     }
// }
