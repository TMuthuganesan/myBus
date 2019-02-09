class cpuWrSeq extends uvm_sequence;
  `uvm_object_utils(cpuWrSeq)
  
  wrPkt wrPktObj;
  rdPkt rdPktObj;
  int   numPkts = 5;
  
  function new (string name = "cpuWrSeq");
    super.new(name);
  endfunction
  
  task body();
    for (bit[7:0] i=0;i<numPkts;i=i+1)
      `uvm_do(wrPktObj);  //To generate pkts with random addr and data
  endtask
endclass