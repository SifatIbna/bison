//
// Created by Latif Siddiq Suuny on 9-Jun-18.
//



#include <bits/stdc++.h>
using namespace std;

class Function
        {
        string return_type;
        int number_of_parameter;
        vector<string> parameter_list;
        vector<string> parameter_type;
        bool isdefined;

        public:
            Function(){
                number_of_parameter=0;
                isdefined=false;
                parameter_list.clear();
                parameter_type.clear();
                return_type="";

            }
            void set_return_type(string type){
                this->return_type=type;
            }
            string get_return_type(){
                return return_type;
            }
            void set_number_of_parameter(){
                number_of_parameter=parameter_list.size();
            }
            int get_number_of_parameter(){
              return  number_of_parameter;
            }
            void add_number_of_parameter(string newpara,string type){
                parameter_list.push_back(newpara);
                parameter_type.push_back(type);
              //  cout<<newpara<<endl;
                set_number_of_parameter();
            }
            vector<string> get_paralist(){
                return parameter_list;
            }
            vector<string> get_paratype(){
                return parameter_type;
            }
            void set_isdefined(){
                this->isdefined=true;
            }
            bool get_isdefined(){
                return isdefined;
            }
       

        };
