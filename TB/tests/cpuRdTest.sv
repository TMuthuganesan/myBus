class cpuRdTest extends baseTest;
  `uvm_component_utils(cpuRdTest)
  
  cpuRdSeq  cpuRdSeqObj;
  
  function new (string name = "cpuRdTest", uvm_component parent);
    super.new (name, parent);
    $display("Test Name = %s",name);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    set_global_timeout(5_000_000);  //time in ps. 5us, 5000ns type argument with unit is not working, but expected to work.
  endfunction
  
  task run_phase(uvm_phase phase);
    cpuRdSeqObj  = cpuRdSeq::type_id::create("cpuRdSeqObj",this);
    phase.raise_objection(this);
    cpuRdSeqObj.start(env.agnt.sqncr);
    #2us;
    phase.drop_objection(this);
  endtask
endclass