//  --========================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 2001 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//  
//  ----------------------------------------------------------------------------
//  Version and Release Control Information:
//  
//  File Name           : TimersPackage.v,v
//  File Revision       : 1.3
//  
//  Release Information : ADK_REL1v1
//  
//  ----------------------------------------------------------------------------
//  Purpose             : The constants used in the Timers system are defined in
//                      : this block.
//  --========================================================================--

//------------------------------------------------------------------------------
// Timer register addresses
//------------------------------------------------------------------------------

// Timer base address prefixes
`define TIMER1A       7'b0000000
`define TIMER2A       7'b0000001
`define TIMER3A       7'b0000010
`define TIMER4A       7'b0000011

// Integration Test register base address
`define TIMERIA       7'b1111000
// Peripheral and PrimeCell register base address
`define TIMERPA       7'b1111111

// Register addresses for use by Frcs
`define TIMERLOADA    3'b000
`define TIMERVALUEA   3'b001
`define TIMERCONTROLA 3'b010
`define TIMERCLEARA   3'b011
`define TIMERINTRAWA  3'b100
`define TIMERINTA     3'b101
`define TIMERLOADBGA  3'b110
`define TIMERTESTA    3'b111

// Integration Test registers
`define TIMERTCRA     3'b000
`define TIMERTOPA     3'b001

// Peripheral and PrimeCell ID registers
`define TPERIPHID0A   3'b000
`define TPERIPHID1A   3'b001
`define TPERIPHID2A   3'b010
`define TPERIPHID3A   3'b011
`define TPCELLID0A    3'b100
`define TPCELLID1A    3'b101
`define TPCELLID2A    3'b110
`define TPCELLID3A    3'b111

// --========================= End ===========================================--
