class cpuWrRdTest extends baseTest;
  `uvm_component_utils(cpuWrRdTest)
  
  cpuWrSeq  cpuWrSeqObj;
  cpuRdSeq  cpuRdSeqObj;
  
  function new (string name = "cpuWrRdTest", uvm_component parent);
    super.new (name, parent);
    $display("Test Name = %s",name);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    set_global_timeout(5_000_000);  //time in ps. 5us, 5000ns type argument with unit is not working, but expected to work.
  endfunction
  
  task run_phase(uvm_phase phase);
    cpuWrSeqObj  = cpuWrSeq::type_id::create("cpuWrSeqObj",this);
    cpuRdSeqObj  = cpuRdSeq::type_id::create("cpuRdSeqObj",this);
    phase.raise_objection(this);
    cpuWrSeqObj.numPkts = 2;
    cpuRdSeqObj.numPkts = 3;
    cpuWrSeqObj.start(env.agnt.sqncr);
    cpuRdSeqObj.start(env.agnt.sqncr);
    #2us;
    phase.drop_objection(this);
  endtask
endclass