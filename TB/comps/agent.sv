class myAgnt extends uvm_agent;

  `uvm_component_utils (myAgnt)
  
  myBusSeqr   sqncr;
  myBusDrvr   drvr;
  myBusMon    opMon;
  myBusMon    ipMon;
  myBusScb    scb;
  myBusCovMon ipCovMon;
  
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
    this.ipCovMon     = myBusCovMon::type_id::create("ipCovMon",this);
    this.drvr.myVif   = drvVif;
    this.opMon.myVif  = opMonVif;
    this.ipMon.myVif  = ipMonVif;
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    this.drvr.seq_item_port.connect (this.sqncr.seq_item_export);
    this.opMon.mbxMon2Scb.connect (this.scb.mbxOpMon2ScbFifo.analysis_export);
    //The above cannot be connected as below. These give loading error but no compile error while running.
    //The error from questa below -
    //uvm_test_top.env.agnt.sqncr.seq_item_export [Connection Error] Cannot call an imp port's connect method.
    //An imp is connected only to the component passed in its constructor. (You attempted to bind this imp to
    //uvm_test_top.env.agnt.drvr.seq_item_port)
    //this.sqncr.seq_item_export.connect (this.drvr.seq_item_port);    
    //this.scb.mbxOpMon2ScbFifo.analysis_export.connect (this.opMon.mbxMon2Scb);
    this.ipMon.mbxMon2Scb.connect (this.scb.mbxIpMon2ScbFifo.analysis_export);
    this.ipMon.mbxMon2Scb.connect (this.ipCovMon.covMonFifo.analysis_export);
  endfunction
endclass