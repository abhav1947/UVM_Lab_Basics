// UVM REPORTING MECHANISM
class my_txn extends uvm_sequence_item;
  `uvm_object_utils(my_txn)
  
  function new(string name = "my_txn");
    super.new(name);
    `uvm_info("SEQ INFO","Sequence Generated", UVM_NONE);
    //`uvm_fatal("SEQ FATAL ERROR","Sequence Generated");
    `uvm_error("SEQ ERROR","Sequence Generated");
    `uvm_warning("SEQ WARNING","Sequence Generated");
  endfunction
  
endclass

module tb;
  
  my_txn t1;
  
  initial begin
    t1 = my_txn::type_id::create("t1");
  end
endmodule
