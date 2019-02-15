class myBusDrvr extends uvm_driver #(myPkt);
  
  `uvm_component_utils(myBusDrvr)
  
  myPkt   pkt, copiedPkt;
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
    
    //dummy code to show copy method
    //dummy code start
    //The copy works even without having do_copy method in the base transaction class.
    //Typically it is recommended that the user writes his own do_copy and do_print methods
    //that can give definition to the corresponding pkt. uvm_object class has copy method 
    //defined, it is overridden by copy method in uvm_transaction class, which copies its
    //own local properties like begin_time etc. uvm_sequence_item is a derived class of uvm_transaction,
    //which does not have any do_copy implemented. myPkt is a derived class of uvm_sequence_item, which
    //also has no definition of do_copy. But the below code works fine - How? The obvious question is
    //if the derived myPkt class does not have this method, the last definition is found in uvm_transaction.
    //The parent class can not access properties of the derived class, then who is copying addr, mode and data?
    //Thats done by factory - these fields are registered in myPkt class along with class registration with UVM_DEFUALT.
    //This cause the copy and other default methods like clone, compare, print, sprint to work as expected. If the
    //factory registration of individual fields are removed, the copy will fail and all values addr, mode and data will be 0s.
    copiedPkt = new();
    copiedPkt.copy(pkt);
    $display("###########################################################");
    $display("pkt object in driver is %p",pkt.sprint());
    $display("copiedPkt object in driver is %p",copiedPkt.sprint());
    $display("###########################################################");
    //dummy code end
    
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