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
//  Last Update   : 19-July-2004
//
//  Version       : 1.0.2V
//----------------------------------------------------------------------
`timescale 1 ns / 1 ps
module ahbslaveram_model (hclk,hresetn,shsel,shwrite,shreadyin,shtrans,shsize,shburst,shaddr,shwdata,shrdata,shreadyout,shresp);
   parameter ADDR_WIDTH = 9;
   `include "ahb_params.v"
   //--------------------------------------------
   // input ports
   //--------------------------------------------
   input hclk;                      // AHB clock
   input hresetn;                   // AHB reset - active low
   input shsel;                     //
   input shwrite;                   // AHB operation is write
   input shreadyin;                 //
   input[1:0] shtrans;              // AHB transfer type
   input[2:0] shsize;               // AHB transfer size
   input[2:0] shburst;              // AHB  burst type
   input[31:0] shaddr;              // AHB address
   input[31:0] shwdata;             //
   //--------------------------------------------
   // output ports
   //--------------------------------------------
   // AHB ports
   output[31:0] shrdata;
   wire[31:0] shrdata;
   output shreadyout;                   // AHB slave ready 
   wire shreadyout;
   output[1:0] shresp;               // AHB slave response (00 = OKAY, 01 = ERROR, 10 = RETRY, 11 = SPLIT)
   wire [1:0] shresp;
   //--------------------------------------------
   // internal registers and wires
   //--------------------------------------------
   //
   reg shsel_r ; 
   reg shwrite_r ; 
   reg[2:0]  shsize_r  ; 
   reg[2:0]  shburst_r ; 
   reg[1:0]  shtrans_r ;
   reg[31:0] shaddr_r  ; 

   wire lsel;
   wire lwe;
   wire lrd;
   reg[3:0] beni;
   wire[3:0] lben;
   
   wire[5:0] ramaddr;
   wire[3:0] ramwe;
   reg [7:0] ramblk_0 [(1<<ADDR_WIDTH)-1:0]; // 1kB RAM block
   reg [7:0] ramblk_1 [(1<<ADDR_WIDTH)-1:0]; // 1kB RAM block
   reg [7:0] ramblk_2 [(1<<ADDR_WIDTH)-1:0]; // 64-bytes RAM block
   reg [7:0] ramblk_3 [(1<<ADDR_WIDTH)-1:0]; // 64-bytes RAM block
//-----------------------------------------------------------------------------
   
//-----------------------------------------------------------------------------
   //
   // input signal registers
   //
   always @(posedge hclk or negedge hresetn)
   begin
      if (!hresetn)
      begin
         shsel_r   <= 1'b0 ; 
         shwrite_r <= 1'b0 ; 
         shsize_r  <= {3{1'b0}} ; 
         shburst_r <= {3{1'b0}} ; 
         shtrans_r <= HTRANS_IDLE ;
         shaddr_r <= {32{1'b0}}; 
      end
      else
      begin
         if (shreadyin)
         begin
            shsel_r   <= shsel; 
            shwrite_r <= shwrite ; 
            shsize_r  <= shsize ; 
            shburst_r <= shburst ; 
            shtrans_r <= shtrans ; 
            shaddr_r  <= shaddr ; 
         end 
      end 
   end 
   //                
   // transaction byte enable encoding
   //                          
   always @ (shaddr_r or shsize_r)
   begin : HSizeReg
      case (shsize_r)
         HSIZE_1B : if (shaddr_r[1] == 1'b0)
                       if (shaddr_r[0] == 1'b0)
                          beni <= 4'b1110;
                       else
                          beni <= 4'b1101;
                    else
                       if (shaddr_r[0] == 1'b0)
                          beni <= 4'b1011;
                       else
                          beni <= 4'b0111;
                          
         HSIZE_2B : if (shaddr_r[1:0] == 2'b00)
                       beni <= 4'b1100;
                    else
                       beni <= 4'b0011;
                       
         default  : beni <= 4'b0000;
      endcase   
   end  
   // AHB outputs assignmet 
   assign shreadyout = 1'b1;
   assign shresp = HRESP_OKAY;
   // local control signals
   assign lben = beni;
   assign lsel = shsel_r;
   assign lwe = shsel_r & (shwrite_r) & ((shtrans_r == HTRANS_NONSEQ)||(shtrans_r == HTRANS_NONSEQ));
   assign lrd = shsel_r & (!shwrite_r)& ((shtrans_r == HTRANS_NONSEQ)||(shtrans_r == HTRANS_NONSEQ)); 
   //---------------------------------------
   // RAM Block
   //---------------------------------------
   assign ramaddr = shaddr_r[ADDR_WIDTH+1:2]; 
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
   end 
   //
   assign shrdata[7:0]   = ramblk_0[ramaddr];
   assign shrdata[15:8]  = ramblk_1[ramaddr];
   assign shrdata[23:16] = ramblk_2[ramaddr];
   assign shrdata[31:24] = ramblk_3[ramaddr];
endmodule
