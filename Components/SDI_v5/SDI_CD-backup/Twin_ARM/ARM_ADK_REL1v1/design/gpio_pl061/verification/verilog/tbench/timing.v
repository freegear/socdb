// --=================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2000 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
// 
// ---------------------------------------------------------------------
// Version and Release Control Information:
// 
// File Name           : timing.v.rca 
// File Revision       : 1.1 
// 
// Release Information : PrimeCell(TM)-PL061-REL1v0 
// 
// ---------------------------------------------------------------------
// Purpose : Timing parameter definitions
//
// --=================================================================--

// Clock frequency

  `define  Tclkl    10
  `define  Tclkh    10

// Define the initial delay of the first clock edge

// The clock line will remain low at the start of
// simulation. The first rising edge of clock will
// occur Tclks after simulation start. This parameter
// can be varied to eliminate false violations at the
// start of simulations during netlist simulations.

   `define Tclks    10

// APB Slave Output Timing Parameters

  `define Tovpdr    (0.2 * (`Tclkl + `Tclkh))
  `define Tohpdr     0
  
// APB Slave Input Timing Parameters

  `define Tisnres    2
  `define Tihnres    2
  `define reset_del  2
    
// The input setup time for the APB bus signals is set at 40% of the 
// time period of the bus clock. The setup times are measured from the 
// following rising edge of clock.
// Since the APB testbench takes the falling edge of clock as reference,
// the times have been adjusted by subtracting the low phase time of 
// the clock.

  `define Tispen     -2
  `define Tihpen     0
  `define Tispsel    -2
  `define Tihpsel    0
  `define Tispaddr   -2
  `define Tihpaddr   0
  `define Tispw      -2
  `define Tihpw      0
  `define Tispdw     -2
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
