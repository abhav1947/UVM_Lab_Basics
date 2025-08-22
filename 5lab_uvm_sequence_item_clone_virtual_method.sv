// Clone method

class write_txn extends uvm_sequence_item;
  int data1, data2, data3;
  
  `uvm_object_utils_begin(write_txn)
  	`uvm_field_int(data1, UVM_ALL_ON);
  	`uvm_field_int(data2, UVM_ALL_ON);
  	`uvm_field_int(data3, UVM_ALL_ON);
  `uvm_object_utils_end
  
  function new(string name = "write_txn");
    super.new(name);
    $display("[ASV INFO] : [Constr Status] : Success!!! :) Handle Created");
  endfunction  
endclass

module tb;
  
  write_txn t1, t2;
  
  initial begin
    t1 = write_txn::type_id::create("t1");
    //t1 = new("t1");
    $cast(t2,t1.clone());
  end
  
endmodule

