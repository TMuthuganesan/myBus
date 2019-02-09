class myPkt extends uvm_sequence_item;
  rand bit [2:0] mode;
  rand bit [7:0] addr;
  rand bit [7:0] data [];
  
  `uvm_object_utils_begin(myPkt)
    `uvm_field_int(mode,UVM_DEFAULT)
    `uvm_field_int(addr,UVM_DEFAULT)
    `uvm_field_array_int(data,UVM_DEFAULT)
  `uvm_object_utils_end
  
  function new (string name = "myPkt");
    super.new();
  endfunction
endclass
