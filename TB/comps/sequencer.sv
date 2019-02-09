class myBusSeqr extends uvm_sequencer #(myPkt);
  
  `uvm_component_utils(myBusSeqr)
  
  function new(string name ="myBusSeqr",uvm_component parent);
    super.new(name,parent);
  endfunction
endclass