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
//  File Name           : RoundArb3.v,v
//  File Revision       : 1.3
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
    ReqPort1 ,
    ReqPort2 ,
    ReqPort3 ,
    HREADYM ,
    HSELM ,
    HTRANSM ,
    HMASTLOCKM ,
    AddrInPort ,
    NoPort );
  
    input        HCLK;
    input        HRESETn;
    input        ReqPort0;
    input        ReqPort1;
    input        ReqPort2;
    input        ReqPort3;
    input        HREADYM;
    input        HSELM;
    input  [1:0] HTRANSM;
    input        HMASTLOCKM;
    output [2:0] AddrInPort;
    output       NoPort;
      
//------------------------------------------------------------------------------
// Signal declaration
//------------------------------------------------------------------------------
    wire       HCLK;
    wire       HRESETn;
    wire       ReqPort0;
    wire       ReqPort1;
    wire       ReqPort2;
    wire       ReqPort3;
    wire       HREADYM;
    wire       HSELM;
    wire [1:0] HTRANSM;
    wire       HMASTLOCKM;
    wire [2:0] AddrInPort;
    wire       NoPort;
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
//  version of the arbitration logic uses a round-robin scheme.
// For example if port 1 is currently in use then the arbiter will first check
//  if port 2 requires access, then it checks port 3, then port 4 etc. When
//  port 2 is currently in use it will check port 3 first then port 4 and
//  all  remaining ports, before finally checking port 1.
// If none of the input ports are requesting then the current port will
//  remain active if it is performing IDLE transfers to the selected slave. If
//  this is not the case then the NoPort signal will be asserted which 
//  indicates that no input port should be selected.

  always @ (ReqPort0 or ReqPort1 or ReqPort2 or ReqPort3 or HMASTLOCKM or HSELM
            or iNoPort or iAddrInPort)
  begin : p_SelPortComb
// Default values are used for AddrInPortNext and NoPortNext
    NoPortNext   = 1'b0 ;
    AddrInPortNext = iAddrInPort ;

    if  ( HMASTLOCKM )
      AddrInPortNext  = iAddrInPort ;
    else if ( iNoPort )
    begin 
      if  ( ReqPort0 )
        AddrInPortNext  = 3'b000;
      else if ( ReqPort1 )
        AddrInPortNext  = 3'b001;
      else if ( ReqPort2 )
        AddrInPortNext  = 3'b010;
      else if ( ReqPort3 )
        AddrInPortNext  = 3'b011;
      else
        NoPortNext  = 1'b1 ;
    end

    else
    begin
      case (iAddrInPort )
        3'b000: begin
          if  ( ReqPort1 )
            AddrInPortNext  = 3'b001;
          else if ( ReqPort2 )
            AddrInPortNext  = 3'b010;
          else if ( ReqPort3 )
            AddrInPortNext  = 3'b011;
          else if ( HSELM )
            AddrInPortNext  = 3'b000;
          else
            NoPortNext  = 1'b1 ;
        end

        3'b001: begin
          if  ( ReqPort2 )
            AddrInPortNext  = 3'b010;
          else if ( ReqPort3 )
            AddrInPortNext  = 3'b011;
          else if ( ReqPort0 )
            AddrInPortNext  = 3'b000;
          else if ( HSELM )
            AddrInPortNext  = 3'b001;
          else
            NoPortNext  = 1'b1 ;
        end

        3'b010: begin
          if  ( ReqPort3 )
            AddrInPortNext  = 3'b011;
          else if ( ReqPort0 )
            AddrInPortNext  = 3'b000;
          else if ( ReqPort1 )
            AddrInPortNext  = 3'b001;
          else if ( HSELM )
            AddrInPortNext  = 3'b010;
          else
            NoPortNext  = 1'b1 ;
        end
     
        3'b011: begin
          if  ( ReqPort0 )
            AddrInPortNext  = 3'b000;
          else if ( ReqPort1 )
            AddrInPortNext  = 3'b001;
          else if ( ReqPort2 )
            AddrInPortNext  = 3'b010;
          else if ( HSELM )
            AddrInPortNext  = 3'b011;
          else
            NoPortNext  = 1'b1 ;
        end
     
        default: begin
          NoPortNext  = 1'b1 ;
        end

      endcase
    end 
  end

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
