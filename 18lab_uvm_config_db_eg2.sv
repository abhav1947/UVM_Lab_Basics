class txn extends uvm_object;
  `uvm_object_utils(txn)
  randc int a;
  randc int b;
  
  function new(string name = "txn");
    super.new(name);
  endfunction
endclass

class cl_a extends uvm_component;
  `uvm_component_utils(cl_a)
  txn t1;
  
  function new(string name = "cl_a", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    t1 = txn::type_id::create("t1");
  endfunction
  
  task run_phase(uvm_phase phase);
    if(!(uvm_config_db #(txn)::get(this,"","txn_1",t1))) begin
      `uvm_error("cl_a","CONFIG_DB ERROR");
    end
    else begin
      $display("Data rcvd via uvm_config_db");
      `uvm_info("cl_a",$sformatf("The val of a = %0d",t1.a), UVM_NONE);
      `uvm_info("cl_a",$sformatf("The val of b = %0d",t1.b), UVM_NONE);
    end
  endtask
  
endclass


class cl_b extends uvm_component;
  `uvm_component_utils(cl_b);
  txn t2;
  
  function new(string name = "cl_b", uvm_component parent = null);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    t2 = txn::type_id::create("t2");
    repeat(1) begin
      t2.randomize();
      `uvm_info("cl_b",$sformatf("The val of a = %0d",t2.a), UVM_NONE);
      `uvm_info("cl_b",$sformatf("The val of b = %0d",t2.b), UVM_NONE);
    end
  endfunction
endclass

class test extends uvm_component;
  `uvm_component_utils(test);

  cl_a ca;
  cl_b cb;
  
  function new(string name = "test", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    ca = cl_a::type_id::create("ca",this);
    cb = cl_b::type_id::create("cb",this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    uvm_config_db #(txn)::set(this,"cb","txn_1",cb.t2);
    $display("Data rcvd via uvm_config_db");
    `uvm_info("test",$sformatf("The val of a = %0d",cb.t2.a), UVM_NONE);
    `uvm_info("test",$sformatf("The val of b = %0d",cb.t2.b), UVM_NONE);
  endfunction
endclass


module tb;
  initial begin
    run_test("test");
  end
endmodule
