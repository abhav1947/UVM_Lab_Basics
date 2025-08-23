// Overriding Virtual do_compare method, to avoid variable registartion with factory
class write_txn extends uvm_sequence_item;
  `uvm_object_utils(write_txn)
  
  randc logic [31:0] addr;
  randc logic _parity_bit;
  
  function new(string name = "write_txn");
    super.new(name);
    $display("[ASV INFO] : [Constr STatus] : Success!! :) Handle Created");
  endfunction
  
  virtual function bit compare(uvm_object _txn_wr, uvm_comparer comparer);
    write_txn t1;
    if($cast(t1,_txn_wr))
      $display("Handle successfully copied");
    else
      $display("[ASV INFO] : [ERROR] : FAILLL!!!! :(");
    return ((super.do_compare(_txn_wr, comparer)) &&
            (addr == t1.addr) &&
            (_parity_bit == t1._parity_bit));
  endfunction
endclass

module tb;
  write_txn t1, t2;
  
  initial begin
    t1 = write_txn::type_id::create("t1");
    t2 = write_txn::type_id::create("t2");
    t1.randomize();
    t2.randomize();
    assert(t1.compare(t2,null)) begin 
      $display("[ASV INFO] : [COMPARE PASS] : COMPARISON EQUAL");
      $display("[ASV INFO] : [COMPARISION DATA] : STATUS = %0d",t1.compare(t2,null));
      end
    begin
      $display("[ASV INFO] : [COMPARE FAIL] : COMPARISON NOT EQUAL");
      $display("[ASV INFO] : [COMPARISION DATA] : STATUS = %0d",t1.compare(t2,null));
    end
    end
  
endmodule
