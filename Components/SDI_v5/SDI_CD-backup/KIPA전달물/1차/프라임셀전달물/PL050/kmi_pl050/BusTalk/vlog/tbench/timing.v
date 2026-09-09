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
// File Name           : timing.v,v 
// File Revision       : 1.1 
// 
// Release Information : PL050-REL1v1 
// 
// -----------------------------------------------------------------------------
// Purpose             : Timing parameter definitions
// --=========================================================================--

// Clock frequency

  `define  Tclkl    10
  `define  Tclkh    10

// APB Slave Output Timing Parameters

  `define Tovpdr    10
  `define Tohpdr     0
  
// APB Slave Input Timing Parameters

  `define Tisnres    2
  `define Tihnres    2
  `define reset_del  2
    
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

// --================================= End ===================================--
  
