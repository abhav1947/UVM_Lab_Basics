class _1_trans extends uvm_sequence_item;
  //`uvm_object_utils(_1_trans)
  
  // Registering these variables witth factory to make use of the predefined methods
  
  randc int data1, data2;
  randc bit [3:0] data;
  
  // Factory registration of variables
  `uvm_object_utils_begin(_1_trans)
  	`uvm_field_int(data, UVM_ALL_ON)
  	`uvm_field_int(data1, UVM_ALL_ON)
  	`uvm_field_int(data2, UVM_ALL_ON)
  `uvm_object_utils_end
  
  // Custom constructor
  function new(string name = "_1_trans");
    super.new(name);
    $display("[ASV INFO] : [trans_constr] : !!!Success!!! :) Handle created");
  endfunction
  
  // Displaying Data
  function display_s();
    $display("[ASV INFO] : [Data Prints] : Data=%0d",data);
    $display("[ASV INFO] : [Data Prints] : Data1=%0d",data1);
    $display("[ASV INFO] : [Data Prints] : Data2=%0d",data2);
  endfunction
  
endclass


module tb;
  _1_trans t1;
  
  initial begin
    t1=_1_trans::type_id::create("t1");
    repeat(10) begin
    assert(t1.randomize()) $display("Assertion Successful!!!");
      else $display("Assertion FAILED!!!") ;
    t1.display_s();
    end
  end
  
endmodule
