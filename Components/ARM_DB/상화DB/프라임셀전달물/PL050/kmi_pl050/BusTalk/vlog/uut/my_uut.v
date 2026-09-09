// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 1998 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
// 
// -----------------------------------------------------------------------------
// Version and Release Control Information:
// 
// File Name           : my_uut.v,v 
// File Revision       : 1.1 
// 
// Release Information : PL050-REL1v1 
// 
// -----------------------------------------------------------------------------
// Purpose             : Dummy APB Slave entity
// --=========================================================================--

`timescale 1ns/1ps

module my_uut (
// Inputs
        BnRES,

        PWRITE,
        PSEL,
        PENABLE,
        PADDR,

        PWDATA,

        Input00,
        Input01,
        Input1,

// Outputs
        PRDATA,

        Output20,
        Output21,
        Output3
        );


// Inputs
input           BnRES;

input           PWRITE;
input           PSEL;
input           PENABLE;
input   [7:0]   PADDR;

input           Input00;
input           Input01;
input   [3:0]   Input1;

input  [31:0]   PWDATA;

// Outputs
output [31:0]   PRDATA;
output          Output20;
output          Output21;
output  [7:0]   Output3;

endmodule

// --================================= End ===================================--
