class directedCpuWrTest extends baseTest;
  `uvm_component_utils(directedCpuWrTest)
  
  directedCpuWrSeq  cpuWrSeqObj;
  
  function new (string name = "directedCpuWrTest", uvm_component parent);
    super.new (name, parent);
    $display("Test Name = %s",name);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    //Typically timeout is set in the top file inside the initial block from where 
    //run_test() is called. But this will become a common timeout for all test cases.
    //Hence is is being set inside the build phase of each test, so that each test can
    //have its own timeout. In this case, it the run_phase gets hung more than 5us, 
    //the timeout will occur and the run phase will be terminated automatically and 
    //stop phase activities if any will be performed.
    //Setting it in run_phase is too late and will not be honored.
    set_global_timeout(5_000_000);  //time in ps. 5us, 5000ns type argument with unit is not working, but expected to work.
  endfunction
  
  task run_phase(uvm_phase phase);
    cpuWrSeqObj  = directedCpuWrSeq::type_id::create("cpuWrSeqObj",this);
    phase.raise_objection(this);
    cpuWrSeqObj.start(env.agnt.sqncr);
    #2us;
    phase.drop_objection(this);
  endtask
endclass