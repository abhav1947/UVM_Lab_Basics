// Using the inbuilt copy and print method
class write_txn extends uvm_sequence_item;
  randc bit [3:0] data1, data2, data3;
  
  `uvm_object_utils_begin(write_txn)
  	`uvm_field_int(data1, UVM_ALL_ON)
    `uvm_field_int(data2, UVM_ALL_ON)
    `uvm_field_int(data3, UVM_ALL_ON)
  `uvm_object_utils_end
  
  function new(string name = "write_txn");
    super.new(name);
    $display("[ASV INFO] : [Constr Status] : Success!!! :) Handle created");
  endfunction
  
endclass


module tb;
  write_txn txn1;
  write_txn txn2;
  
  initial begin 
    txn1 = write_txn::type_id::create("txn1");
    txn2 = write_txn::type_id::create("txn2");
    assert(txn1.randomize()) $display("[ASV INFO] : [Assertion Status] : SUCCESS!! Randomization Successful");
    else $display("[ASV INFO] : [Assertion Status] : FAILED!!! :( Randomization Successful");
    txn2.copy(txn1);
    txn1.print();
    txn2.print();
  end
endmodule
