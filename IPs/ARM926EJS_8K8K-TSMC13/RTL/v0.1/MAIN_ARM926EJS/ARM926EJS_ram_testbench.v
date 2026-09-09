//----------------------------------------------------------------------------- 
//  This confidential and proprietary software may be used only as              
//  authorised by a licensing agreement from ARM Limited                        
//    (C) COPYRIGHT 2003 ARM Limited                                           
//        ALL RIGHTS RESERVED                                                   
//  The entire notice above must be reproduced on all authorised                
//  copies and copies may only be made to the extent permitted                  
//  by a licensing agreement from ARM Limited.                                  
//                                                                              
//      Module       : ARM926EJS_ram_testbench                                                  
//                                                                              
//      Project      :                                                  
//                                                                              
//      RCS Information                                                         
//                                                                              
//      State        :  (Exp/Stable/Reviewed/Released etc.)               
//                                                                              
//----------------------------------------------------------------------------- 


`timescale 1 ns / 10 ps

`include "ARM926EJS.vh" 
`define period 10

module ARM926EJS_ram_testbench;
  
reg  CLK;
reg  HRESETn;

initial
begin
   CLK          = 1'b0;
   HRESETn       = 1'b0; 
end

always
 #(`period/2) CLK = ~CLK;

initial
begin
  #(`period*10) 
    HRESETn = 1'b1; 
//  #170000 $stop;
  end

ARM926EJS uARM926EJS(
                     .CLK (CLK),
                     .HRESETn (HRESETn)
                    );

//initial
//begin
//$dumpfile("ARM926EJS_ram_testbench.vcd");
//$dumpvars(0, ARM926EJS_ram_testbench);
//#1 $dumpon;
//end
  
endmodule

