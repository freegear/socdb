// ****** (C) Copyright 1998 Avant! Inc. ********
//  --    AVANT! Verilog Models
// **********************************************


`celldefine
`delay_mode_path
`suppress_faults
`enable_portfaults
`timescale 1 ns / 1ps

// Model type   	: zero timing
// Filename     	: bh01d1.v
// Description  	:  REPEATER CELL
// Library      	: cb18os120
// Programmer   	: yzhu
// Date                 : 14-Mar-2001
// Product version	: Rev. main.1 
// Master version	: Rev. main.3
//
//


module bh01d1 (I);

   inout I;

   buf (weak0, weak1) (I,I);


`ifdef NOTIMING
`else
   specify
      specparam InCap$I=0.000,
                CellFunction$="REPEATER",
                ModelType$=1.0,
                cell_count=0.000000,
                Transistors=6,
                Power=0.000000;

   endspecify
`endif

endmodule

`nosuppress_faults
`disable_portfaults
`endcelldefine
