// Non blocking put method
class txn extends uvm_object;
  
  randc int _addr_32_1;
  randc int _addr_32_2;
  
  `uvm_object_utils_begin(txn)
  `uvm_field_int(_addr_32_1, UVM_ALL_ON)
  `uvm_field_int(_addr_32_2, UVM_ALL_ON)
  `uvm_object_utils_end
  
  function new(string name = "txn");
    super.new(name);
  endfunction
  
endclass


class sequencer extends uvm_component;
  
  `uvm_component_utils(sequencer)
  
  int count;
  txn t1;
  
  // Declaring a blocking put port 
  uvm_nonblocking_put_port #(txn) seq_put;
  
  function new(string name = "sequencer", uvm_component parent = null);
    super.new(name,parent);
    `uvm_info("[UVM_SEQR]", "Seqr handle Created", "UVM_NONE");
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // Creating an object for the transaction which will be sent to the driver
    t1 = txn::type_id::create("t1");
    // Defining a blocking put port
    seq_put = new("seq_put",this);
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    // uvm objection is like a statement syaing "wait I still have some work to be completed please dont end the uvm phases"
    phase.raise_objection(this);
    repeat(count) begin
      bit success;
      t1.randomize();
      `uvm_info("[UVM SEQR]", "Data sent from seqr", UVM_NONE);
      `uvm_info("[UVM_SEQR]", $sformatf("_addr_32_1 = %0d",t1._addr_32_1), UVM_NONE);
      `uvm_info("[UVM_SEQR]", $sformatf("_addr_32_2 = %0d",t1._addr_32_2), UVM_NONE);
      // Here we are sending the transaction object from sequencer to driver via the put method
      success = seq_put.try_put(t1);
      if (success) begin
          `uvm_info("[UVM_SEQR]", $sformatf("DRV accepted and transfer is successful"), UVM_NONE);
      end
      else begin
          `uvm_info("[UVM_SEQR]", $sformatf("DRV was NOT ready to accept and transfer failed"), UVM_NONE);
      end
    end
    phase.drop_objection(this);
  endtask
endclass


class driver extends uvm_component;
  
  `uvm_component_utils(driver)
  
  // Put implementation decleration
  uvm_nonblocking_put_imp #(txn, driver) drv_put_imp;
  
  function new(string name = "driver", uvm_component parent = null);
    super.new(name, parent);
    `uvm_info("[UVM_Drv]", "Drv handle Created", "UVM_NONE");
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    drv_put_imp = new("drv_put_imp", this);
  endfunction
  
  // try put implementattion definition
  virtual function bit try_put(txn tmp);
    `uvm_info("[UVM_DRV]", "Data Rcvd to Driver from Sequencer via put method ", UVM_NONE);
    `uvm_info("[UVM_DRV]", $sformatf("_addr_32_1 = %0d",tmp._addr_32_1), UVM_NONE);
    `uvm_info("[UVM_DRV]", $sformatf("_addr_32_2 = %0d",tmp._addr_32_2), UVM_NONE); 
    return 1;
  endfunction
  
  virtual function bit can_put();
  endfunction
endclass

class environment extends uvm_component;
  
  `uvm_component_utils(environment);
  
  driver d1;
  sequencer s1;
  
  function new(string name = "environment", uvm_component parent = null);
    super.new(name, parent);
    `uvm_info("[UVM_ENV]", "Env handle Created", "UVM_NONE");
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    d1 = driver::type_id::create("d1", this);
    s1 = sequencer::type_id::create("s1", this);
    s1.count = 5;
  endfunction
  
  // Connecting the blocking put port to export
  virtual function void connect_phase(uvm_phase phase);
    s1.seq_put.connect(d1.drv_put_imp);
  endfunction
  
endclass

class my_test extends uvm_test;
  `uvm_component_utils(my_test)

  environment e1;

  function new(string name="my_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    e1 = environment::type_id::create("e1", this);
  endfunction
endclass

module tb;
  initial begin
    run_test("my_test");
  end
endmodule
