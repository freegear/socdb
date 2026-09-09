// --=================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2000-2001 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// ---------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : timing.v.rca
// File Revision          : 1.8
//
// Release Information    : PrimeCell(TM)-PL092-REL1v1
//
// ---------------------------------------------------------------------
// Purpose :
//           Define the AHB_Slave testbench timing-parameters
//
// --=================================================================--

// ---------------------------------------------------------------------
// Note:
// ----- 
// Values are set as a percentage of `Tclk. If the value of `Tclk is
// changed, then other timing parameters will be assigned new values
// accordingly. The timing parameter values may have to be modified
// based on timing requirements of the slave.
// ---------------------------------------------------------------------

`timescale 1ns/1ps

// ---------------------------------------------------------------------
// Constant declarations
// ---------------------------------------------------------------------

// Define the low phase of clock
// errsmc
// `define Tclkl        5.0
`define Tclkl        (526/100)

// Define the high phase of clock
// errsmc
// `define Tclkh        5.0
`define Tclkh        (526/100)

// Define the period of clock
`define Tclk         (`Tclkl + `Tclkh)

// Define the initial delay of the first clock edge
 
// The clock line will remain low at the start of
// simulation. The first rising edge of clock will
// occur Tclks after simulation start. This parameter
// can be varied to eliminate false violations at the
// start of simulations during netlist simulations.
 
`define Tclks        (1052/100)

// ---------------------------------------------------------------------
//  AHB Output signals from the slave
// ---------------------------------------------------------------------
`define Tovrdy       (0.4 * `Tclk)
// Ready valid time after HCLK

`define Tohrdy       (0.0 * `Tclk) 
// Ready hold time after HCLK

`define Tovrsp       (0.4 * `Tclk)
// Respoe vaild time after HCLK 

`define Tohrsp       (0.0 * `Tclk)
// Respoe hold time after HCLK

`define Tovsplt      (0.4 * `Tclk) 
// Split valid time after HCLK

`define Tohsplt      (0.0 * `Tclk)
// Split hold time after HCLK

`define Tovdr        (0.4 * `Tclk)
// HRDATA signal valid time before HCLK
 
`define Tohdr        (0.0 * `Tclk)
// HRDATA signal hold time afetr HCLK

// ---------------------------------------------------------------------
//    AHB Inputs signals to the slave driven by the test bench
// ---------------------------------------------------------------------
`define Tisrdy       (0.3 * `Tclk) 
// ReadyIn setup time after HCLK

`define Tihrdy       (0.01 * `Tclk)
// ReadyIn hold time after HCLK

`define Tisrst       (0.5 * `Tclk)
// Reset setup time before HCLK

`define Tihrst       (0.2 * `Tclk)
// Reset hold time afetr HCLK

`define Resetdel     (0.01 * `Tclk) 
// reset is asserted asynchronously
// but Test bench  needs a value

`define Tisa         (0.3 * `Tclk)
// Address setup time before HCLK

`define Tiha         (0.01 * `Tclk)
// Address hold time afetr HCLK

`define Tisctl       (0.3 * `Tclk)
// Control signal setup time before HCLK

`define Tihctl       (0.01 * `Tclk)
// Control signal hold time afetr HCLK

`define Tistr        (0.3 * `Tclk) 
// HTRANS signal setup time before HCLK
 
`define Tihtr        (0.01 * `Tclk)
// HTRANS signal hold time afetr HCLK

`define Tismst       (0.5 * `Tclk)
// HMASTER setup time before HCLK rising edge

`define Tihmst       (0.01 * `Tclk)
// Master Number hold time afetr HCLK

`define Tihmlck      (0.01 * `Tclk)
// Master Locked hold time afetr HCLK

`define Tismlck      (0.5 * `Tclk)
// Master Locked setup time before HCLK

`define Tiswd        (0.3 * `Tclk)
// Wirte data setup time before HCLK

`define Tihwd        (0.01 * `Tclk)
// Wirte data hold time afetr HCLK

// Propagation delay for writeable virtual registers.  Single delay
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
