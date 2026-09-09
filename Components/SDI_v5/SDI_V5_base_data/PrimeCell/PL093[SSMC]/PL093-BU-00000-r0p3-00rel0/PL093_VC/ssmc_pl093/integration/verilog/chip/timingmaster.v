// --=================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2003 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// ---------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : timingmaster.v.rca
// File Revision          : 1.2
//
// Release Information    : PrimeCell(TM)-PL093-r0p3-00rel0
//
// ---------------------------------------------------------------------
// Purpose :
//           To define the AHB_Master testbench timing-parameters
//
// --=================================================================--

// ---------------------------------------------------------------------
// Note:
// -----
// Values are set as a percentage of `Tclk. If the value of `Tclk is
// changed, then other timing parameters will be assigned new values
// accordingly. The timing parameter values may have to be modified
// based on timing requirements of the master.
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Constant declarations
// ---------------------------------------------------------------------
 
`timescale 1ns/1ps

`define Tisgnt (0.1 * `Tclk)
// grant setup time before HCLK
 
`define Tihgnt (0.05 * `Tclk)
// grant hold time after HCLK
 
`define Tisrd  (0.1 * `Tclk)
// read data setup time before HCLK
 
`define Tihrd  (0.05 * `Tclk)
// read data hold time after HCLK
 
`define Tovtr  (0.95 * `Tclk)
// transfer type valid time after HCLK
 
`define Tohtr  (0.00 * `Tclk)
// transfer-type hold time after HCLK
 
`define Tova   (0.95 * `Tclk)
// address valid time after HCLK
 
`define Toha   (0.00 * `Tclk)
// address hold time after HCLK
 
`define Tovctl (0.95 * `Tclk)
// control valid time after HCLK
 
`define Tohctl (0.00 * `Tclk)
// control hold time after HCLK
 
`define Tovwd  (0.95 * `Tclk)
// write-data valid time after HCLK
 
`define Tohwd  (0.00 * `Tclk)
// write-data hold time after HCLK
 
`define Tovreq (0.95 * `Tclk)
// request valid time after HCLK
 
`define Tohreq (0.00 * `Tclk)
// request hold time after HCLK
 
`define Tovlck (0.95 * `Tclk)
// lock valid time after HCLK
 
`define Tohlck (0.00 * `Tclk)
// lock hold time after HCLK

// Propagation delay for writeable virtual registers. Single delay
// value for the each register.
 
  `define vrg0_del    5
  `define vrg1_del    5
  `define vrg2_del    5
  `define vrg3_del    5
  `define vrg4_del    5
  `define vrg5_del    5
  `define vrg6_del    5
  `define vrg7_del    5

// --============================= End ===============================--
