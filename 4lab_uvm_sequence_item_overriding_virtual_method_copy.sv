// Overriding virtual functions, so that we dont register variables with factory
class write_txn extends uvm_sequence_item;
  `uvm_object_utils(write_txn)
  randc bit [3:0] data1, data2, data3;
  
  
  function new(string name  = "write_txn");
    super.new(name);
    $display("[ASV INFO] : [Constr Status] : Seccess!!! :) Handle Created");
  endfunction

  // This is similar to creating a depp copy in SV
  // Here we will override the parent function using the super.do_copy(<object_name>)
  function void copy(uvm_object my_obj);
    write_txn t1;
    $cast(t1,my_obj);
    super.do_copy(my_obj);
    data1 = t1.data1;
    data2 = t1.data2;
    data3 = t1.data3;
  endfunction
  
  function void print();
    $display("[ASV INFO] : [Data Prints] : _t2.data1 = %0d", data1);
    $display("[ASV INFO] : [Data Prints] : _t2.data2 = %0d", data2);
    $display("[ASV INFO] : [Data Prints] : _t2.data3 = %0d", data3);
  endfunction
  
endclass

module tb;
  write_txn _t1;
  write_txn _t2;
  
  initial begin
    _t1 = write_txn::type_id::create("_t1");
    _t2 = write_txn::type_id::create("_t2");
    _t1.randomize();
    _t2.copy(_t1);
    $display("[ASV INFO] : [_t1 handle Data]");
    _t1.print();
    $display("[ASV INFO] : [_t2 handle Data]");
	_t2.print();
  end
  
endmodule
