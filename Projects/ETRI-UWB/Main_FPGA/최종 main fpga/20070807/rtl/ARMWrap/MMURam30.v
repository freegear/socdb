//----------------------------------------------------------------------------
//     The confidential and proprietary information contained in this file may
//     only be used by a person authorised under and to the extent permitted
//     by a subsisting licensing agreement from ARM Limited.
//
//            (C) COPYRIGHT 2003 ARM Limited.
//                ALL RIGHTS RESERVED
//
//     This entire notice must be reproduced on all copies of this file
//     and copies of this file may only be made by a person if such person is
//     permitted to do so under the terms of a subsisting license agreement
//     from ARM Limited.
//
// Checked In : 2001/10/23 07:50:18
// Version    : a926ejsRAM.v,v 1.3 2001/10/23 07:50:18 gcampbel ARM926EJS_r0p5-00rel0
// Release Information : ARM926EJS_r0p5-00rel0 
//
//----------------------------------------------------------------------------
// Generic RAM model : 30 bits data, 5 bits address
// WE and OE are never enabled in the same time. It is then possible to use
// a common bus for DataOut and DataIn. When CS is disables, it does not matter
// what is on the output.
//----------------------------------------------------------------------------

`timescale 1 ns / 1 ps

module MMURam30 (
  DATAOUT,
  CLK, DATAIN, ADDR, WE, CS, OE
);

  parameter DW = 30;

  output [DW-1:0] DATAOUT;  // Output data bus
  input           CLK;      // Clock
  input  [DW-1:0] DATAIN;   // Input data bus
  input     [4:0] ADDR;     // Address bus
  input           WE;       // Write enable line
  input           CS;       // Chip select
  input           OE;       // Output enable
  
  reg    [DW-1:0] DATAOUT;
  reg    [DW-1:0] ram[31:0];

   // remove a unkown output.
   
  always @ (posedge(CLK))
  begin
    DATAOUT <= #1 ram[ADDR];
    if (CS==1'b1 && WE==1'b1)
      ram[ADDR] <= #1 DATAIN;
  end

endmodule
