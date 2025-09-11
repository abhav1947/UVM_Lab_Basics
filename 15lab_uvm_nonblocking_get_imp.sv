// uvm nonblocking get TLM ports
class txn extends uvm_object;
  randc int _addr_1;
  randc bit _addr_1_en;
  
  `uvm_object_utils_begin(txn)
  `uvm_field_int(_addr_1, UVM_ALL_ON)
  `uvm_field_int(_addr_1_en, UVM_ALL_ON)
  `uvm_object_utils_end
  
  function new(string name = "txn");
    super.new(name);
    `uvm_info("[UVM_SEQ]", "SEQUENCE CREATED", UVM_NONE);
  endfunction
  
endclass

class compA extends uvm_component;
  `uvm_component_utils(compA)
  uvm_nonblocking_get_imp #(txn, compA) compA_get_imp;
  
  function new(string name = "compA", uvm_component parent = null);
    super.new(name, parent);
    `uvm_info("[UVM_CMP_A]", "COMP-A CREATED", UVM_NONE);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("[UVM_CMP_A]", "BUILD PHASE OF CMP-A STARTED", UVM_NONE);
    compA_get_imp = new("compA_get_imp", this);
    `uvm_info("[UVM_CMP_A]", "BUILD PHASE OF CMP-A COMPLETED", UVM_NONE);
  endfunction
  
  virtual function bit try_get(output txn tmp);
    tmp = txn::type_id::create("tmp");
    tmp.randomize();
    `uvm_info("[UVM_CMP_A]", "TXN SENT FROM CMP-A", UVM_NONE);
    `uvm_info("[UVM_CMP_A]", $sformatf("_addr_1 = %0d",tmp._addr_1), UVM_NONE);
    `uvm_info("[UVM_CMP_A]", $sformatf("_addr_1_en = %0d",tmp._addr_1_en), UVM_NONE);
    return 1;
  endfunction
  
  virtual function bit can_get();
    
  endfunction
  
endclass

class compB extends uvm_component;
  `uvm_component_utils(compB)
  uvm_nonblocking_get_port #(txn) compB_get_port;
  txn t1;
  
  function new(string name = "compB", uvm_component parent = null);
    super.new(name, parent);
    `uvm_info("[UVM_CMP_B]", "COMP-B CREATED", UVM_NONE);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("[UVM_CMP_B]", "BUILD PHASE OF CMP-B STARTED", UVM_NONE);
    compB_get_port = new("compB_get_port", this);
     t1 = txn::type_id::create("t1");
    `uvm_info("[UVM_CMP_B]", "BUILD PHASE OF CMP-B COMPLETED", UVM_NONE);
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    repeat(5) begin
      compB_get_port.try_get(t1);
      `uvm_info("[UVM_CMP_B]", "COMP-B RCVD DATA FROM COMP-A", UVM_NONE);
      `uvm_info("[UVM_CMP_B]", $sformatf("_addr_1 = %0d",t1._addr_1), UVM_NONE);
      `uvm_info("[UVM_CMP_B]", $sformatf("_addr_1_en = %0d",t1._addr_1_en), UVM_NONE); 
    end
    phase.drop_objection(this);
  endtask
  
endclass

class env extends uvm_component;
  `uvm_component_utils(env)
  compA CA;
  compB CB;

  function new(string name = "env", uvm_component parent = null);
    super.new(name, parent);
    `uvm_info("[UVM_ENV]", "ENV CREATED", UVM_NONE);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("[UVM_ENV]", "BUILD PHASE OF ENV STARTED", UVM_NONE);
    CA = compA::type_id::create("CA",this);
    CB = compB::type_id::create("CB",this);
    `uvm_info("[UVM_ENV]", "BUILD PHASE OF ENV COMPLETED", UVM_NONE);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("[UVM_ENV]", "CONNECT PHASE OF CMP-B STARTED", UVM_NONE);
    CB.compB_get_port.connect(CA.compA_get_imp);
    `uvm_info("[UVM_ENV]", "CONNECT PHASE OF CMP-B COMPLETED", UVM_NONE);
  endfunction
  
endclass
  

class my_test extends uvm_test;
  `uvm_component_utils(my_test)
  env e1;
  
  function new(string name = "my_test", uvm_component parent = null);
    super.new(name, parent);
    `uvm_info("[UVM_TST]", "TEST CREATED", UVM_NONE);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("[UVM_TST]", "BUILD PHASE OF TST STARTED", UVM_NONE);
    e1 = env::type_id::create("e1",this);
    `uvm_info("[UVM_TST]", "BUILD PHASE OF TST COMPLETED", UVM_NONE);
  endfunction

  virtual function void end_of_elaboration_phase(uvm_phase phase);
      super.end_of_elaboration_phase(phase);
      uvm_top.print_topology();
  endfunction
endclass

module tb;
  initial begin
    run_test("my_test");
  end
endmodule
