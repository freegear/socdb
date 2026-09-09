// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 1999 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
// 
// -----------------------------------------------------------------------------
// Version and Release Control Information:
// 
// File Name           : my_uut.v,v 
// File Revision       : 1.2 
// 
// Release Information : PrimeCell(TM)-PL170-REL2v2 
// 
// -----------------------------------------------------------------------------
// Purpose             : Dummy AHB Slave entity
// --=========================================================================--

`timescale 1ns/1ps

module my_uut
               (
                HCLK,
                HRESETn,
                HADDR,
                HTRANS,
                HWRITE,
                HSIZE,
                HBURST,
                HWDATA,
                HRDATAIn,
                HREADYIn,
                HSPLITIn,
                HSEL,
                HMASTER,
                HMASTLOCK,
                HRESPIn,
                HRDATAdly,
                HREADYdly,
                HRESPdly,
                HSPLITdly
               );
 
input             HCLK;            // AHB Clock Signal
input             HRESETn;         // AHB Reset Signal
input   [31:0]    HADDR;           // AHB  Address Bus
input    [1:0]    HTRANS;          // AHB Transfer Mode
input             HWRITE;          // AHB Read/Write Signal
input    [2:0]    HSIZE;           // AHB Data Transfer Size
input    [2:0]    HBURST;          // AHB Burst type
input   [63:0]    HWDATA;          // AHB Write Data Bus
input   [63:0]    HRDATAIn;        // AHB Read Data Bus
input             HREADYIn;        // AHB HREADY signal
input   [15:0]    HSPLITIn;        // AHB Split Reply
input             HSEL;            // Slave select signal
input    [3:0]    HMASTER;         // MASTER driving the Bus
input             HMASTLOCK;       // Slave locked by Master
input    [1:0]    HRESPIn;         // Combined Response
output  [63:0]    HRDATAdly;       // AHB Read Data Bus
output            HREADYdly;       // AHB HREADY signal
output   [1:0]    HRESPdly;        // AHB response signal
output  [15:0]    HSPLITdly;       // AHB Splitx signal
// -----------------------------------------------------------------------------
endmodule

// --================================= End ===================================--
