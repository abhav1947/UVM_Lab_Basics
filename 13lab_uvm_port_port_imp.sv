// Port to Port to Imp

class txn extends uvm_object;
  randc int _addr_1_32;
  randc bit _addr_1_32_en;
  
  `uvm_object_utils_begin(txn)
  `uvm_field_int(_addr_1_32, UVM_ALL_ON)
  `uvm_field_int(_addr_1_32_en, UVM_ALL_ON)
  `uvm_object_utils_end
  
  function new(string name = "txn");
    super.new(name);
    `uvm_info("[UVM_SEQ]", "Sequence Created", UVM_NONE);
  endfunction
  
endclass


class sub_block_a extends uvm_component;
  `uvm_component_utils(sub_block_a)
  uvm_blocking_put_port #(txn) sb_a_port;
  txn t1;
  
  int count=6;
  
  function new(string name = "sub_block_a", uvm_component parent = null);
    super.new(name,parent);
    `uvm_info("[UVM_SB_A]", "SUB BLOCK A CREATED", UVM_NONE);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    t1 = txn::type_id::create("t1");
    sb_a_port = new("sb_a_port", this);
  endfunction
  
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    repeat(count) begin
      t1.randomize();
      `uvm_info("[UVM_SB_A]", "DATA SENT BY SUB BLOCK A", UVM_NONE);
      `uvm_info("[UVM_SB_A]", $sformatf("_addr_1_32 = %0d",t1._addr_1_32), UVM_NONE);
      `uvm_info("[UVM_SB_A]", $sformatf("_addr_1_32_en = %0d",t1._addr_1_32_en), UVM_NONE);
      sb_a_port.put(t1);
      #10;
    end
    phase.drop_objection(this);
  endtask
endclass


class block_a extends uvm_component;
  `uvm_component_utils(block_a)
  uvm_blocking_put_port #(txn) b_a_port;
  sub_block_a sb_a;
  
  function new(string name = "block_a", uvm_component parent = null);
    super.new(name, parent);
    `uvm_info("[UVM_B_A]", "BLOCK A CREATED", UVM_NONE);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("[UVM_B_A]", "BUILD PHASE OF BLOCK A RUNNING", UVM_NONE);
    b_a_port = new("b_a_port",this);
    sb_a = sub_block_a::type_id::create("sb_a",this);
    `uvm_info("[UVM_B_A]", "BUILD PHASE OF BLOCK A COMPLETED", UVM_NONE);
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("[UVM_B_A]", "CONNECT PHASE OF BLOCK A RUNNING", UVM_NONE);
    sb_a.sb_a_port.connect(this.b_a_port);
    `uvm_info("[UVM_B_A]", "CONNECT PHASE OF BLOCK A COMPLETED", UVM_NONE);
  endfunction
endclass

class block_b extends uvm_component;
  `uvm_component_utils(block_b)
  uvm_blocking_put_imp #(txn, block_b) b_b_imp;
  
  function new(string name = "sub_block_b", uvm_component parent = null);
    super.new(name,parent);
    `uvm_info("[UVM_SB_B]", "SUB BLOCK B CREATED", UVM_NONE);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("[UVM_B_B]", "BUILD PHASE OF BLOCK B RUNNING", UVM_NONE);
    b_b_imp = new("b_b_imp", this);
    `uvm_info("[UVM_B_B]", "BUILD PHASE OF BLOCK B COMPLETED", UVM_NONE); 
  endfunction
  
  task put(txn tmp);
    `uvm_info("[UVM_SB_B]", "DATA RCVD BY BLOCK B", UVM_NONE);
    `uvm_info("[UVM_SB_B]", $sformatf("_addr_1_32 = %0d",tmp._addr_1_32), UVM_NONE);
    `uvm_info("[UVM_SB_B]", $sformatf("_addr_1_32_en = %0d",tmp._addr_1_32_en), UVM_NONE);
  endtask
endclass

class env extends uvm_component;
  `uvm_component_utils(env)
  
  block_a ba;
  block_b bb;
  
  function new(string name = "env", uvm_component parent = null);
    super.new(name, parent);
    `uvm_info("[UVM_ENV]", "ENV CREATED", UVM_NONE);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("[UVM_ENV]", "BUILD PHASE OF ENV RUNNING", UVM_NONE);
    ba = block_a::type_id::create("ba", this);
    bb = block_b::type_id::create("bb", this);
    `uvm_info("[UVM_ENV]", "BUILD PHASE OF ENV COMPLETED", UVM_NONE);
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("[UVM_ENV]", "CONNECT PHASE OF ENV RUNNING", UVM_NONE);
    ba.b_a_port.connect(bb.b_b_imp);
    `uvm_info("[UVM_ENV]", "CONNECT PHASE OF ENV COMPLETED", UVM_NONE);
  endfunction
endclass

class test extends uvm_test;
  `uvm_component_utils(test)
  
  env e1;
  
  function new(string name="test", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("[UVM_TEST]", "BUILD PHASE OF TEST RUNNING", UVM_NONE);
    e1 = env::type_id::create("e1", this);
    `uvm_info("[UVM_TEST]", "BUILD PHASE OF TEST COMPLETED", UVM_NONE);
  endfunction
  
endclass
    
module tb;
  initial begin
    run_test("test");
  end
endmodule
