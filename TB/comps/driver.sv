class myBusDrvr extends uvm_driver #(myPkt);
  
  `uvm_component_utils(myBusDrvr)
  
  myPkt   pkt;
  virtual dutIntf.drvMp  myVif;
  
  function new (string name = "myBusDrvr", uvm_component parent);
    super.new(name,parent);
  endfunction
  
  extern virtual task reset_phase(uvm_phase phase);
  extern virtual task main_phase(uvm_phase phase);
  extern virtual task sendPkt(myPkt pkt);
endclass

//reset_phase is one of the 13 phases in the run_phase where DUT and others can be reset
task myBusDrvr::reset_phase(uvm_phase phase);
  `uvm_info(get_name(),"Resetting DUT...", UVM_LOW)
  phase.raise_objection(this);
  myVif.rst   <= 1'b1;
  myVif.mode  <= 3'b111;
  myVif.addr  <= 8'd0;
  myVif.data  <= 8'h0;
  myVif.sel   <= 1'b0;
  #100ns;
  myVif.rst   <= 1'b0;
  phase.drop_objection(this);
endtask

//main_phase is one of the 13 phases in the run_phase where actual simulation happens
//This should NOT be run_phase. If below task is run_phase, it will start in parallel with 
//reset_phase. As a symptom of this, while reset is applied to DUT, packets will also be
//sent from driver.
task myBusDrvr::main_phase(uvm_phase phase);
  `uvm_info(get_name(),"Driver Starting to Drive...", UVM_LOW)
  forever begin
    //req can be used by default without declaring. 
    //If some other var is used, it needs to be defined inside the class and register to factory.
    //seq_item_port.get_next_item(req);
    //phase.raise_objection(this);
    //sendPkt(req);
    
    seq_item_port.get_next_item(pkt);
    phase.raise_objection(this);
    sendPkt(pkt);
    #50ns;  //Inter packet gap
    seq_item_port.item_done();
    phase.drop_objection(this);
  end
endtask

task myBusDrvr::sendPkt(myPkt pkt);
  bit [7:0] addr;
  `uvm_info(get_name(),"Packet being sent to DUT is ",UVM_LOW)
  this.pkt.print();
  
  addr   =  pkt.addr;
  foreach (pkt.data[i])
  begin
    @(negedge myVif.clk);
    myVif.mode  <= pkt.mode;
    myVif.addr  <= addr;
    myVif.data  <= pkt.data[i];
    myVif.sel   <= 1'b1;
    addr++;
  end  
  @(negedge myVif.clk);
  myVif.sel   <= 1'b0;
endtask