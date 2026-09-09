////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 1991-2001 Altera Corporation
// Any megafunction design, and related net list (encrypted or decrypted),
// support information, device programming or simulation file, and any other
// associated documentation or information provided by Altera or a partner
// under Altera's Megafunction Partnership Program may be used only to
// program PLD devices (but not masked PLD devices) from Altera.  Any other
// use of such megafunction design, net list, support information, device
// programming or simulation file, or any other related documentation or
// information is prohibited for any other purpose, including, but not
// limited to modification, reverse engineering, de-compiling, or use with
// any other silicon devices, unless such use is explicitly licensed under
// a separate agreement with Altera or a megafunction partner.  Title to
// the intellectual property, including patents, copyrights, trademarks,
// trade secrets, or maskworks, embodied in any such megafunction design,
// net list, support information, device programming or simulation file, or
// any other related documentation or information provided by Altera or a
// megafunction partner, remains with Altera, the megafunction partner, or
// their respective licensors.  No other licenses, including any licenses
// needed under any third party's intellectual property, are provided herein.
//
////////////////////////////////////////////////////////////////////////////////
/*----------------------------------------------------------------------------
  Wait state generation
----------------------------------------------------------------------------*/
`define ADD_WAIT 0
`define SUB_WAIT 0
`define MULT_WAIT 0

/*----------------------------------------------------------------------------
 AHB transfer type macros
----------------------------------------------------------------------------*/
`define IDLE 2'b00
`define BUSY 2'b01
`define NONSEQ 2'b10
`define SEQ 2'b11

/*----------------------------------------------------------------------------
 AHB burst type macros
----------------------------------------------------------------------------*/
`define SINGLE 3'b000	// Single Transfer
`define INCR 3'b001	// Unspecified incrementing
`define WRAP4 3'b010	// 4-beat wrapping
`define INCR4 3'b011	// 4-beat incrementing
`define WRAP8 3'b100	// 8-beat wrapping
`define INCR8 3'b101	// 8-beat incrementing
`define WRAP16 3'b110	// 16-beat wrapping
`define INCR16 3'b111	// 16-beat incrementing

/*----------------------------------------------------------------------------
 AHB hresp macros
----------------------------------------------------------------------------*/
`define OKAY 2'b00
`define ERROR 2'b01
`define RETRY 2'b10
`define SPLIT 2'b11

/*----------------------------------------------------------------------------
 AHB transfer size macros
----------------------------------------------------------------------------*/
`define AHB_BYTE 3'b000
`define AHB_HALF 3'b001
`define AHB_WORD 3'b010

/*----------------------------------------------------------------------------
 AHB hwrite macros
----------------------------------------------------------------------------*/
`define AHB_WRITE 1'b1
`define AHB_READ 1'b0

/*----------------------------------------------------------------------------
AHB Register File Address Map
----------------------------------------------------------------------------*/

`define OP1   32'h10000004
`define OP2   32'h10000008
`define OPER  32'h1000000C
`define RELOW 32'h10000010
`define REHIG 32'h10000014

/*----------------------------------------------------------------------------
ALU operations
----------------------------------------------------------------------------*/

`define ADD 2'b01
`define SUB 2'b10
`define MULT 2'b11
