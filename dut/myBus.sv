`timescale 1ns/1ps
module myBus (
  //000-wrCmd, 001-rdCmd, 010-rdResp, 011-vdoReq,
  //100-vdoResp, 101-smapReq, 110-smapResp, 111-Unused
  input       [2:0] modeIp,
  input       [7:0] addrIp,
  input       [7:0] dataIp,
  input             selIp,
  input             clk,
  input             rst,
  output  reg [2:0] modeOp,
  output  reg [7:0] addrOp,
  output  reg [7:0] dataOp,
  output  reg       selOp
);

//reg [2:0]   modeOp;
//reg [7:0]   addrOp;
//reg [7:0]   dataOp;
//reg         selOp;

bit         vdoReq, smapReq,rdReq;
bit [7:0]   rdAddr;
reg [7:0]   mem     [256];
reg [7:0]   vdoMem  [256];
reg [7:0]   smapMem [256];


always @ (posedge clk)
begin
  if (rst)
  begin
    for (shortint i=0;i<256;i=i+1)
    begin
      mem[i]      <= 8'h0;
      vdoMem[i]   <= 8'h0;
      smapMem[i]  <= 8'h0;
      rdReq       <= 1'b0;
    end
  end
  else
  begin
    rdReq           <= 1'b0;
    if (selIp)
    begin
      case (modeIp)
        3'b000  : mem[addrIp]     <= dataIp;
        3'b100  : vdoMem[addrIp]  <= dataIp;
        3'b110  : smapMem[addrIp] <= dataIp;
        3'b001  : begin rdReq     <= 1'b1; rdAddr <= addrIp; end
      endcase
    end
  end
end

initial begin
  vdoReq  <= 0;
  smapReq <= 0;
end

always
begin
  #1us  vdoReq   <= 1;
  #10ns vdoReq   <= 0;
end

always
begin
  #1300ns   smapReq   <= 1;
  #10ns     smapReq   <= 0;
end

always @ (posedge clk)
begin
  if (rst)
  begin
    modeOp    <= 3'h0;
    addrOp    <= 8'h0;
    dataOp    <= 8'h0;
    selOp     <= 1'b0;
  end
  else
  begin
    selOp     <= 1'b0;
    if (vdoReq)
    begin
      modeOp    <= 3'b011;
      addrOp    <= 8'h0;
      dataOp    <= 8'h0;
      selOp     <= 1'b1;
    end
    else if (smapReq)
    begin
      modeOp    <= 3'b101;
      addrOp    <= 8'h0;
      dataOp    <= 8'h0;
      selOp     <= 1'b1;
    end
    else if (rdReq)
    begin
      modeOp    <= 3'b010;
      addrOp    <= 8'h0;
      dataOp    <= mem[rdAddr];
      selOp     <= 1'b1;
    end
  end
end

endmodule