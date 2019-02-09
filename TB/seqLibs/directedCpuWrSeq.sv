class directedCpuWrSeq extends uvm_sequence;
  `uvm_object_utils(directedCpuWrSeq)
  
  wrPkt wrPktObj;
  //rdPkt rdPktObj;
  int   numPkts = 5;
  
  function new (string name = "directedCpuWrSeq");
    super.new(name);
  endfunction
  
  task body();
    for (bit[7:0] i=0;i<numPkts;i=i+1)
      `uvm_do_with(wrPktObj,{addr==i;data[0]==i;}); //directed write with known addr and data
    
    //for (bit[7:0] i=0;i<numPkts;i=i+1)
    //  `uvm_do_with(rdPktObj,{addr==i;}); //directed read with known addr and data
  endtask
endclass