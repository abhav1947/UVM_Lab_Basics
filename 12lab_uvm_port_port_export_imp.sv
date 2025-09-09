// Port to Port to Export to Export
class txn extends uvm_object;
  
  randc int _addr_32_1;
  randc int _data_1;
  
  `uvm_object_utils_begin(txn)
  `uvm_field_int(_addr_32_1, UVM_ALL_ON)
  `uvm_field_int(_data_1, UVM_ALL_ON)
  `uvm_object_utils_end
  
  function new(string name = "txn");
    super.new(name);
    `uvm_info("[UVM_SEQ]", "Txn Object Created", UVM_NONE);
  endfunction 
endclass


class sub_block_A extends uvm_component;
  `uvm_component_utils(sub_block_A)
  uvm_blocking_put_port #(txn) sb_a_put;
  txn t_SB_A;
  
  int count_sb_a;
  
  function new(string name = "sub_block_A", uvm_component parent = null);
    super.new(name, parent);
    `uvm_info("[UVM_SB_A]", "Handle created for sub_block_a", UVM_NONE);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    t_SB_A = txn::type_id::create("t_SB_A");
    sb_a_put = new("sb_a_put",this);
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    repeat(count_sb_a) begin
      t_SB_A.randomize();
      sb_a_put.put(t_SB_A);
      `uvm_info("[UVM_SB_A]", "Data Sent From Sub_Block_A", UVM_NONE);
      `uvm_info("[UVM_SB_A]", $sformatf("_addr_32_1 = %0d",t_SB_A._addr_32_1), UVM_NONE);
      `uvm_info("[UVM_SB_A]", $sformatf("_addr_32_2 = %0d",t_SB_A._data_1), UVM_NONE);      
    end
    phase.drop_objection(this);
  endtask
endclass

class block_A extends uvm_component;
  `uvm_component_utils(block_A)
  
  uvm_blocking_put_port #(txn) b_a_put;
  sub_block_A sb_a;
  
  function new(string name = "block_A", uvm_component parent = null);
    super.new(name, parent);
    `uvm_info("[UVM_B_A]", "Handle created for block_a", UVM_NONE);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("[UVM_B_A]", "Executing Build Phase of Block A", UVM_NONE);
    sb_a = sub_block_A::type_id::create("sb_a",this);
    b_a_put = new("b_a_put", this);
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    `uvm_info("[UVM_B_A]", "Executing Connect phase of Block A", UVM_NONE);
    super.connect_phase(phase);
    sb_a.sb_a_put.connect(this.b_a_put);
  endfunction
endclass

class sub_block_B extends uvm_component;
  `uvm_component_utils(sub_block_B);
  
  uvm_blocking_put_imp #(txn, sub_block_B) sb_B_imp;
  
  function new(string name = "sub_block_B", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sb_B_imp = new("sb_B_imp", this);
  endfunction
  
  virtual task put(txn tmp);
    #10;
    `uvm_info("[UVM_SB_B]", "Data Rcvd to Driver from Sequencer via put method ", UVM_NONE);
    `uvm_info("[UVM_SB_B]", $sformatf("_addr_32_1 = %0d",tmp._addr_32_1), UVM_NONE);
    `uvm_info("[UVM_SB_B]", $sformatf("_addr_32_2 = %0d",tmp._data_1), UVM_NONE);       
  endtask
  
endclass


class block_B extends uvm_component;
  `uvm_component_utils(block_B)
  
  uvm_blocking_put_export #(txn) b_B_export;
  sub_block_B sb_b;
  
  function new(string name = "block_B", uvm_component parent = null);
    super.new(name, parent);
    `uvm_info("[UVM_B_B]", "Handle created for block_b", UVM_NONE);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("[UVM_B_B]","Executing Build Phase of Block B", UVM_NONE);
    sb_b = sub_block_B::type_id::create("sb_b", this);
    b_B_export = new("b_B_export", this);
  endfunction
              
  virtual function void connect_phase(uvm_phase phase);
    `uvm_info("[UVM_B_B]", "Executing Connect Block B", UVM_NONE)
    this.b_B_export.connect(sb_b.sb_B_imp);
  endfunction
  
endclass

//---------------- environment.sv ----------------
class environment extends uvm_component;
  `uvm_component_utils(environment)

  block_A ba;
  block_B bb;

  function new(string name="environment", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    ba = block_A::type_id::create("ba", this);
    bb = block_B::type_id::create("bb", this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    // Port (A) -> Export (B)
    ba.b_a_put.connect(bb.b_B_export);

    // Now that children are built, set the traffic count for sub_block_A
    // (You created sb_a inside block_A.build_phase, so it exists now.)
    ba.sb_a.count_sb_a = 5;
  endfunction
endclass

//---------------- test.sv ----------------
class my_test extends uvm_test;
  `uvm_component_utils(my_test)

  environment env;

  function new(string name="my_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = environment::type_id::create("env", this);
  endfunction
endclass

//---------------- tb.sv ----------------
module tb;
  initial begin
    run_test("my_test");
  end
endmodule
