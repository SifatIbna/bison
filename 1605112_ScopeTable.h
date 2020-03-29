
////////////////////////////////ScopeTable/////////////////////////

#include <bits/stdc++.h>
#include "1605112_SymbolInfo.h"

using namespace std;

class ScopeTable
{
    int id,num;
    int position;
    SymbolInfo **symbol;
    ScopeTable *parentScope;
    FILE *logout;
public:

    ScopeTable()
    {
        parentScope=0;
    }
    ScopeTable(int id,int n,ScopeTable *prev,FILE *x)
    {
        this->id=id;
        this->num=n;
        this->parentScope=prev;
        position=1;
        symbol=new SymbolInfo*[n];
        for(int i=0; i<n; i++)
        {
            symbol[i]=0;
        }
	logout=x;

    }
    int HashFunction(string s)                         ///////////////hash function collected from //copied from  https://research.cs.vt.edu/AVresearch/hashing/strings.php
    {
        unsigned long long  h = 5381;
        int len = s.length();

        for (int i = 0; i < len; i++)
            h += ((h * 33) + (unsigned long long )s[i]);

        return (h%this->num);
    }

    SymbolInfo *lookup(string target)             //////////////////lookup current///////
    {
        int hashv=HashFunction(target);
        SymbolInfo *temp=symbol[hashv];
        int pos=0;
        while(temp!=0)
        {
            if(temp->getName()==target)
            {
                return temp;
            }
            temp=temp->getNext();
            pos++;

        }

        return temp;




    }
    bool Insert(string name,string type,string dectype)           //////////////inserting values///////////////
    {

        position=0;
         SymbolInfo *temp=lookup(name);
        if(temp!=0)
        {
            //fprintf(logout,"< %s,%s > already exists in current ScopeTable\n",name.c_str(),type.c_str());
            return false;
        }


        int hashv=HashFunction(name);
        temp=symbol[hashv];
        SymbolInfo *new_symbol=new SymbolInfo(name,type,dectype);
        if(temp==0)
        {
            symbol[hashv]=new_symbol;


            //fprintf(logout," Inserted in ScopeTable# %d at position %d, 0\n",id,hashv);
	    	//printScopeTable();


            return true;
        }

        int pos=0;
        while(temp->getNext()!=0)
        {
            temp=temp->getNext();
            pos++;

        }
        temp->set_next(new_symbol);
	    //printScopeTable();
       // cout<<"Inserted in ScopeTable# "<<id<<" at position "<<hashv<<", "<<pos+1<<endl;
        return true;



    }
    bool Delete(string name)           /////////////////deleting scopetable//////////////
    {
        position=1;
        if(lookup(name)==0)
        {
            return false;
        }
        position=0;
        int hashv=HashFunction(name);
        SymbolInfo *temp=symbol[hashv];
        if(temp->getName()==name)
        {
            symbol[hashv]=temp->getNext();
            cout<<" Deleted entry at "<<hashv<<", 0 from current ScopeTable"<<endl;
            return true;

        }
        SymbolInfo *prev=0;
        SymbolInfo *next=0;
        next=temp;
        int pos=0;
        while(next->getName()!=name)
        {
            prev=next;
            next=next->getNext();
            pos++;
        }
        prev->set_next(next->getNext());
       // cout<<" Deleted entry at "<<hashv<<", "<<pos<<" from current ScopeTable"<<endl;
        return true;



    }
    void printScopeTable()                /////////////////////////printing current scope table////////////
    {
        fprintf(logout," ScopeTable# %d \n",id);
        SymbolInfo *temp;

        for (int i = 0; i < num; i++)
        {

            temp = symbol[i];
	    	if(temp==0)
		{
			continue;
		}
	    fprintf(logout," %d  --> ",i);

        //cout <<" "<< i << " --> ";

        while (temp)
        {
	        fprintf(logout,"< %s : %s > ",temp->getType().c_str(),temp->getName().c_str());


            // cout << "<" << temp->getName() << " : " << temp->getType()<< ">  ";
            temp = temp->getNext();
        }
	    fprintf(logout,"\n");

           // cout<<endl;
        }
        fprintf(logout,"\n");
    }

