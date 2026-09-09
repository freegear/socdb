
// Copyright (C) 1991-2000 Altera Corporation
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



`timescale 1 ns / 100 ps

module arm_top_tb ( );



//////////////////////////////////////////////////////////////////////////////////////////////
//                                  Parameter Definitions                                   //
//////////////////////////////////////////////////////////////////////////////////////////////


`define     reset_width     10
/*----------------------------------------------------------------------------
 System Clocks
 ----------------------------------------------------------------------------*/
`ifdef      clk_ref_period
`else
  `define       clk_ref_period              10
`endif
  `define       hclock_period      100

`define     log_file_name               "sim_log_file.txt"




////////////////////////////////////////////////////////////////////////////////////////////////
//                              Test-bench declarations                                       //
////////////////////////////////////////////////////////////////////////////////////////////////



reg   clk_ref;
 
tri1    nreset;     // bi-directional open-drain (ie. on-chip pull-up)

reg   npor;

reg HCLOCK;
reg HRESETn;
reg HGRANT;
reg HSEL;

/////////////////////////////////////////////////////////////////////////////
//                      Clock generation and misc processes                //
/////////////////////////////////////////////////////////////////////////////


// Drive main source clock 10 MHz
initial begin
    clk_ref = 0;
    while (1) # (`clk_ref_period) clk_ref <= ~clk_ref;
end

// Drive Stripe Master-port clock (slave clock from PLD)
initial begin
    HCLOCK = 0;
    while (1) # (`hclock_period) HCLOCK <= ~HCLOCK;
end

//////////////////////////////////////////////////////////////////////////////////////////////
//                                      Main test processes                                 //
//////////////////////////////////////////////////////////////////////////////////////////////

  
  initial begin

  
    HRESETn = 0;
    HGRANT = 1;
    HSEL = 1;

    // Toggle external resets
    # (`reset_width) HRESETn = 1;
	
	npor = 0;
        
        # (`reset_width)npor = 1;
     

    $display("\nINFO:   Reset Finished \n");
    
    $display("\nINFO:   S/W is writing to pld_slave registers  \n");
  end



arm_top

    dut

(

  // Dedicated I/O          These ports are always present
  // ------------------------------------------------------

    .clk_ref     ( clk_ref ),
    .nreset      ( nreset  ),
    .npor        ( npor    ),

  // User I/O
  // ------------------------------------------

     .HCLOCK  (HCLOCK),
     .HRESETn (HRESETn),
     .HGRANT  (HGRANT),
     .HSEL    (HSEL)
);

initial begin
# 450000;
$stop;
end

endmodule




