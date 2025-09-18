class agnt extends uvm_component; 
  `uvm_component_utils(agnt) 
  int b_tmp; 
  function new(string name = "agnt", uvm_component parent = null);
    super.new(name, parent); 
   `uvm_info("agnt", "Class agnt handle is created", UVM_NONE);
  endfunction 
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase); 
    if(!(uvm_config_db #(int)::get(this,"","Var_A",b_tmp))) begin
      `uvm_error("agnt", "Error wrt config_db"); 
    end 
    else begin 
      `uvm_info("agnt",$sformatf("The value got from config_db is %0d",b_tmp),UVM_NONE); 
    end 
  endfunction 
endclass

class classA extends uvm_component;
  `uvm_component_utils(classA)
  int a_tmp = 32;
  
  function new(string name = "classA", uvm_component parent = null);
    super.new(name, parent);
    `uvm_info("CLASS-A", "Class A handle is created", UVM_NONE);
  endfunction
endclass


class test extends uvm_test;
  `uvm_component_utils(test)
  
  agnt a1;
  classA ca;
  
  function new(string name = "test", uvm_component parent = null);
    super.new(name,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    a1 = agnt::type_id::create("a1", this);
    ca = classA::type_id::create("ca", this);
    uvm_config_db #(int)::set(this,"a1","Var_A",ca.a_tmp);
    `uvm_info("CLASS-A",$sformatf("The value added to config_db is %0d",ca.a_tmp), UVM_NONE);
  endfunction
endclass

module tb;
  initial begin
    run_test("test");
  end
endmodule
