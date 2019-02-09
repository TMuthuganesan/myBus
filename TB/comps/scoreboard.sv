class myBusScb extends uvm_scoreboard;
  `uvm_component_utils(myBusScb)
  
  uvm_tlm_analysis_fifo #(myPkt)  mbxOpMon2ScbFifo;
  uvm_tlm_analysis_fifo #(myPkt)  mbxIpMon2ScbFifo;
  myPkt                           dutIpPkt, dutOpPkt;
  
  //Signals for DUT model
  reg [7:0]   mem     [256];
  reg [7:0]   vdoMem  [256];
  reg [7:0]   smapMem [256];
  reg [7:0]   expRdData, actRdData;
  event       vdoReq, smapReq;

  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    mbxOpMon2ScbFifo  = new("mbxOpMon2ScbFifo",this);
    mbxIpMon2ScbFifo  = new("mbxIpMon2ScbFifo",this);
  endfunction
  
  task configure_phase (uvm_phase phase);
    super.configure_phase(phase);
    //initialize all memories inside the DUT model
    $display("*************Initializing memories**********************");
    for (int i=0; i< 256; i=i+1)
    begin
      mem[i]      = 8'h0;
      vdoMem[i]   = 8'h0;
      smapMem[i]  = 8'h0;
    end
  endtask
  
  //Below task needs to be mandatory main_phase. Can NOT be run_phase.
  //run_phase will start in parallel with configure_phase. so, if a pkt is
  //received before config_phase is complete, it will be received and checked
  //while the contents of the memory will be 'x'.
  task main_phase(uvm_phase phase);
    fork
      //Read from output monitor
      forever
      begin
        mbxOpMon2ScbFifo.get(dutOpPkt);
        //Below is better than dutOpPkt.print(), as it can be controlled with severity
        //as well as it will print the component from where the print occurs. The 2nd 
        //argument is a string. So, sprint function is used. sprint is a method in uvm_object,
        //functions same as print(), but instead of displaying in stdout, it returns a string.
        `uvm_info(get_name(),dutOpPkt.sprint(),UVM_MEDIUM)
         pktDecode(dutOpPkt);
      end
      
      //Read from input monitor
      forever
      begin
        mbxIpMon2ScbFifo.get(dutIpPkt);
        `uvm_info(get_name(),dutIpPkt.sprint(),UVM_MEDIUM)
         pktDecode(dutIpPkt);
      end
    join      
  endtask
  
  task pktDecode(myPkt pkt);
    case (pkt.mode)
      3'b000 : mem[pkt.addr]      = pkt.data[0];
      3'b001 : expRdData          = mem[pkt.addr];
      3'b010 : begin actRdData          = pkt.data[0]; chkRdData(); end
      3'b011 : -> vdoReq;
      3'b100 : vdoMem[pkt.addr]   = pkt.data[0];
      3'b101 : -> smapReq;
      3'b110 : smapMem[pkt.addr]  = pkt.data[0];
    endcase
  endtask
  
  task chkRdData();
    if (expRdData !== actRdData)
    begin
      `uvm_error (get_name(),"Read Data Mismatch")
      $display("Expected Rd Data = %0h; Actual Rd Data = %0h", expRdData, actRdData);
    end
  endtask
  
endclass