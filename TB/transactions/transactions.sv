class cmdPkt extends myPkt;
  `uvm_object_utils(cmdPkt)
  
  constraint cmd {addr inside {[0:100],[200:256]};mode<3'd2;}
  
  function new(string name="cmdPkt");
    super.new();
    data  = new[1];
  endfunction  
endclass

class wrPkt extends cmdPkt;
  `uvm_object_utils(wrPkt)
  
  constraint wr {mode==3'b000;}
  
  function new(string name="wrPkt");
    super.new();
    data  = new[1];
  endfunction  
endclass

class rdPkt extends cmdPkt;
  `uvm_object_utils(rdPkt)
  
  constraint rd {mode==3'b001;}
  
  function new(string name="rdPkt");
    super.new();
    data  = new[1];
  endfunction  
endclass

class vdoPkt extends myPkt;
  `uvm_object_utils(vdoPkt)
  
  constraint vdo {addr<256;mode==3'b100;}
  
  function new (string name="vdoPkt");
    super.new();
    data  = new[256];
  endfunction
endclass

class smapPkt extends myPkt;
  `uvm_object_utils(smapPkt)
  
  constraint smap {addr<256;mode==3'b110;}
  
  function new (string name="smapPkt");
    super.new();
    data  = new[256];
  endfunction
endclass