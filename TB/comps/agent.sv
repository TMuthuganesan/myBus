class myAgnt extends uvm_agent;

  `uvm_component_utils (myAgnt)
  
  myBusSeqr sqncr;
  myBusDrvr drvr;
  myBusMon  opMon;
  myBusMon  ipMon;
  myBusScb  scb;
  
  virtual dutIntf.drvMp drvVif;
  virtual dutIntf.monMp opMonVif;
  virtual dutIntf.monMp ipMonVif;
  
  function new (string name = "myAgnt", uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual interface dutIntf)::get(this, "", "drvIntf", drvVif))
      `uvm_fatal(get_name(),"Driver interface is not got from the top")
      
    if (!uvm_config_db#(virtual interface dutIntf)::get(this, "", "opMonIntf", opMonVif))
      `uvm_fatal(get_name(),"Output monitor interface is not got from the top")
    
    if (!uvm_config_db#(virtual interface dutIntf)::get(this, "", "ipMonIntf", ipMonVif))
      `uvm_fatal(get_name(),"Input monitor interface is not got from the top")
      
    this.sqncr        = myBusSeqr::type_id::create("sqncr",this);
    this.drvr         = myBusDrvr::type_id::create("drvr",this);
    this.opMon        = myBusMon::type_id::create("opMon",this);
    this.ipMon        = myBusMon::type_id::create("ipMon",this);
    this.scb          = myBusScb::type_id::create("scb",this);
    this.drvr.myVif   = drvVif;
    this.opMon.myVif  = opMonVif;
    this.ipMon.myVif  = ipMonVif;
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    this.drvr.seq_item_port.connect (this.sqncr.seq_item_export);
    this.opMon.mbxMon2Scb.connect (this.scb.mbxOpMon2ScbFifo.analysis_export);
    this.ipMon.mbxMon2Scb.connect (this.scb.mbxIpMon2ScbFifo.analysis_export);
  endfunction
endclass