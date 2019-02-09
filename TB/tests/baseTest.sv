class baseTest extends uvm_test;
  `uvm_component_utils (baseTest)
  
  myEnv env;
  uvm_report_server rptServer;
  
  function new (string name = "baseTest",uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = myEnv::type_id::create("env",this);
  endfunction
  
  function void end_of_elaboration();
    uvm_top.print_topology(); //Prints the hierarchical connected components of this env
    factory.print(); //prints comps registered with factory
  endfunction
  
  function void report_phase (uvm_phase phase);
    int numErrors;
    super.report_phase(phase);
    numErrors = getTotalErrCnt();
    $display("\n\nTOTAL NUMBER OF ERRORS DURING SIMULATION = %0d",numErrors);
    if (numErrors>0)
    begin
      $display("********************************************************");
      $display("**********************TEST FAIL*************************");
      $display("********************************************************\n\n");
      //we can write some exit code into some result file too
    end
    else
    begin
      $display("********************************************************");
      $display("**********************TEST PASS*************************");
      $display("********************************************************\n\n");
    end
  endfunction
  
  function int getTotalErrCnt();
  begin
    rptServer = uvm_report_server::get_server();
    return (rptServer.get_severity_count(UVM_FATAL) + rptServer.get_severity_count(UVM_ERROR));
  end
  endfunction
  
endclass