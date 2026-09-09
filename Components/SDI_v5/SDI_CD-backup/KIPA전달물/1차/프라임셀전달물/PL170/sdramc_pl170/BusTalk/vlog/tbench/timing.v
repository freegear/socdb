// --=========================================================================--
// This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    C COPYRIGHT 1999 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
// -----------------------------------------------------------------------------
//
//  Version and Release Control Information:
//
//  File Name              : timing.v,v
//  File Revision          : 1.3
//
//  Release Information    : PrimeCell(TM)-PL170-REL2v2
//
// -----------------------------------------------------------------------------
//
// Purpose   : To define the AHB_Slave testbench timing-parameters
//
// Note:
// ---- 
// Values are set in percentage of `Tclkh, if the value of tclk is changed
// then other timing parameters  will be assigned new values accordingly.
// The timing parameter values has to be modified, if the slave design needs
// different the timing parameter values.   
// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

`define Tclk         16 
`define Tclkl        (`Tclk / 2)
`define Tclkh        (`Tclk / 2)

// -----------------------------------------------------------------------------
//  AHB Output signals from the slave
// -----------------------------------------------------------------------------
`define Tovrdy       (1.0 * `Tclkh)
// Ready valid time after HCLK

`define Tohrdy       (0 * `Tclkh) 
// Ready hold time after HCLK

`define Tovrsp       (1.0 * `Tclkh)
// Respoe vaild time after HCLK 

`define Tohrsp       (0 * `Tclkh)
// Respoe hold time after HCLK

`define Tovsplt      (1.0 * `Tclkh) 
// Split valid time after HCLK

`define Tohsplt      (0 * `Tclkh)
// Split hold time after HCLK

`define Tovdr        (1.0 * `Tclkh)
// HRDATA signal valid time before HCLK
 
`define Tohdr        (0 * `Tclkh)
// HRDATA signal hold time after HCLK

// -----------------------------------------------------------------------------
//    AHB Inputs signals to the slave driven by the test bench
// -----------------------------------------------------------------------------
`define Tisrdy       (1.0 * `Tclkh) 
// ReadyIn setup time after HCLK

`define Tihrdy       (0.01 * `Tclkh)
// ReadyIn hold time after HCLK

`define Tisrst       (0.5 * `Tclkh)
// Reset setup time before HCLK

`define Tihrst       (0.01 * `Tclkh)
// Reset hold time after HCLK

`define Resetdel     (0.01 * `Tclkh) 
// reset is asserted asynchronously
// but Test bench  needs a value

`define Tisa         (1.0 * `Tclkh)
// Address setup time before HCLK

`define Tiha         (0.01 * `Tclkh)
// Address hold time after HCLK

`define Tisctl       (1.0 * `Tclkh)
// Control signal setup time before HCLK

`define Tihctl       (0.01 * `Tclkh)
// Control signal hold time after HCLK

`define Tistr        (1.0 * `Tclkh) 
// HTRANS signal setup time before HCLK
 
`define Tihtr        (0.01 * `Tclkh)
// HTRANS signal hold time after HCLK

`define Tihmst       (0.01 * `Tclkh)
// Master Number hold time after HCLK

`define Tihmlck      (0.01 * `Tclkh)
// Master Locked hold time after HCLK

`define Tismst       (1.0 * `Tclkh)
// Master Number setup time before HCLK

`define Tismlck      (1.0 * `Tclkh)
// Master Locked setup time before HCLK

`define Tiswd        (1.0 * `Tclkh)
// Write data setup time before HCLK

`define Tihwd        (0.01 * `Tclkh)
// Write data hold time after HCLK

// Propagation delay for writeable virtual registers.  Single delay value
// for the each register.
 
  `define vrg0_del    5
  `define vrg1_del    5
  `define vrg2_del    5
  `define vrg3_del    5
  `define vrg4_del    5
  `define vrg5_del    5
  `define vrg6_del    5
  `define vrg7_del    5
 

// ================================== End =================================== --
