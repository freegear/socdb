// --=========================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 1999 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
// -----------------------------------------------------------------------------
//
//  Version and Release Control Information:
//
//  File Name              : decoder1.v,v
//  File Revision          : 1.3
//
//  Release Information    : PrimeCell(TM)-PL170-REL2v2
//
// -----------------------------------------------------------------------------
//
// Purpose   : This module generates select signals HSELx for the slaves.  
//
// -----------------------------------------------------------------------------

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module decoder1 (
                HADDR,
                HSEL,
                DefSlaveSel,
               );
input [31:0]   HADDR;  
// AHB Address Bus

output [15:0]  HSEL; 
//Slave Select Signal

output         DefSlaveSel;
// Default Slave select Signal
// -----------------------------------------------------------------------------
//
//                             decoder 
//                             ========
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//
// This module decodes the address and generates the HSELx signals.
// This module generates the select signals for max. of 16 slaves.
// Note : The low address range and high address range of the slaves 
// being tested has to be defined by the user.
// For example, SLAVE0LOWADDRRANGE and SLAVE0HIGHADDRANGE maps to the
// memory space of SLAVE 0 and has to be defined, if it is being tested.
// For all the other slaves, which are dummy slaves, their LOWADDRRANGE
// has to be defined with OxFFFFFFFF and HIGHADDRANGE with 0x00000000 so
// that default slave will be selected when HADDR goes to unmapped region.
// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------
`define SLAVE1LOWADDRRANGE   32'h00000000 
// Slave 1 Base Low address range

`define SLAVE2LOWADDRRANGE    32'hA0000000
// Slave 2 Base Low address range

`define SLAVE3LOWADDRRANGE  32'hC0000000
// Slave 3 Base Low address range

`define SLAVE4LOWADDRRANGE  32'hFFFFFFFF
// Slave 4 Base Low address range

`define SLAVE5LOWADDRRANGE  32'hFFFFFFFF
// Slave 5 Base Low address range

`define SLAVE6LOWADDRRANGE  32'hFFFFFFFF
// Slave 6 Base Low address range

`define SLAVE7LOWADDRRANGE  32'hFFFFFFFF
// Slave 7 Base Low address range

`define SLAVE8LOWADDRRANGE  32'hFFFFFFFF
// Slave 8 Base Low address range

`define SLAVE9LOWADDRRANGE  32'hFFFFFFFF
// Slave 9 Base Low address range

`define SLAVE10LOWADDRRANGE 32'hFFFFFFFF
// Slave 10 Base Low address range

`define SLAVE11LOWADDRRANGE 32'hFFFFFFFF
// Slave 11 Base Low address range

`define SLAVE12LOWADDRRANGE 32'hFFFFFFFF
// Slave 12 Base Low address range

`define SLAVE13LOWADDRRANGE 32'hFFFFFFFF
// Slave 13 Base Low address range

`define SLAVE14LOWADDRRANGE 32'hFFFFFFFF
// Slave 14 Base Low address range

`define SLAVE15LOWADDRRANGE 32'hFFFFFFFF
// Slave 15 Base Low address range

`define SLAVE16LOWADDRRANGE 32'hFFFFFFFF
// The lower order bits upto which the Base address offset differs
 
`define SLAVE1HIGHADDRANGE    32'h0FFFFFFF  
// Slave 1  High Address Range
 
`define SLAVE2HIGHADDRANGE    32'hBFFFFFFF 
// Slave 2  High Address Range
 
`define SLAVE3HIGHADDRANGE    32'hDFFFFFFF 
// Slave 3  High Address Range

`define SLAVE4HIGHADDRANGE    32'h00000000 
// Slave 4  High Address Range

`define SLAVE5HIGHADDRANGE   32'h00000000 
// Slave 5  High Address Range


`define SLAVE6HIGHADDRANGE  32'h00000000 
// Slave 6  High Address Range


`define SLAVE7HIGHADDRANGE   32'h00000000 
// Slave 7  High Address Range

`define SLAVE8HIGHADDRANGE  32'h00000000 
// Slave 8  High Address Range

`define SLAVE9HIGHADDRANGE 32'h00000000 
// Slave 9  High Address Range


`define SLAVE10HIGHADDRANGE 32'h00000000
// Slave 10  High Address Range


`define SLAVE11HIGHADDRANGE  32'h00000000
// Slave 11  High Address Range


`define SLAVE12HIGHADDRANGE  32'h00000000
// Slave 12  High Address Range


`define SLAVE13HIGHADDRANGE 32'h00000000
// Slave 13  High Address Range


`define SLAVE14HIGHADDRANGE   32'h00000000
// Slave 14  High Address Range


