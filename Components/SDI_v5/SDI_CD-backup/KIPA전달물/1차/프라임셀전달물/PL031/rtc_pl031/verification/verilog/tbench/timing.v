// --=================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2001 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
// 
// ---------------------------------------------------------------------
// Version and Release Control Information:
// 
// File Name           : timing.v.rca
// File Revision       : 1.6
// 
// Release Information : PrimeCell(TM)-PL031-REL1v0
// 
// ---------------------------------------------------------------------
// Purpose : Timing parameter definitions
//
// --=================================================================--

// Clock frequency

  `define  Tclkl    5
  `define  Tclkh    5

// Define the initial delay of the first clock edge

// The clock line will remain low at the start of
// simulation. The first rising edge of clock will
// occur Tclks after simulation start. This parameter
// can be varied to eliminate false violations at the
// start of simulations during netlist simulations.

   `define Tclks    5

// APB Slave Output Timing Parameters

  `define Tovpdr    (0.2 * (`Tclkl + `Tclkh))
  `define Tohpdr     0
  
// APB Slave Input Timing Parameters

  `define Tisnres    1
  `define Tihnres    1
  `define reset_del  1
    
// The input setup time for the APB bus signals is set at 40% of the 
// time period of the bus clock. The setup times are measured from the 
// following rising edge of clock.
// Since the APB testbench takes the falling edge of clock as reference,
// the times have been adjusted by subtracting the low phase time of 
// the clock.

  `define Tispen     (0.4 * (`Tclkl + `Tclkh) - `Tclkl) 
  `define Tihpen     0
  `define Tispsel    (0.4 * (`Tclkl + `Tclkh) - `Tclkl)
  `define Tihpsel    0
  `define Tispaddr   (0.4 * (`Tclkl + `Tclkh) - `Tclkl)
  `define Tihpaddr   0
  `define Tispw      (0.4 * (`Tclkl + `Tclkh) - `Tclkl)
  `define Tihpw      0
  `define Tispdw     (0.4 * (`Tclkl + `Tclkh) - `Tclkl)
  `define Tihpdw     0

// Propagation delay for writeable virtual registers. Single delay value
// for the each register. 

  `define vrg0_del    5
  `define vrg1_del    5
  `define vrg2_del    5
  `define vrg3_del    5
  `define vrg4_del    5
  `define vrg5_del    5
  `define vrg6_del    5
  `define vrg7_del    5

// --============================= End ===============================--
