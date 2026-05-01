class my_seq extends uvm_sequence_item;
  `uvm_object_utils(my_seq)
  randc int a [];
  randc int b [];
  
  constraint _a{a.size() == 4;
                foreach(a[i]) {
                  a[i] inside {[0:10]};}
                a.sum() == 20;
               	}
  
  constraint _b{b.size() == 4;
                foreach(b[i]) {
                  b[i] inside {[0:10]};}
                b.sum() == 10;}
  
  function new(string name = "my_seq");
    super.new(name);
    `uvm_info("[my_seq]", "my_seq object creation completed", UVM_NONE);
  endfunction
endclass

class my_test extends uvm_test;
  `uvm_component_utils(my_test)
  my_seq s1;
  
  function new(string name = "my_seq", uvm_component parent = null);
    super.new(name, parent);
    `uvm_info("[my_test]", "my_test object creation completed", UVM_NONE);    
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    `uvm_info("[my_test]", "s1 object creation started", UVM_NONE);
    s1 = my_seq::type_id::create("s1");
    `uvm_info("[my_test]", "s1 object created", UVM_NONE);
    repeat(10) begin
    	_randomize();
      `uvm_info("[my_test]", $sformatf("a is %p", s1.a), UVM_NONE);
      `uvm_info("[my_test]", $sformatf("b is %p", s1.b), UVM_NONE);
    end
  endfunction
  
  task _randomize();
    s1.randomize();
  endtask
endclass

module tb;
  initial begin
    run_test("my_test");
  end
endmodule