`define SLAVE15HIGHADDRANGE  32'h00000000
// Slave 15  High Address Range


`define SLAVE16HIGHADDRANGE 32'h00000000
// Slave 16  High Address Range


// -----------------------------------------------------------------------------
// Signal declarations
// -----------------------------------------------------------------------------
wire [15:0] HSEL;
// Internal Select signals of all slaves

wire DefSlaveSel;
// Internal default Slave Select signal 

reg [15:0] SlaveSel;
// Slave Select signal

// -----------------------------------------------------------------------------
// Main body of code
// =================
// -----------------------------------------------------------------------------
// Generation of HSELx signals 
// ----------------------------------------------------------------------------
assign HSEL[0] = (HADDR >=`SLAVE1LOWADDRRANGE & HADDR <= `SLAVE1HIGHADDRANGE) ? 
                                                                  1'b1 : 1'b0; 

assign HSEL[1] = (HADDR >=`SLAVE2LOWADDRRANGE & HADDR <= `SLAVE2HIGHADDRANGE) ? 
                                                                  1'b1 : 1'b0; 

assign HSEL[2] = (HADDR >=`SLAVE3LOWADDRRANGE & HADDR <= `SLAVE3HIGHADDRANGE) ? 
                                                                  1'b1 : 1'b0; 

assign HSEL[3] = (HADDR >=`SLAVE4LOWADDRRANGE & HADDR <= `SLAVE4HIGHADDRANGE) ? 
                                                                  1'b1 : 1'b0; 

assign HSEL[4] = (HADDR >=`SLAVE5LOWADDRRANGE & HADDR <= `SLAVE5HIGHADDRANGE) ? 
                                                                  1'b1 : 1'b0; 

assign HSEL[5] = (HADDR >=`SLAVE6LOWADDRRANGE & HADDR <= `SLAVE6HIGHADDRANGE) ? 
                                                                  1'b1 : 1'b0; 

assign HSEL[6] = (HADDR >=`SLAVE7LOWADDRRANGE & HADDR <= `SLAVE7HIGHADDRANGE) ? 
                                                                  1'b1 : 1'b0; 

assign HSEL[7] = (HADDR >=`SLAVE8LOWADDRRANGE & HADDR <= `SLAVE8HIGHADDRANGE) ? 
                                                                  1'b1 : 1'b0; 

assign HSEL[8] = (HADDR >=`SLAVE9LOWADDRRANGE & HADDR <= `SLAVE9HIGHADDRANGE) ? 
                                                                  1'b1 : 1'b0; 

assign HSEL[9] = (HADDR >=`SLAVE10LOWADDRRANGE & 
                  HADDR <= `SLAVE10HIGHADDRANGE) ? 1'b1 : 1'b0;

assign HSEL[10] = (HADDR >=`SLAVE11LOWADDRRANGE & 
                  HADDR <= `SLAVE11HIGHADDRANGE) ? 1'b1 : 1'b0;

assign HSEL[11] = (HADDR >=`SLAVE12LOWADDRRANGE & 
                  HADDR <= `SLAVE12HIGHADDRANGE) ? 1'b1 : 1'b0;

assign HSEL[12] = (HADDR >=`SLAVE13LOWADDRRANGE & 
                  HADDR  <= `SLAVE13HIGHADDRANGE) ? 1'b1 : 1'b0;

assign HSEL[13] = (HADDR >=`SLAVE14LOWADDRRANGE & 
                  HADDR  <= `SLAVE14HIGHADDRANGE) ? 1'b1 : 1'b0;

assign HSEL[14] = (HADDR >=`SLAVE15LOWADDRRANGE & 
                  HADDR  <= `SLAVE15HIGHADDRANGE) ? 1'b1 : 1'b0;

assign HSEL[15] = (HADDR >=`SLAVE16LOWADDRRANGE & 
                  HADDR  <= `SLAVE16HIGHADDRANGE) ? 1'b1 : 1'b0; 

// ----------------------------------------------------------------------------
// Default Slave's HSEL generation
// If any of the slaves are not selected then defaultslave is selected
// ----------------------------------------------------------------------------
assign DefSlaveSel = ((HSEL[1]|| HSEL[2]|| HSEL[3]|| HSEL[4]||
                      HSEL[5]|| HSEL[6]|| HSEL[7]|| HSEL[8]||
                      HSEL[9]|| HSEL[10]|| HSEL[11]|| HSEL[12]||
                      HSEL[13]|| HSEL[14]|| HSEL[15]||
                      HSEL[0]) != 1'b1) ? 1'b1 : 1'b0;
 
endmodule
 
// ================================ END ==================================== --


