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
//  File Name           : OutputStage.v,v
//  File Revision       : 1.4
//  
//  Release Information : BusMatrix-REL1v0
//  
//-----------------------------------------------------------------------------
//  Purpose             : The Output Stage is used to route the required input
//                        stage to the shared slave output.
//                        
//===========================================================================--
`timescale 1ns/1ps

module OutputStage (    
    HCLK ,
    HRESETn ,

    // Port 0 Signals
    Sel0 ,
    Addr0 ,
    Trans0 ,
    Write0 ,
    Size0 ,
    Burst0 ,
    Prot0 ,
    Mastlock0 ,
    Wdata0 ,
    HeldTran0 ,
    Active0 ,
// busswitch input0

    // Port 1 Signals
    Sel1 ,
    Addr1 ,
    Trans1 ,
    Write1 ,
    Size1 ,
    Burst1 ,
    Prot1 ,
    Mastlock1 ,
    Wdata1 ,
    HeldTran1 ,
    Active1 ,
// busswitch input1

    // Port 2 Signals
    Sel2 ,
    Addr2 ,
    Trans2 ,
    Write2 ,
    Size2 ,
    Burst2 ,
    Prot2 ,
    Mastlock2 ,
    Wdata2 ,
    HeldTran2 ,
    Active2 ,
// busswitch input2

    // Port 3 Signals
    Sel3 ,
    Addr3 ,
    Trans3 ,
    Write3 ,
    Size3 ,
    Burst3 ,
    Prot3 ,
    Mastlock3 ,
    Wdata3 ,
    HeldTran3 ,
    Active3 ,
// busswitch input3

    // Port 4 Signals
    Sel4 ,
    Addr4 ,
    Trans4 ,
    Write4 ,
    Size4 ,
    Burst4 ,
    Prot4 ,
    Mastlock4 ,
    Wdata4 ,
    HeldTran4 ,
    Active4 ,
// busswitch input4

    // Port 5 Signals
    Sel5 ,
    Addr5 ,
    Trans5 ,
    Write5 ,
    Size5 ,
    Burst5 ,
    Prot5 ,
    Mastlock5 ,
    Wdata5 ,
    HeldTran5 ,
    Active5 ,
// busswitch input5

    // Port 6 Signals
    Sel6 ,
    Addr6 ,
    Trans6 ,
    Write6 ,
    Size6 ,
    Burst6 ,
    Prot6 ,
    Mastlock6 ,
    Wdata6 ,
    HeldTran6 ,
    Active6 ,
// busswitch input6

    // Port 7 Signals
    Sel7 ,
    Addr7 ,
    Trans7 ,
    Write7 ,
    Size7 ,
    Burst7 ,
    Prot7 ,
    Mastlock7 ,
    Wdata7 ,
    HeldTran7 ,
    Active7 ,
// busswitch input7

    // Slave Address/Control Signals
    HSELM ,
    HADDRM ,
    HTRANSM ,
    HWRITEM ,
    HSIZEM ,
    HBURSTM ,
    HPROTM ,
    HMASTLOCKM ,
    HREADYM ,
    HWDATAM ,

    // Slave read data and response0
    HREADYOUTM );
  
//------------------------------------------------------------------------------
// Constant declarations
//------------------------------------------------------------------------------
    input        HCLK;
    input        HRESETn;
    input        Sel0;
    input [31:0] Addr0;
    input  [1:0] Trans0;
    input        Write0;
    input  [2:0] Size0;
    input  [2:0] Burst0;
    input  [3:0] Prot0;
    input        Mastlock0;
    input [31:0] Wdata0;
    input        HeldTran0;
// busswitch input0
    input        Sel1;
    input [31:0] Addr1;
    input  [1:0] Trans1;
    input        Write1;
    input  [2:0] Size1;
    input  [2:0] Burst1;
    input  [3:0] Prot1;
    input        Mastlock1;
    input [31:0] Wdata1;
    input        HeldTran1;
// busswitch input1
    input        Sel2;
    input [31:0] Addr2;
    input  [1:0] Trans2;
    input        Write2;
    input  [2:0] Size2;
    input  [2:0] Burst2;
    input  [3:0] Prot2;
    input        Mastlock2;
    input [31:0] Wdata2;
    input        HeldTran2;
// busswitch input2
    input        Sel3;
    input [31:0] Addr3;
    input  [1:0] Trans3;
    input        Write3;
    input  [2:0] Size3;
    input  [2:0] Burst3;
    input  [3:0] Prot3;
    input        Mastlock3;
    input [31:0] Wdata3;
    input        HeldTran3;
// busswitch input3
    input        Sel4;
    input [31:0] Addr4;
    input  [1:0] Trans4;
    input        Write4;
    input  [2:0] Size4;
    input  [2:0] Burst4;
    input  [3:0] Prot4;
    input        Mastlock4;
    input [31:0] Wdata4;
    input        HeldTran4;
// busswitch input4
    input        Sel5;
    input [31:0] Addr5;
    input  [1:0] Trans5;
    input        Write5;
    input  [2:0] Size5;
    input  [2:0] Burst5;
    input  [3:0] Prot5;
    input        Mastlock5;
    input [31:0] Wdata5;
    input        HeldTran5;
// busswitch input5
    input        Sel6;
    input [31:0] Addr6;
    input  [1:0] Trans6;
    input        Write6;
    input  [2:0] Size6;
    input  [2:0] Burst6;
    input  [3:0] Prot6;
    input        Mastlock6;
    input [31:0] Wdata6;
    input        HeldTran6;
// busswitch input6
    input        Sel7;
    input [31:0] Addr7;
    input  [1:0] Trans7;
    input        Write7;
    input  [2:0] Size7;
    input  [2:0] Burst7;
    input  [3:0] Prot7;
    input        Mastlock7;
    input [31:0] Wdata7;
    input        HeldTran7;
// busswitch input7
    input        HREADYOUTM;
  
    output        Active0;
// busswitch input0
    output        Active1;
// busswitch input1
    output        Active2;
// busswitch input2
    output        Active3;
// busswitch input3
    output        Active4;
// busswitch input4
    output        Active5;
// busswitch input5
    output        Active6;
// busswitch input6
    output        Active7;
// busswitch input7
    output        HSELM;
    output [31:0] HADDRM;
    output  [1:0] HTRANSM;
    output        HWRITEM;
    output  [2:0] HSIZEM;
    output  [2:0] HBURSTM;
    output  [3:0] HPROTM;
    output        HMASTLOCKM;
    output        HREADYM;
    output [31:0] HWDATAM;
  
  
    wire        HCLK;
    wire        HRESETn;
    wire        Sel0;
    wire [31:0] Addr0;
    wire  [1:0] Trans0;
    wire        Write0;
    wire  [2:0] Size0;
    wire  [2:0] Burst0;
    wire  [3:0] Prot0;
    wire        Mastlock0;
    wire [31:0] Wdata0;
    wire        HeldTran0;
    reg         Active0;
// busswitch input0
    wire        Sel1;
    wire [31:0] Addr1;
    wire  [1:0] Trans1;
    wire        Write1;
    wire  [2:0] Size1;
    wire  [2:0] Burst1;
    wire  [3:0] Prot1;
    wire        Mastlock1;
    wire [31:0] Wdata1;
    wire        HeldTran1;
    reg         Active1;
// busswitch input1
    wire        Sel2;
    wire [31:0] Addr2;
    wire  [1:0] Trans2;
    wire        Write2;
    wire  [2:0] Size2;
    wire  [2:0] Burst2;
    wire  [3:0] Prot2;
    wire        Mastlock2;
    wire [31:0] Wdata2;
    wire        HeldTran2;
    reg         Active2;
// busswitch input2
    wire        Sel3;
    wire [31:0] Addr3;
    wire  [1:0] Trans3;
    wire        Write3;
    wire  [2:0] Size3;
    wire  [2:0] Burst3;
    wire  [3:0] Prot3;
    wire        Mastlock3;
    wire [31:0] Wdata3;
    wire        HeldTran3;
    reg         Active3;
// busswitch input3
    wire        Sel4;
    wire [31:0] Addr4;
    wire  [1:0] Trans4;
    wire        Write4;
    wire  [2:0] Size4;
    wire  [2:0] Burst4;
    wire  [3:0] Prot4;
    wire        Mastlock4;
    wire [31:0] Wdata4;
    wire        HeldTran4;
    reg         Active4;
// busswitch input4
    wire        Sel5;
    wire [31:0] Addr5;
    wire  [1:0] Trans5;
    wire        Write5;
    wire  [2:0] Size5;
    wire  [2:0] Burst5;
    wire  [3:0] Prot5;
    wire        Mastlock5;
    wire [31:0] Wdata5;
    wire        HeldTran5;
    reg         Active5;
// busswitch input5
    wire        Sel6;
    wire [31:0] Addr6;
    wire  [1:0] Trans6;
    wire        Write6;
    wire  [2:0] Size6;
    wire  [2:0] Burst6;
    wire  [3:0] Prot6;
    wire        Mastlock6;
    wire [31:0] Wdata6;
    wire        HeldTran6;
    reg         Active6;
// busswitch input6
    wire        Sel7;
    wire [31:0] Addr7;
    wire  [1:0] Trans7;
    wire        Write7;
    wire  [2:0] Size7;
    wire  [2:0] Burst7;
    wire  [3:0] Prot7;
    wire        Mastlock7;
    wire [31:0] Wdata7;
    wire        HeldTran7;
    reg         Active7;
// busswitch input7
    wire        HSELM;
    reg  [31:0] HADDRM;
    wire  [1:0] HTRANSM;
    reg         HWRITEM;
    reg   [2:0] HSIZEM;
    reg   [2:0] HBURSTM;
    reg   [3:0] HPROTM;
    wire        HMASTLOCKM;
    wire        HREADYM;
    reg  [31:0] HWDATAM;
    wire        HREADYOUTM;
  
//------------------------------------------------------------------------------
// Signal declaration
//------------------------------------------------------------------------------
    wire        ReqPort0;
// busswitch input0
    wire        ReqPort1;
// busswitch input1
    wire        ReqPort2;
// busswitch input2
    wire        ReqPort3;
// busswitch input3
    wire        ReqPort4;
// busswitch input4
    wire        ReqPort5;
// busswitch input5
    wire        ReqPort6;
// busswitch input6
    wire        ReqPort7;
// busswitch input7

    wire  [2:0] AddrInPort;
    reg   [2:0] DataInPort;
    wire        NoPort;
    reg         SlaveSel;
    reg         iHSELM;
    reg   [1:0] iHTRANSM;
    reg         iHREADYM;
    reg         iHMASTLOCKM;

//------------------------------------------------------------------------------
// Constant declarations
//------------------------------------------------------------------------------
`define RSP_OKAY 2'b00
`define true  1'b1
`define false 1'b0
  
