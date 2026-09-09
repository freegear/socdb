// ****** (C) Copyright 1998 Avant! Inc. ********
//  --    AVANT! Verilog Models
// **********************************************


//           Cell Name: adiode ;   Cell Type: EXP 
//           cell title ADIODE 

`celldefine
`delay_mode_path
`suppress_faults
`enable_portfaults
`timescale 1 ns / 1ps

// Model type   	: zero timing
// Filename     	: adiode.v
// Description  	:  ANTENNA PROTECTION DIODE
// Library      	: cb18os120
// Programmer   	: yzhu
// Date                 : 14-Mar-2001
// Product version	: Rev. main.1 
// Master version	: Rev. main.4
//
//


module adiode (I);

   input I;
   buf    E0(DeadEnd, I);

`ifdef NOTIMING
`else
   specify
      specparam InCap$I       = 0.000,
                cell_count    = 0.000000,
                Transistors   = 0,
                Power	      = 0.000000;

   endspecify
`endif

endmodule

`nosuppress_faults
`disable_portfaults
`endcelldefine
