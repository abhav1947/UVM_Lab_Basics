// Making Use of build phase to create objects for sequence, driver and monitor inside agent class
/***VERY IMPORTANT***/
/* Could not find member 'build_phase' in class 'uvm_sequence_item', at 
  "/apps/vcsmx/vcs/U-2023.03-SP2//etc/uvm-1.2/src/seq/uvm_sequence_item.svh", 
we can not use the buil_phase inside a class of any object type, it must be strictly used inside a component type class*/
`include "uvm_macros.svh"
import uvm_pkg::*;

// TXN 1
class wr_txn extends uvm_sequence_item;
  
  `uvm_object_utils(wr_txn)
  
  function new(string name = "wr_txn");
    super.new(name);
    $display("[ASF INFO] | [Constr status] : Success!!! :) Sequence handle created ");
  endfunction
  
endclass


// TXN 2
class wr_drv extends uvm_driver;
  
  `uvm_component_utils(wr_drv)
  
  function new(string name = "wr_drv", uvm_component parent = "null");
    super.new(name, parent);
    $display("[ASF INFO] | [Constr status] : Success!!! :) Driver handle created ");
  endfunction
  
endclass

// TXN 3
class wr_mon extends uvm_monitor;
  
  `uvm_component_utils(wr_mon)
  
  function new(string name = "wr_mon", uvm_component parent = "null");
    super.new(name, parent);
    $display("[ASF INFO] | [Constr status] : Success!!! :) Monitor handle created ");
  endfunction
endclass

// SEQUENCE CLASS
class my_agnt extends uvm_agent;
  
  `uvm_component_utils(my_agnt)
  wr_txn tx1;
  wr_drv dr1;
  wr_mon mon1;
  
  
  function new(string name = "my_agnt", uvm_component parent = null);
    super.new(name,parent);
    $display("[ASF INFO] | [Constr status] : Success!!! :) Agent handle created ");
  endfunction
  
  // Other than the run_phase all the other phases do not consume time hence we make use of function
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    $display("[ASV INFO] | BUILD PHASE | START OF BUILD PHASE ");
    tx1 = wr_txn::type_id::create("tx1");
    dr1 = wr_drv::type_id::create("dr1", this);
    mon1 = wr_mon::type_id::create("mon1", this);
    $display("[ASV INFO] | BUILD PHASE | END OF BUILD PHASE ");
  endfunction
endclass

// Test class
class test extends uvm_test;
  `uvm_component_utils(test)
  
  my_agnt agnt1;
  
  function new(string name = "test", uvm_component parent = null);
    super.new(name, parent);
    $display("[ASV INFO] | | Success!!! :) test handle created");
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agnt1 = my_agnt::type_id::create("agnt1",this);
  endfunction
  
endclass

module tb;
  // To start the uvm pahses we must call the run_test function and pass the test case. 
  initial run_test("test");
endmodule
