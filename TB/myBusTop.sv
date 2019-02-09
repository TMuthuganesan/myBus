`timescale 1ns/1ps
module myBusTop();
  import uvm_pkg::*;
  //If the below line is forgotten, the error is weird - no compile error,
  //while loading it says the test mentioned in cmd line +UVM_TESTNAME is not registered with factory, while it is actually registered.
  import myPkg::*;
  
  logic clk =0;
  
  dutIntf drvIntf(clk);
  dutIntf opMonIntf(clk);
  
  myBus DUT(
  .clk(clk),
  .modeIp(drvIntf.mode),
  .addrIp(drvIntf.addr),
  .dataIp(drvIntf.data),
  .selIp(drvIntf.sel),
  .rst(drvIntf.rst),
  .modeOp(opMonIntf.mode),
  .addrOp(opMonIntf.addr),
  .dataOp(opMonIntf.data),
  .selOp(opMonIntf.sel)
  );
  
  initial begin
    clk     = 1'b0;
    uvm_config_db#(virtual dutIntf)::set(null, "uvm_test_top.env.agnt", "drvIntf", drvIntf.drvMp);
    uvm_config_db#(virtual dutIntf)::set(null, "uvm_test_top.env.agnt", "opMonIntf", opMonIntf);
    uvm_config_db#(virtual dutIntf)::set(null, "uvm_test_top.env.agnt", "ipMonIntf", drvIntf.monMp);
    run_test();
  end
  
  always begin
    #5ns clk = ~clk;
  end
endmodule
  