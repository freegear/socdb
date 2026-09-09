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
//  File Name           : MatrixDecode.v,v
//  File Revision       : 1.4
//  
//  Release Information : BusMatrix-REL1v0
//  
//-----------------------------------------------------------------------------
//  Purpose             : The MatrixDecode is used to determine which output stage
//                        is required for a particular access.
//                        
//===========================================================================--
`timescale 1ns/1ps

module MatrixDecode (    
    HCLK ,		
    HRESETn ,
    HREADYS ,

    Sel ,
    Addr ,
    Sel0 ,
    Active0 ,
    Readyout0 ,
    Resp0 ,
    Rdata0 ,
// busswitch output0

    Sel1 ,
    Active1 ,
    Readyout1 ,
    Resp1 ,
    Rdata1 ,
// busswitch output1

    Sel2 ,
    Active2 ,
    Readyout2 ,
    Resp2 ,
    Rdata2 ,
// busswitch output2

    Sel3 ,
    Active3 ,
    Readyout3 ,
    Resp3 ,
    Rdata3 ,
// busswitch output3

    Sel4 ,
    Active4 ,
    Readyout4 ,
    Resp4 ,
    Rdata4 ,
// busswitch output4

    Sel5 ,
    Active5 ,
    Readyout5 ,
    Resp5 ,
    Rdata5 ,
// busswitch output5

    Sel6 ,
    Active6 ,
    Readyout6 ,
    Resp6 ,
    Rdata6 ,
// busswitch output6

    Sel7 ,
    Active7 ,
    Readyout7 ,
    Resp7 ,
    Rdata7 ,
// busswitch output7

    Active ,
    HREADYOUTS ,
    HRESPS ,
    HRDATAS );

  
    input         HCLK;
    input         HRESETn;
    input         HREADYS;
    input         Sel;
    input  [31:0] Addr;
 
    input         Active0;
    input         Readyout0;
    input   [1:0] Resp0;
    input  [31:0] Rdata0;
// busswitch output0

    input         Active1;
    input         Readyout1;
    input   [1:0] Resp1;
    input  [31:0] Rdata1;
// busswitch output1

    input         Active2;
    input         Readyout2;
    input   [1:0] Resp2;
    input  [31:0] Rdata2;
// busswitch output2

    input         Active3;
    input         Readyout3;
    input   [1:0] Resp3;
    input  [31:0] Rdata3;
// busswitch output3

    input         Active4;
    input         Readyout4;
    input   [1:0] Resp4;
    input  [31:0] Rdata4;
// busswitch output4

    input         Active5;
    input         Readyout5;
    input   [1:0] Resp5;
    input  [31:0] Rdata5;
// busswitch output5

    input         Active6;
    input         Readyout6;
    input   [1:0] Resp6;
    input  [31:0] Rdata6;
// busswitch output6

    input         Active7;
    input         Readyout7;
    input   [1:0] Resp7;
    input  [31:0] Rdata7;
// busswitch output7

    output        Sel0;
// busswitch output0

    output        Sel1;
// busswitch output1

    output        Sel2;
// busswitch output2

    output        Sel3;
// busswitch output3

    output        Sel4;
// busswitch output4

    output        Sel5;
// busswitch output5

    output        Sel6;
// busswitch output6

    output        Sel7;
// busswitch output7

    output        Active;
    output        HREADYOUTS;
    output [1:0]  HRESPS;
    output [31:0] HRDATAS;
 
//------------------------------------------------------------------------------
// Signal declarations
//------------------------------------------------------------------------------
    wire          HCLK;
    wire          HRESETn;
    wire          HREADYS;
    wire          Sel;
    wire   [31:0] Addr;
  
    reg           Sel0;
    wire          Active0;
    wire          Readyout0;
    wire    [1:0] Resp0;
    wire   [31:0] Rdata0;
// busswitch output0

    reg           Sel1;
    wire          Active1;
    wire          Readyout1;
    wire    [1:0] Resp1;
    wire   [31:0] Rdata1;
// busswitch output1

    reg           Sel2;
    wire          Active2;
    wire          Readyout2;
    wire    [1:0] Resp2;
    wire   [31:0] Rdata2;
// busswitch output2

    reg           Sel3;
    wire          Active3;
    wire          Readyout3;
    wire    [1:0] Resp3;
    wire   [31:0] Rdata3;
// busswitch output3

    reg           Sel4;
    wire          Active4;
    wire          Readyout4;
    wire    [1:0] Resp4;
    wire   [31:0] Rdata4;
// busswitch output4

    reg           Sel5;
    wire          Active5;
    wire          Readyout5;
    wire    [1:0] Resp5;
    wire   [31:0] Rdata5;
// busswitch output5

    reg           Sel6;
    wire          Active6;
    wire          Readyout6;
    wire    [1:0] Resp6;
    wire   [31:0] Rdata6;
// busswitch output6

    reg           Sel7;
    wire          Active7;
    wire          Readyout7;
    wire    [1:0] Resp7;
    wire   [31:0] Rdata7;
// busswitch output7

    reg           Active;
    reg           HREADYOUTS;
    reg     [1:0] HRESPS;
    reg    [31:0] HRDATAS;
    reg     [2:0] AddrOutPort;
    reg     [2:0] DataOutPort;

`define true  1'b1
`define false 1'b0
//------------------------------------------------------------------------------
// Beginning of main code
//------------------------------------------------------------------------------
  
//------------------------------------------------------------------------------
// Address phase signals
//------------------------------------------------------------------------------
// The address decode is done in two stages. This is so that the address
//  decode occurs in only one process, p_AddrOutPortComb, and then the select
//  signal is factored in.
  always @ (Addr)
    begin : p_AddrOutPortComb
      case (Addr [26:24])
        3'b000: AddrOutPort  = 3'b000;
// busswitch output0
        3'b001: AddrOutPort  = 3'b001;
// busswitch output1
        3'b010: AddrOutPort  = 3'b010;
// busswitch output2
        3'b011: AddrOutPort  = 3'b011;
// busswitch output3
        3'b100: AddrOutPort  = 3'b100;
// busswitch output4
        3'b101: AddrOutPort  = 3'b101;
// busswitch output5
        3'b110: AddrOutPort  = 3'b110;
// busswitch output6
        3'b111: AddrOutPort  = 3'b111;
// busswitch output7
        default: AddrOutPort  = 3'b000;
      endcase
    end // block: p_AddrOutPortComb
  
  always @ (Sel or AddrOutPort)
    begin : p_SelComb
      Sel0  = 1'b0 ;
// busswitch output0
      Sel1  = 1'b0 ;
// busswitch output1
      Sel2  = 1'b0 ;
// busswitch output2
      Sel3  = 1'b0 ;
// busswitch output3
      Sel4  = 1'b0 ;
// busswitch output4
      Sel5  = 1'b0 ;
// busswitch output5
      Sel6  = 1'b0 ;
// busswitch output6
      Sel7  = 1'b0 ;
// busswitch output7
      if  (Sel)
      begin 
        case (AddrOutPort)
          3'b000: Sel0  = 1'b1 ;
// busswitch output0          
          3'b001: Sel1  = 1'b1 ;
// busswitch output1
          3'b010: Sel2  = 1'b1 ;
// busswitch output2
          3'b011: Sel3  = 1'b1 ;
// busswitch output3
          3'b100: Sel4  = 1'b1 ;
// busswitch output4
          3'b101: Sel5  = 1'b1 ;
// busswitch output5
          3'b110: Sel6  = 1'b1 ;
// busswitch output6
          3'b111: Sel7  = 1'b1 ;
// busswitch output7
          default: begin
                   end
        endcase
      end 
    end // block: p_SelComb

  
// The decoder selects the appropriate Active signal depending on which
//  output stage is required for the transfer.
  always @ (Active0 
// busswitch output0
            or Active1 
// busswitch output1
            or Active2 
// busswitch output2
            or Active3 
// busswitch output3
            or Active4 
// busswitch output4
            or Active5 
// busswitch output5
            or Active6 
// busswitch output6
            or Active7 
// busswitch output7
            or AddrOutPort)
       
    begin : p_ActiveComb
      case (AddrOutPort )
        3'b000: Active  = Active0 ;
// busswitch output0
        3'b001: Active  = Active1 ;
// busswitch output1
        3'b010: Active  = Active2 ;
// busswitch output2
        3'b011: Active  = Active3 ;
// busswitch output3
        3'b100: Active  = Active4 ;
// busswitch output4
        3'b101: Active  = Active5 ;
// busswitch output5
        3'b110: Active  = Active6 ;
// busswitch output6
        3'b111: Active  = Active7 ;
// busswitch output7
        default: Active  = Active0 ;
      endcase
    end

//------------------------------------------------------------------------------
// Data phase signals
//------------------------------------------------------------------------------
// The DataOutPort needs to be updated when HREADY from the input stage is high.
//  Note: HREADY must be used, not HREADYOUT, because there are occaisions
//  (namely when the holding register gets loaded) when HREADYOUT may be low
//  but HREADY is high, and in this case it is important that the DataOutPort
//  gets updated.
  always @ (negedge HRESETn or posedge HCLK)
    begin : p_DataOutPortSeq
      if  ( HRESETn ==1'b0 )
        DataOutPort  <= 3'b000;
      else
        begin
        if  ( HREADYS )
          DataOutPort  <= AddrOutPort ;
        end 
    end 

  always @ (Readyout0 
// busswitch output0
            or Readyout1 
// busswitch output1
            or Readyout2 
// busswitch output2
            or Readyout3 
// busswitch output3
            or Readyout4 
// busswitch output4
            or Readyout5 
// busswitch output5
            or Readyout6 
// busswitch output6
            or Readyout7 
// busswitch output7
            or DataOutPort)
  begin : p_ReadyComb
    case (DataOutPort )
      3'b000: HREADYOUTS  = Readyout0 ;
// busswitch output0
      3'b001: HREADYOUTS  = Readyout1 ;
// busswitch output1
      3'b010: HREADYOUTS  = Readyout2 ;
// busswitch output2
      3'b011: HREADYOUTS  = Readyout3 ;
// busswitch output3
      3'b100: HREADYOUTS  = Readyout4 ;
// busswitch output4
      3'b101: HREADYOUTS  = Readyout5 ;
// busswitch output5
      3'b110: HREADYOUTS  = Readyout6 ;
// busswitch output6
      3'b111: HREADYOUTS  = Readyout7 ;
// busswitch output7
      default: HREADYOUTS  = Readyout0;
    endcase
    end 

  always @ (Resp0 
// busswitch output0
            or Resp1 
// busswitch output1
            or Resp2 
// busswitch output2
            or Resp3 
// busswitch output3
            or Resp4 
// busswitch output4
            or Resp5 
// busswitch output5
            or Resp6 
// busswitch output6
            or Resp7 
// busswitch output7
            or DataOutPort)
  begin : p_RespComb
    case (DataOutPort )
      3'b000: HRESPS  = Resp0 ;
// busswitch output0
      3'b001: HRESPS  = Resp1 ;
// busswitch output1
      3'b010: HRESPS  = Resp2 ;
// busswitch output2
      3'b011: HRESPS  = Resp3 ;
// busswitch output3
      3'b100: HRESPS  = Resp4 ;
// busswitch output4
      3'b101: HRESPS  = Resp5 ;
// busswitch output5
      3'b110: HRESPS  = Resp6 ;
// busswitch output6
      3'b111: HRESPS  = Resp7 ;
// busswitch output7
      default: HRESPS  = Resp0;
    endcase
  end 

  always @ (Rdata0 
// busswitch output0
            or Rdata1 
// busswitch output1
            or Rdata2 
// busswitch output2
            or Rdata3 
// busswitch output3
            or Rdata4 
// busswitch output4
            or Rdata5 
// busswitch output5
            or Rdata6 
// busswitch output6
            or Rdata7 
// busswitch output7
            or DataOutPort)
    begin : p_RdataComb
    case (DataOutPort )
      3'b000: HRDATAS  = Rdata0 ;
// busswitch output0
      3'b001: HRDATAS  = Rdata1 ;
// busswitch output1
      3'b010: HRDATAS  = Rdata2 ;
// busswitch output2
      3'b011: HRDATAS  = Rdata3 ;
// busswitch output3
      3'b100: HRDATAS  = Rdata4 ;
// busswitch output4
      3'b101: HRDATAS  = Rdata5 ;
// busswitch output5
      3'b110: HRDATAS  = Rdata6 ;
// busswitch output6
      3'b111: HRDATAS  = Rdata7 ;
// busswitch output7
     default: HRDATAS  = Rdata0 ;
   endcase
 end 

endmodule