//------------------------------------------------------------------------------
// Beginning of main code
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
// Port Selection
//------------------------------------------------------------------------------

  assign ReqPort0  = (HeldTran0 & Sel0) ? 1'b1 : 1'b0 ;
// busswitch input0
  assign ReqPort1  = (HeldTran1 & Sel1) ? 1'b1 : 1'b0 ;
// busswitch input1
  assign ReqPort2  = (HeldTran2 & Sel2) ? 1'b1 : 1'b0 ;
// busswitch input2
  assign ReqPort3  = (HeldTran3 & Sel3) ? 1'b1 : 1'b0 ;
// busswitch input3
  assign ReqPort4  = (HeldTran4 & Sel4) ? 1'b1 : 1'b0 ;
// busswitch input4
  assign ReqPort5  = (HeldTran5 & Sel5) ? 1'b1 : 1'b0 ;
// busswitch input5
  assign ReqPort6  = (HeldTran6 & Sel6) ? 1'b1 : 1'b0 ;
// busswitch input6
  assign ReqPort7  = (HeldTran7 & Sel7) ? 1'b1 : 1'b0 ;
// busswitch input7

  OutputArb  uOutputArb 
	(
        .HCLK       (HCLK),
	.HRESETn    (HRESETn),
	.ReqPort0   (ReqPort0),
// busswitch input0 
	.ReqPort1   (ReqPort1),
// busswitch input1
	.ReqPort2   (ReqPort2),
// busswitch input2
	.ReqPort3   (ReqPort3),
// busswitch input3 
	.ReqPort4   (ReqPort4),
// busswitch input4 
	.ReqPort5   (ReqPort5),
// busswitch input5 
	.ReqPort6   (ReqPort6),
// busswitch input6 
	.ReqPort7   (ReqPort7),
// busswitch input7 
	.HREADYM    (iHREADYM),
	.HSELM      (iHSELM),
	.HTRANSM    (iHTRANSM),
	.HMASTLOCKM (iHMASTLOCKM),
	.AddrInPort (AddrInPort),
	.NoPort     (NoPort)
	);

  always @ (AddrInPort or NoPort)
  begin : p_ActiveComb
    // Default values
    Active0  = 1'b0 ;
