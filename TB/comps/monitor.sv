class myBusMon extends uvm_monitor;
  `uvm_component_utils (myBusMon)
  
  myPkt                      pkt;
  uvm_analysis_port #(myPkt) mbxMon2Scb;
  virtual dutIntf.monMp      myVif;
  
  function new (string name = "myBusMon", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    pkt         = myPkt::type_id::create("pkt",this);
    //This TLM port need not be create using create factory method, as it is being used only between
    //this monitor and this scoreboard. There is not going to be reuse of this port somewhere else.
    //As there will be no factory overriding, no create is required and a simple new() would do.
    //Also it is parameterized with type of transaction that passes through this port, while declaring.
    mbxMon2Scb  = new("mbxMon2Scb",this);
  endfunction
  
  task run_phase(uvm_phase phase);
    int payldCnt  = 0;
    forever begin
      @(negedge myVif.clk);
      if (myVif.sel)
      begin
        `uvm_info(get_name(),"Pkt found, starting to collect data",UVM_LOW)
        if(payldCnt == 0)
        begin
          pkt.mode    = myVif.mode;
          pkt.addr    = myVif.addr;
          pkt.data    = new[1];
        end
        else
        begin
          pkt.data  = new[pkt.data.size()+1](pkt.data);
        end
        pkt.data[payldCnt] = myVif.data;
        payldCnt           = payldCnt + 1;
        $display ("At time %t, payload count = %0d",$time,payldCnt);
      end
      if (payldCnt>0) //pkt rxd
      begin
        `uvm_info(get_name(),"Packet captured",UVM_LOW)
        mbxMon2Scb.write(pkt);
        payldCnt  = 0;
      end
    end
  endtask
endclass