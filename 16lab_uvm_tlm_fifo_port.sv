class txn extends uvm_object;
  randc bit [3:0] addr1;
  randc bit [3:0] data1;
  
  `uvm_object_utils_begin(txn)
  `uvm_field_int(addr1, UVM_ALL_ON)
  `uvm_field_int(data1, UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name  = "txn");
    super.new(name);
  endfunction
  
endclass

class apb_gen extends uvm_component;
  `uvm_component_utils(apb_gen);
  txn t1;
  uvm_blocking_put_port #(txn) put_port;
  
  function new(string name  = "apb_gen", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    put_port = new("put_port", this);
    t1 = txn::type_id::create("t1");
  endfunction
  
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    repeat(10) begin
      t1.randomize();
      `uvm_info("[APB_GEN]", "DATA GEN STARTED", UVM_NONE);
      `uvm_info("[APB_GEN]", $sformatf("ADDR = %0d",t1.addr1), UVM_NONE);
      `uvm_info("[APB_GEN]", $sformatf("DATA = %0d",t1.data1), UVM_NONE);
      `uvm_info("[APB_GEN]", "DATA SENT TO TLM_FIFO", UVM_NONE);
      put_port.put(t1);
      #10;
    end
    phase.drop_objection(this);
  endtask
endclass


class apb_drv extends uvm_component;
  `uvm_component_utils(apb_drv)
  uvm_blocking_get_port #(txn) get_port;
  txn t2;
  
  function new(string name = "apb_drv", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    get_port = new("get_port", this);
    t2 = txn::type_id::create("t2");
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    repeat(10) begin
      get_port.get(t2);
      `uvm_info("[APB_GEN]", "DATA RCVD FROM TLM_FIFO", UVM_NONE);
      `uvm_info("[APB_GEN]", $sformatf("ADDR = %0d",t2.addr1), UVM_NONE);
      `uvm_info("[APB_GEN]", $sformatf("DATA = %0d",t2.data1), UVM_NONE);
    end
  endtask
endclass


class apb_agent extends uvm_component;
  `uvm_component_utils(apb_agent)
  uvm_tlm_fifo #(txn) fifoh;
  apb_gen apb_gen1;
  apb_drv apb_drv1;
  
  function new(string name = "apb_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    apb_gen1 = apb_gen::type_id::create("apb_gen1", this);
    apb_drv1 = apb_drv::type_id::create("apb_drv1", this);
    fifoh = new("fifoh", this);
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    apb_gen1.put_port.connect(fifoh.put_export);
    apb_drv1.get_port.connect(fifoh.get_export);
  endfunction
endclass

class my_test extends uvm_test;
  `uvm_component_utils(my_test);
  apb_agent a1;
  
  function new(string name = "my_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction  
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    a1 =apb_agent::type_id::create("a1", this);
  endfunction 
endclass

module tb;
  initial begin
    run_test("my_test");
  end
endmodule
