//Subscriber is a listener - This subscriber listens to the
//analysis port of the monitor (i/p or o/p based on connection
//done in the agent)
class myBusCovMon extends uvm_subscriber #(myPkt);
  `uvm_component_utils (myBusCovMon)
  
  uvm_tlm_analysis_fifo #(myPkt)  covMonFifo;
  myPkt                           dutPkt;
  
  //This is a cover group which is used to capture functional
  //coverage based on executed packets to DUT. The coverpoints
  //specify what signal needs to be watch and bins collect the
  //data from that signal an place it on various bins.
  covergroup myBusCovGrp;
  //Check whether all possible modes are generated
  MODE: coverpoint dutPkt.mode{
    bins wrCmd    = {3'b000};
    bins rdCmd    = {3'b001};
    bins vdoRsp   = {3'b100};
    bins smapRsp  = {3'b110};
    bins error    = {3'b111};
  }
  
  //Check whether all possible address ranges are covered
  ADDR: coverpoint dutPkt.addr{
    bins addrLow  = {[0:100]};
    bins addrHi   = {[200:255]};
    bins addrErr  = {[1011:199]};
  }
  
  //Generate cross coverage between mode and address
  //For example, it checks with low range address is generated with all possible modes and so on...
  MODE_ADDR: cross MODE, ADDR;
  endgroup
  
  function new (string name="myBusCovMon",uvm_component parent);
    super.new(name, parent);
    myBusCovGrp = new();  //Cover group also needs to be created
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    covMonFifo  = new("covMonFifo", this);
  endfunction
  
  //This is the UVM TLM analysis port implementation uvm_analysis_imp
  //for the analysis port in the broadcaster, in this case monitor.
  //It is compulsory to have this function implemented in derived class
  //of subscriber class, as it is implemented as virtual function in 
  //uvm base subscriber component.
  function void write(T t);
  dutPkt = t;
  endfunction:write

  
  
  task main_phase(uvm_phase phase);
    //Read from output monitor
    forever
    begin
      covMonFifo.get(dutPkt);
      myBusCovGrp.sample();
    end   
  endtask
endclass