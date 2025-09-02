// UVM REPORTING MECHANISM
class my_txn extends uvm_sequence_item;
  `uvm_object_utils(my_txn)
  
  function new(string name = "my_txn");
    super.new(name);
    `uvm_info("SEQ INFO 1","Sequence Generated", UVM_NONE);
    `uvm_info("SEQ INFO 2","Sequence Generated", UVM_NONE);
    `uvm_info("SEQ INFO 3","Sequence Generated", UVM_MEDIUM);
    `uvm_info("SEQ INFO 4","Sequence Generated", UVM_NONE);
    `uvm_info("SEQ INFO 5","Sequence Generated", UVM_HIGH);
    `uvm_info("SEQ INFO 6","Sequence Generated", UVM_HIGH);
    `uvm_info("SEQ INFO 7","Sequence Generated", UVM_HIGH);
    `uvm_info("SEQ INFO 8","Sequence Generated", UVM_NONE);
    `uvm_info("SEQ INFO 9","Sequence Generated", UVM_NONE);
    `uvm_info("SEQ INFO 10","Sequence Generated", UVM_HIGH);
    `uvm_info("SEQ INFO 11","Sequence Generated", UVM_HIGH);
    `uvm_info("SEQ INFO 12","Sequence Generated", UVM_NONE);
    `uvm_info("SEQ INFO 13","Sequence Generated", UVM_NONE);
    `uvm_info("SEQ INFO 14","Sequence Generated", UVM_HIGH);
    `uvm_info("SEQ INFO 15","Sequence Generated", UVM_NONE);
    `uvm_info("SEQ INFO 16","Sequence Generated", UVM_FULL);
    `uvm_info("SEQ INFO 17","Sequence Generated", UVM_NONE);
    `uvm_info("SEQ INFO 18","Sequence Generated", UVM_FULL);
    `uvm_info("SEQ INFO 19","Sequence Generated", UVM_NONE);
    `uvm_info("SEQ INFO 20","Sequence Generated", UVM_FULL);
  endfunction
  
endclass

module tb;
  
  my_txn t1;
  
  initial begin
    t1 = my_txn::type_id::create("t1");
    // This wont work bcs it only works for component and not object
    // t1.set_report_verbosity_level(UVM_MEDIUM);
    uvm_root::get().set_report_verbosity_level_hier(UVM_MEDIUM);
  end
endmodule
