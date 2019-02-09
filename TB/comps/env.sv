class myEnv extends uvm_env;
  myAgnt agnt;
  
  `uvm_component_utils (myEnv)
  
  function new (string name = "myEnv",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agnt = myAgnt::type_id::create("agnt",this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction
endclass