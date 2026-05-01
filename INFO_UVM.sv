/*

uvm_root -> uvm_object -> uvm_transaction -> uvm_report_object

uvm_transaction
	-> uvm_sequence_item;
    -> uvm_sequence #(REG, RES)

uvm_report_object
	-> uvm_component
		-> uvm_test
        -> uvm_env
        -> uvm_scoreboard
        -> uvm_agent
        -> uvm_sequencer_base #(REQ, RES)
        -> uvm_monitor
        -> uvm_driver
        
If we want to define any executable logic in component class we have to make use of phases

In case of transactions we have to make use of body

Factory registrations is as follows
-> For components
	`uvm_component_ubtils(<class name>)
-> For transactions type
	`uvm_object_utils(<class name>)
    
// For parameterised class
-> `uvm_component_param_utils()
	Eg: uvm_component_param_utils(<class name> #(T, W))
-> `uvm_object_param_utils()

Constructor in case of component
function void new(string name = "class_name", uvm_component parent = null);
	super.new(name, parent);
endfunction

Constructor in case of transaction
function new(string name = "class_name");
	super.new(name);
endfunction
*/

class my_seq extends uvm_sequence_item;
  
  `uvm_object_utils(my_seq)
  
  function new(string name = "my_seq");
    super.new(name);
    this._disp();
  endfunction
  
  function void _disp();
    `uvm_info("[my_seq]","my_seq object created", UVM_NONE);
  endfunction
endclass

class my_comp extends uvm_component;
  `uvm_component_utils(my_comp)
  
  my_seq s1;
  
  function new(string name = "uvm_comp", uvm_component parent = null);
    super.new(name, parent);
    this._disp;
  endfunction

  function void _disp();
    `uvm_info("[my_seq]","my_comp object created", UVM_NONE);
  endfunction
	
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    s1 = my_seq::type_id::create("s1");
  endfunction
  
endclass

class my_test extends uvm_test;
  
  `uvm_component_utils(my_test)
  
  my_comp c1;
  
  function new(string name = "my_test", uvm_component parent = "null");
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    c1 = my_comp::type_id::create("c1", this);
  endfunction
  
endclass

module tb;
  
  initial begin
    run_test("my_test");
  end
  
endmodule


