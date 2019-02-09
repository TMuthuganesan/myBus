class myBusSeqr extends uvm_sequencer #(myPkt);
  
  `uvm_component_utils(myBusSeqr)
  
  function new(string name ="myBusSeqr",uvm_component parent);
    super.new(name,parent);
    //Print just to show the use of parent - to construct the right hierarchy.
    //The below print will print the name of agent with its hierarchy.
    $display("********************The name of parent is %p****************",parent.get_full_name);
  endfunction
endclass