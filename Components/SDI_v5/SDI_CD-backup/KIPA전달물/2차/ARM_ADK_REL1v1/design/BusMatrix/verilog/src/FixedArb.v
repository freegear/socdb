//===========================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 2001 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//  
//
//-----------------------------------------------------------------------------
//  Version and Release Control Information:
//  
//  File Name           : FixedArb.v,v
//  File Revision       : 1.5
//  
//  Release Information : BusMatrix-REL1v0
//  
//-----------------------------------------------------------------------------
//  Purpose             : The Output Arbitration is used to determine which 
//                        of the input stages will be given access to the 
//                        shared slave.
//                        
//===========================================================================--
`timescale 1ns/1ps

module OutputArb (    
    HCLK ,
    HRESETn ,
    ReqPort0 ,
// busswitch input0
    ReqPort1 ,
// busswitch input1
    ReqPort2 ,
// busswitch input2
    ReqPort3 ,
// busswitch input3
    ReqPort4 ,
// busswitch input4
    ReqPort5 ,
// busswitch input5
    ReqPort6 ,
// busswitch input6
    ReqPort7 ,
// busswitch input7
    HREADYM ,
    HSELM ,
    HTRANSM ,
    HMASTLOCKM ,
    AddrInPort ,
    NoPort );

    input        HCLK;
    input        HRESETn;
    input        ReqPort0;
// busswitch input0
    input        ReqPort1;
// busswitch input1
    input        ReqPort2;
// busswitch input2
    input        ReqPort3;
// busswitch input3
    input        ReqPort4;
// busswitch input4
    input        ReqPort5;
// busswitch input5
    input        ReqPort6;
// busswitch input6
    input        ReqPort7;
// busswitch input7
    input        HREADYM;
    input        HSELM;
    input  [1:0] HTRANSM;
    input        HMASTLOCKM;
    output [2:0] AddrInPort;
    output       NoPort;

    wire       HCLK;
    wire       HRESETn;
    wire       ReqPort0;
// busswitch input0
    wire       ReqPort1;
// busswitch input1
    wire       ReqPort2;
// busswitch input2
    wire       ReqPort3;
// busswitch input3
    wire       ReqPort4;
// busswitch input4
    wire       ReqPort5;
// busswitch input5
    wire       ReqPort6;
// busswitch input6
    wire       ReqPort7;
// busswitch input7
    wire       HREADYM;
    wire       HSELM;
    wire [1:0] HTRANSM;
    wire       HMASTLOCKM;
    wire [2:0] AddrInPort;
    wire       NoPort;

//------------------------------------------------------------------------------
// Signal declaration
//------------------------------------------------------------------------------
    reg  [2:0] AddrInPortNext;
    reg        NoPortNext;
    reg  [2:0] iAddrInPort;
    reg        iNoPort;

`define true  1'b1
`define false 1'b0

//------------------------------------------------------------------------------
// Beginning of main code
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
// Port Selection
//------------------------------------------------------------------------------
// The Output Arbitration function looks at all the requests to use the
//  output port and determines which is the highest priority request. This
//  version of the arbitration logic uses a fixed priority scheme where input
//  port 0 is the highest priority, input port 1 is the second highest
//  priority, etc.
// If none of the input ports are requesting then the current port will
//  remain active if it is performing IDLE transfers to the selected slave. If
//  this is not the case then the NoPort signal will be asserted which 
//  indicates that no input port should be selected.
  
  always @ (ReqPort0 
// busswitch input0
            or ReqPort1 
// busswitch input1
            or ReqPort2 
// busswitch input2
            or ReqPort3 
// busswitch input3
            or ReqPort4 
// busswitch input4
            or ReqPort5 
// busswitch input5
            or ReqPort6 
// busswitch input6
            or ReqPort7 
// busswitch input7
            or HSELM or HTRANSM or HMASTLOCKM or iAddrInPort)

  begin : p_SelPortComb
// Default values are used for AddrInPortNext and NoPortNext
    NoPortNext  = 1'b0 ;
    AddrInPortNext  = iAddrInPort ;

    if  ( HMASTLOCKM )
     AddrInPortNext  = iAddrInPort ;
    else if ( ((ReqPort0 ) || (((iAddrInPort ==3'b000) & (HSELM )) & (HTRANSM !=2'b00))))
     AddrInPortNext  = 3'b000;
// busswitch input0
    else if ( ((ReqPort1 ) || (((iAddrInPort ==3'b001) & (HSELM )) & (HTRANSM !=2'b00))))
     AddrInPortNext  = 3'b001;
// busswitch input1
    else if ( ((ReqPort2 ) || (((iAddrInPort ==3'b010) & (HSELM )) & (HTRANSM !=2'b00))))
     AddrInPortNext  = 3'b010;
// busswitch input2
    else if ( ((ReqPort3 ) || (((iAddrInPort ==3'b011) & (HSELM )) & (HTRANSM !=2'b00))))
     AddrInPortNext  = 3'b011;
// busswitch input3
    else if ( ((ReqPort4 ) || (((iAddrInPort ==3'b100) & (HSELM )) & (HTRANSM !=2'b00))))
     AddrInPortNext  = 3'b100;
// busswitch input4
    else if ( ((ReqPort5 ) || (((iAddrInPort ==3'b101) & (HSELM )) & (HTRANSM !=2'b00))))
     AddrInPortNext  = 3'b101;
// busswitch input5
    else if ( ((ReqPort6 ) || (((iAddrInPort ==3'b110) & (HSELM )) & (HTRANSM !=2'b00))))
     AddrInPortNext  = 3'b110;
// busswitch input6
    else if ( ((ReqPort7 ) || (((iAddrInPort ==3'b111) & (HSELM )) & (HTRANSM !=2'b00))))
     AddrInPortNext  = 3'b111;
// busswitch input7
    else if ( HSELM )
     AddrInPortNext  = iAddrInPort ;
    else
     NoPortNext  = 1'b1 ;
// busswitch input0
  end // block: p_SelPortComb
  

  always @ (negedge HRESETn or posedge HCLK)
  begin : p_AddrInPortReg
    if  ( HRESETn ==1'b0 )
    begin 
      iNoPort     <= 1'b1 ;
      iAddrInPort <= 3'b000;
    end
    else
    begin
      if  ( HREADYM )
      begin 
        iNoPort     <= NoPortNext ;
        iAddrInPort <= AddrInPortNext ;
      end 
    end 
  end 

  assign  AddrInPort = iAddrInPort ;
  assign  NoPort     = iNoPort ;

endmodule
