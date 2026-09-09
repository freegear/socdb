//----------------------------------------------------------------------
//
// Copyright (c) 2002-2003 CAST, Inc.
//
// Please review the terms of the license agreement before using this
// file.  If you are not an authorized user, please destroy this source
// code file and notify CAST immediately that you inadvertently received
// an unauthorized copy.
//----------------------------------------------------------------------
//
//  Project       : PCI Core
//
//  File          : ahbslaveram_model.v
//
//  Dependencies  : 
//
//  Model Type:   : simulation model
//
//  Description   : AMBA 32-bit AHB bus slave RAM model  
//
//  Designer      : AS
//
//  QA Engineer   : 
//
//  Creation Date : 17-September-2003
//
//  Last Update   : 20-November-2003
//
//  Version       : 1.0
//----------------------------------------------------------------------
module ahbslaveram_model (hclk,hresetn,shsel,shwrite,shtrans,shsize,shburst,shaddr,shwdata,shrdata,shready,shresp);
   //--------------------------------------------
   // input ports
   //--------------------------------------------
   input hclk;                      // AHB clock
   input hresetn;                   // AHB reset - active low
   input shsel;
   input shwrite;                  // AHB operation is write
   input[1:0] shtrans;             // AHB transfer type
   input[2:0] shsize;              // AHB transfer size
   input[2:0] shburst;             // AHB  burst type
   input[31:0] shaddr; // AHB address
   input[31:0] shwdata;
   //--------------------------------------------
   // output ports
   //--------------------------------------------
   // AHB ports
   output[31:0] shrdata;
   wire[31:0] shrdata;
   output shready;                   // AHB slave ready 
   wire shready;
   output[1:0] shresp;               // AHB slave response (00 = OKAY, 01 = ERROR, 10 = RETRY, 11 = SPLIT)
   wire [1:0] shresp;
   //--------------------------------------------
   // internal registers and wires
   //--------------------------------------------
   //
   wire ldrdy;                     // data ready
   wire lerr;                      // internal error - unable to complete transfer
   wire lretry;                    // internal subsytem requests retry 
   wire lsel;
   wire lwe;
   wire lrd;
   wire[3:0] lben;
   wire[31:0] laddr;
   wire[5:0] ramaddr;
   wire[3:0] ramwe;
   reg [5:0] rd_addr;
   reg [7:0] ramblk_0 [63:0]; // 64-bytes RAM block
   reg [7:0] ramblk_1 [63:0]; // 64-bytes RAM block
   reg [7:0] ramblk_2 [63:0]; // 64-bytes RAM block
   reg [7:0] ramblk_3 [63:0]; // 64-bytes RAM block
   //
   assign lerr   = 1'b0;
   assign lretry = 1'b0;
   assign ldrdy  = lsel;
   //
   // RAM Block
   // 
   assign ramaddr = laddr[7:2]; 
   assign ramwe[0] = lsel && lwe && (~lben[0]);
   assign ramwe[1] = lsel && lwe && (~lben[1]);
   assign ramwe[2] = lsel && lwe && (~lben[2]);
   assign ramwe[3] = lsel && lwe && (~lben[3]);
   //
   always @(posedge hclk) begin
      if (ramwe[0])
         ramblk_0[ramaddr] <= shwdata[7:0];
      if (ramwe[1])
         ramblk_1[ramaddr] <= shwdata[15:8];
      if (ramwe[2])
         ramblk_2[ramaddr] <= shwdata[23:16];
      if (ramwe[3])
         ramblk_3[ramaddr] <= shwdata[31:24];
      rd_addr <= ramaddr;
   end 
   //
   assign shrdata[7:0]   = ramblk_0[rd_addr];
   assign shrdata[15:8]  = ramblk_1[rd_addr];
   assign shrdata[23:16] = ramblk_2[rd_addr];
   assign shrdata[31:24] = ramblk_3[rd_addr];
   //
   //
   //
   ahbslave USLAVEIF(
      .hclk(hclk),
      .hresetn(hresetn),
      .shsel(shsel),
      .shwrite(shwrite),
      .shtrans(shtrans),
      .shsize(shsize),
      .shburst(shburst),
      .shaddr(shaddr),
      .ldrdy(ldrdy),
      .lerr(lerr),
      .lretry(lretry),
      .shready(shready),
      .shresp(shresp),
      .lsel(lsel),
      .lwe(lwe),
      .lrd(lrd),
      .lben(lben),
      .laddr(laddr)
      );
endmodule