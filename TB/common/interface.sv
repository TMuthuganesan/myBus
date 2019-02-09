`timescale 1ns/1ps
interface dutIntf (input logic clk);
  logic         rst;
  logic   [2:0] mode;
  logic   [7:0] addr;
  logic   [7:0] data;
  logic         sel;
  
  clocking ipCb @ (negedge clk);
    default input #1 output #0;
    input mode, addr, data, sel;
  endclocking
  
  clocking opCb @ (negedge clk);
    default input #1 output #0;
    output mode, addr, data, sel;
  endclocking
  
  //modport drvMp (output rst, clocking opCb);
  //modport monMp (input rst, clocking ipCb);
  modport drvMp (input clk, output rst,mode, addr, data, sel);
  modport monMp (input clk, rst, mode, addr, data, sel );
endinterface