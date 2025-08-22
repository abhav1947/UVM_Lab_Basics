class my_trans extends uvm_sequence_item;
  
  // Registering the class created with factory for handle creation and overriding 
  `uvm_object_utils(my_trans)
  
  // Creating the custom constructor
  function new(string name = "my_trans");
    super.new(name);
    $display("[ASV INFO CONSTRUCTOR]: my_trans handle has been created");
  endfunction

  // Display function
  function display_s();
    $display("[ASV INFO DISPLAY]: my_trans handle has been created");
  endfunction
  
  
endclass

module tb;
  // Declaring a object of type my_trans
  my_trans m1;
  
  initial begin
    // Creating a handle or allocating memory for m1
    /*
    Here the type_id is a wrapper for uvm_registery, so first I will need ot access the my_trans which is wrapped using type_id within which there is create method to create a handle
    */
    m1 = my_trans::type_id::create("m1");
    m1.display_s();
  end
  
endmodule