    void set_position(int x)                  ////////////////setting position////////////////
    {
        position=x;

    }
    int get_id()                        ///////////////////getting id/////////////////
    {
        return id;
    }
    ScopeTable *get_parent()              /////////////////////getting parent////////////
    {
        return parentScope;
    }
    ~ScopeTable()
    {
        for(int i=0; i<num; i++)
        {
            delete (symbol[i]);
        }
        delete(parentScope);
    }
};

// int ScopeTable:: HashFunction(string s)
// {
//     unsigned long long  h = 5381;
//     int len = s.length();
//
//     for (int i = 0; i < len; i++)
//         h += ((h * 33) + (unsigned long long )s[i]);
//
//     return (h%this->num);
// }
//
// SymbolInfo * ScopeTable:: lookup(string target)
// {
//     int hashv=HashFunction(target);
//     SymbolInfo *temp=symbol[hashv];
//     int pos=0;
//     while(temp!=0)
//     {
//         if(temp->getName()==target)
//         {
//
//             if(position)
//             {
// //fprintf(logout," Found in ScopeTable# %d at position %d, %d\n",id,hashv,pos);
//
//
//             }
//             return temp;
//         }
//         temp=temp->getNext();
//         pos++;
//
//     }
//
//     return temp;
//
//
//
//
// }
// bool ScopeTable:: Insert(string name,string type,string dectype)
// {
//
//     position=0;
//      SymbolInfo *temp=lookup(name);
//     if(temp!=0)
//     {
//         //fprintf(logout,"< %s,%s > already exists in current ScopeTable\n",name.c_str(),type.c_str());
//         return false;
//     }
//
//
//     int hashv=HashFunction(name);
//     temp=symbol[hashv];
//     SymbolInfo *new_symbol=new SymbolInfo(name,type,dectype);
//     if(temp==0)
//     {
//         symbol[hashv]=new_symbol;
//
//
//         //fprintf(logout," Inserted in ScopeTable# %d at position %d, 0\n",id,hashv);
//     //printScopeTable();
//
//
//         return true;
//     }
//
//     int pos=0;
//     while(temp->getNext()!=0)
//     {
//         temp=temp->getNext();
//         pos++;
//
//     }
//     temp->set_next(new_symbol);
//   //printScopeTable();
//    // cout<<"Inserted in ScopeTable# "<<id<<" at position "<<hashv<<", "<<pos+1<<endl;
//     return true;
//
//
//
// }
// bool ScopeTable:: Delete(string name)
// {
//     position=1;
//     if(lookup(name)==0)
//     {
//         return false;
//     }
//     position=0;
//     int hashv=HashFunction(name);
//     SymbolInfo *temp=symbol[hashv];
//     if(temp->getName()==name)
//     {
//         symbol[hashv]=temp->getNext();
//         cout<<" Deleted entry at "<<hashv<<", 0 from current ScopeTable"<<endl;
//         return true;
//
//     }
//     SymbolInfo *prev=0;
//     SymbolInfo *next=0;
//     next=temp;
//     int pos=0;
//     while(next->getName()!=name)
//     {
//         prev=next;
//         next=next->getNext();
//         pos++;
//     }
//     prev->set_next(next->getNext());
//    // cout<<" Deleted entry at "<<hashv<<", "<<pos<<" from current ScopeTable"<<endl;
//     return true;
//
//
//
// }
// void ScopeTable:: printScopeTable()
// {
//     fprintf(logout," ScopeTable# %d \n",id);
//     SymbolInfo *temp;
//
//     for (int i = 0; i < num; i++)
//     {
//
//         temp = symbol[i];
//     if(temp==0)
// {
//   continue;
// }
//   fprintf(logout," %d  --> ",i);
//
//     //cout <<" "<< i << " --> ";
//
//     while (temp)
//     {
//       fprintf(logout,"< %s : %s > ",temp->getType().c_str(),temp->getName().c_str());
//
//
//         // cout << "<" << temp->getName() << " : " << temp->getType()<< ">  ";
//         temp = temp->getNext();
//     }
//   fprintf(logout,"\n");
//
//        // cout<<endl;
//     }
//     fprintf(logout,"\n");
// }
//
// void ScopeTable:: set_position(int x)
// {
//     position=x;
//
// }
// int ScopeTable:: get_id()
// {
//     return id;
// }
// ScopeTable* ScopeTable:: get_parent()
// {
//     return parentScope;
// }