// busswitch input0
    Active1  = 1'b0 ;
// busswitch input1
    Active2  = 1'b0 ;
// busswitch input2
    Active3  = 1'b0 ;
// busswitch input3
    Active4  = 1'b0 ;
// busswitch input4
    Active5  = 1'b0 ;
// busswitch input5
    Active6  = 1'b0 ;
// busswitch input6
    Active7  = 1'b0 ;
// busswitch input7
    if  ( NoPort ==1'b0 )
    begin 
      case (AddrInPort )
        3'b000: Active0  = 1'b1 ;
// busswitch input0
        3'b001: Active1  = 1'b1 ;
// busswitch input1 
        3'b010: Active2  = 1'b1 ;
// busswitch input2
        3'b011: Active3  = 1'b1 ;
// busswitch input3
        3'b100: Active4  = 1'b1 ;
// busswitch input4
        3'b101: Active5  = 1'b1 ;
// busswitch input5
        3'b110: Active6  = 1'b1 ;
// busswitch input6
        3'b111: Active7  = 1'b1 ;
// busswitch input7
      endcase
    end 
  end 

  always @ (Sel0 or Addr0 or Trans0 or Write0 or Size0 or Burst0 or Prot0 or Mastlock0
// busswitch input0
               or Sel1 or Addr1 or Trans1 or Write1 or Size1 or Burst1 or Prot1 or Mastlock1
// busswitch input1
               or Sel2 or Addr2 or Trans2 or Write2 or Size2 or Burst2 or Prot2 or Mastlock2
// busswitch input2
               or Sel3 or Addr3 or Trans3 or Write3 or Size3 or Burst3 or Prot3 or Mastlock3
// busswitch input3
               or Sel4 or Addr4 or Trans4 or Write4 or Size4 or Burst4 or Prot4 or Mastlock4
// busswitch input4
               or Sel5 or Addr5 or Trans5 or Write5 or Size5 or Burst5 or Prot5 or Mastlock5
// busswitch input5
               or Sel6 or Addr6 or Trans6 or Write6 or Size6 or Burst6 or Prot6 or Mastlock6
// busswitch input6
               or Sel7 or Addr7 or Trans7 or Write7 or Size7 or Burst7 or Prot7 or Mastlock7
// busswitch input7
               or AddrInPort or NoPort)
  begin : p_AddrMux
    if  ( NoPort )
    begin 
      iHSELM      = 1'b0 ;
      HADDRM      = {32{1'b0}};
      iHTRANSM    = {2{1'b0}};
      HWRITEM     = 1'b0 ;
      HSIZEM      = {3{1'b0}};
      HBURSTM     = {3{1'b0}};
      HPROTM      = {4{1'b0}};
      iHMASTLOCKM = 1'b0 ;
    end
    else
    begin
      case (AddrInPort)

        3'b000: begin
          iHSELM      = Sel0 ;
          HADDRM      = Addr0 ;
          iHTRANSM    = Trans0 ;
          HWRITEM     = Write0 ;
          HSIZEM      = Size0 ;
          HBURSTM     = Burst0 ;
          HPROTM      = Prot0 ;
          iHMASTLOCKM = Mastlock0 ;
// busswitch input0
        end

        3'b001: begin
          iHSELM      = Sel1 ;
          HADDRM      = Addr1 ;
          iHTRANSM    = Trans1 ;
          HWRITEM     = Write1 ;
          HSIZEM      = Size1 ;
          HBURSTM     = Burst1 ;
          HPROTM      = Prot1 ;
          iHMASTLOCKM = Mastlock1 ;
// busswitch input1
        end

        3'b010: begin
          iHSELM      = Sel2 ;
          HADDRM      = Addr2 ;
          iHTRANSM    = Trans2 ;
          HWRITEM     = Write2 ;
          HSIZEM      = Size2 ;
          HBURSTM     = Burst2 ;
          HPROTM      = Prot2 ;
          iHMASTLOCKM = Mastlock2 ;
// busswitch input2
        end

        3'b011: begin
          iHSELM      = Sel3 ;
          HADDRM      = Addr3 ;
          iHTRANSM    = Trans3 ;
          HWRITEM     = Write3 ;
          HSIZEM      = Size3 ;
          HBURSTM     = Burst3 ;
          HPROTM      = Prot3 ;
          iHMASTLOCKM = Mastlock3 ;
// busswitch input3
        end

        3'b100: begin
          iHSELM      = Sel4 ;
          HADDRM      = Addr4 ;
          iHTRANSM    = Trans4 ;
          HWRITEM     = Write4 ;
          HSIZEM      = Size4 ;
          HBURSTM     = Burst4 ;
          HPROTM      = Prot4 ;
          iHMASTLOCKM = Mastlock4 ;
// busswitch input4
        end

        3'b101: begin
          iHSELM      = Sel5 ;
          HADDRM      = Addr5 ;
          iHTRANSM    = Trans5 ;
          HWRITEM     = Write5 ;
          HSIZEM      = Size5 ;
          HBURSTM     = Burst5 ;
          HPROTM      = Prot5 ;
          iHMASTLOCKM = Mastlock5 ;
// busswitch input5
        end

        3'b110: begin
          iHSELM      = Sel6 ;
          HADDRM      = Addr6 ;
          iHTRANSM    = Trans6 ;
          HWRITEM     = Write6 ;
          HSIZEM      = Size6 ;
          HBURSTM     = Burst6 ;
          HPROTM      = Prot6 ;
          iHMASTLOCKM = Mastlock6 ;
// busswitch input6
        end

        3'b111: begin
          iHSELM      = Sel7 ;
          HADDRM      = Addr7 ;
          iHTRANSM    = Trans7 ;
          HWRITEM     = Write7 ;
          HSIZEM      = Size7 ;
          HBURSTM     = Burst7 ;
          HPROTM      = Prot7 ;
          iHMASTLOCKM = Mastlock7 ;
// busswitch input7
        end

        default: begin
          iHSELM      = Sel0 ;
          HADDRM      = Addr0 ;
          iHTRANSM    = Trans0 ;
          HWRITEM     = Write0 ;
          HSIZEM      = Size0 ;
          HBURSTM     = Burst0 ;
          HPROTM      = Prot0 ;
          iHMASTLOCKM = Mastlock0 ;
        end
      endcase
    end 
  end 


  assign  HTRANSM  = iHTRANSM ;
  assign  HSELM  = iHSELM ;
  assign  HMASTLOCKM  = iHMASTLOCKM ;
  
  always @ (negedge HRESETn or posedge HCLK)
  begin : p_DataInPortReg
    if  ( HRESETn ==1'b0 )
     DataInPort  <= 3'b000;
    else
    begin
     if  ( iHREADYM )
      DataInPort  <= AddrInPort ;
    end 
  end 

  always @ (Wdata0 
// busswitch input0
            or Wdata1 
// busswitch input1
            or Wdata2 
// busswitch input2
            or Wdata3 
// busswitch input3
            or Wdata4 
// busswitch input4
            or Wdata5 
// busswitch input5
            or Wdata6 
// busswitch input6
            or Wdata7 
// busswitch input7
            or DataInPort)
  begin : p_DataMux
    case (DataInPort )
      3'b000: HWDATAM  = Wdata0 ;
// busswitch input0
      3'b001: HWDATAM  = Wdata1 ;
// busswitch input1
      3'b010: HWDATAM  = Wdata2 ;
// busswitch input2
      3'b011: HWDATAM  = Wdata3 ;
// busswitch input3
      3'b100: HWDATAM  = Wdata4 ;
// busswitch input4
      3'b101: HWDATAM  = Wdata5 ;
// busswitch input5
      3'b110: HWDATAM  = Wdata6 ;
// busswitch input6
      3'b111: HWDATAM  = Wdata7 ;
// busswitch input7
      default: HWDATAM  = Wdata0 ;
    endcase
  end 

// The HREADY signal on the shared slave is generated directly from
//  the shared slave HREADYOUTS if the slave is selected, otherwise
//  it mirrors the HREADY signal of the appropriate input port.
//  it is driven HIGH.
  always @ (negedge HRESETn or posedge HCLK)
  begin : p_SlaveSelReg
    if  ( HRESETn ==1'b0 )
      SlaveSel  <= 1'b0 ;
    else
    begin
      if  ( iHREADYM )
        SlaveSel  <= iHSELM ;
    end 
  end 

  always @ (SlaveSel or HREADYOUTM)
  begin : p_HREADYSComb
    if  ( SlaveSel )
      iHREADYM  = HREADYOUTM ;
    else
      iHREADYM  = 1'b1 ;
  end 

  assign  HREADYM  = iHREADYM ;

endmodule
