class cpuRdSeq extends uvm_sequence;
  `uvm_object_utils(cpuRdSeq)
  
  rdPkt rdPktObj;
  int   numPkts = 5;
  
  function new (string name = "cpuRdSeq");
    super.new(name);
  endfunction
  
  task body();
    for (bit[7:0] i=0;i<numPkts;i=i+1)
      `uvm_do(rdPktObj);  //To generate pkts with random addr
  endtask
endclass